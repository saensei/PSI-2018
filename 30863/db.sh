#!/bin/bash

echo "192.168.56.10 www" > /etc/hosts
echo "192.168.56.11 www1" >> /etc/hosts
echo "192.168.56.12 www2" >> /etc/hosts
echo "192.168.56.21 gfs1" >> /etc/hosts
echo "192.168.56.22 gfs2" >> /etc/hosts
echo "192.168.56.23 gfs3" >> /etc/hosts
echo "192.168.56.30 db0" >> /etc/hosts
echo "192.168.56.31 db1" >> /etc/hosts
echo "192.168.56.32 db2" >> /etc/hosts

apt-get install -y heartbeat drbd8-utils
debconf-set-selections <<< 'mysql-server mysql-server/root_password password qwerty'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password qwerty'
apt-get -y install mysql-server
mysql -u root -pqwerty -e "CREATE DATABASE wp;"
mysql -u root -pqwerty -e "GRANT ALL PRIVILEGES ON wp.* TO 'wp'@'192.168.56.%' IDENTIFIED BY 'qwerty';"
mysql -u root -pqwerty -e "FLUSH PRIVILEGES;"
systemctl stop mysql
systemctl disable mysql
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
sed -i "s/datadir.*/datadir = \/mysqldata/" /etc/mysql/my.cnf
modprobe drbd
swapoff -a
dd if=/dev/zero of=/dev/sda5

echo "global {" > /etc/drbd.conf
echo "  usage-count no;" >> /etc/drbd.conf
echo "}" >> /etc/drbd.conf
echo "include \"drbd.d/*.res\";" >> /etc/drbd.conf
echo "common {" >> /etc/drbd.conf
echo "  protocol C;" >> /etc/drbd.conf
echo "  syncer {" >> /etc/drbd.conf
echo "    rate 100M;" >> /etc/drbd.conf
echo "    al-extents 1801;" >> /etc/drbd.conf
echo "  }" >> /etc/drbd.conf
echo "  startup {" >> /etc/drbd.conf
echo "    degr-wfc-timeout 0;" >> /etc/drbd.conf
echo "  }" >> /etc/drbd.conf
echo "  disk {" >> /etc/drbd.conf
echo "    on-io-error detach;" >> /etc/drbd.conf
echo "  }" >> /etc/drbd.conf
echo "  net {" >> /etc/drbd.conf
echo "    after-sb-0pri disconnect;" >> /etc/drbd.conf
echo "    after-sb-1pri disconnect;" >> /etc/drbd.conf
echo "    after-sb-2pri disconnect;" >> /etc/drbd.conf
echo "    rr-conflict   disconnect;" >> /etc/drbd.conf
echo "  }" >> /etc/drbd.conf
echo "}" >> /etc/drbd.conf

rm -f /etc/drbd.d/global_common.conf
echo "resource drbd1 {" > /etc/drbd.d/drbd1.res
echo "handlers {" >> /etc/drbd.d/drbd1.res
echo "  pri-on-incon-degr \"echo 0 > /proc/sysrq-trigger ; halt -f\";" >> /etc/drbd.d/drbd1.res
echo "  pri-lost-after-sb \"echo 0 > /proc/sysrq-trigger ; halt -f\";" >> /etc/drbd.d/drbd1.res
echo "  local-io-error \"echo 0 > /proc/sysrq-trigger ; halt -f\";" >> /etc/drbd.d/drbd1.res
echo " }" >> /etc/drbd.d/drbd1.res
echo "device /dev/drbd0;" >> /etc/drbd.d/drbd1.res
echo "disk /dev/sda5;" >> /etc/drbd.d/drbd1.res
echo "meta-disk internal;" >> /etc/drbd.d/drbd1.res
echo "on db1 {" >> /etc/drbd.d/drbd1.res
echo "  address 192.168.56.31:7789;" >> /etc/drbd.d/drbd1.res
echo " }" >> /etc/drbd.d/drbd1.res
echo "on db2 {" >> /etc/drbd.d/drbd1.res
echo "  address 192.168.56.32:7789;" >> /etc/drbd.d/drbd1.res
echo " }" >> /etc/drbd.d/drbd1.res
echo "}" >> /etc/drbd.d/drbd1.res

drbdadm create-md drbd1
drbdadm up drbd1
mkdir /mysqldata
if [[ `hostname` == "db1" ]]; then
 drbdadm -- --overwrite-data-of-peer primary drbd1
 sleep 120
 drbdadm primary drbd1
 sleep 10
 mkfs.ext4 -F /dev/drbd0
 sleep 10
 mount /dev/drbd0 /mysqldata
 rsync -za /var/lib/mysql/* /mysqldata/
 chown -R mysql:mysql /mysqldata
 umount /mysqldata
else
 drbdadm secondary drbd1
 rsync -za /var/lib/mysql/* /mysqldata/
 chown -R mysql:mysql /mysqldata
fi

echo "auth 1" > /etc/ha.d/authkeys
echo "1 crc" >> /etc/ha.d/authkeys
chmod 600 /etc/ha.d/authkeys

echo "debugfile /var/log/ha-debug" > /etc/ha.d/ha.cf
echo "logfile /var/log/ha-log" >> /etc/ha.d/ha.cf
echo "logfacility local0" >> /etc/ha.d/ha.cf
echo "keepalive 100ms" >> /etc/ha.d/ha.cf
echo "deadtime 1" >> /etc/ha.d/ha.cf
echo "warntime 500ms" >> /etc/ha.d/ha.cf
echo "initdead 10" >> /etc/ha.d/ha.cf
echo "node db1" >> /etc/ha.d/ha.cf
echo "ucast eth1 192.168.56.31" >> /etc/ha.d/ha.cf
echo "node db2" >> /etc/ha.d/ha.cf
echo "ucast eth1 192.168.56.32" >> /etc/ha.d/ha.cf
echo "udpport 694" >> /etc/ha.d/ha.cf
echo "auto_failback on" >> /etc/ha.d/ha.cf

echo "db1 drbddisk::drbd1 Filesystem::/dev/drbd0::/mysqldata::ext4 mysql IPaddr::192.168.56.30" > /etc/ha.d/haresources
systemctl enable heartbeat.service
systemctl restart heartbeat.service
if [[ `hostname` == "db1" ]]; then
 sleep 30
 /usr/share/heartbeat/hb_takeover
fi
