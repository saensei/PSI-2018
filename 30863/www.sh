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

apt-get install -y php5 heartbeat glusterfs-client php5-mysql
apachectl stop
systemctl disable apache2

echo "auth 1" > /etc/ha.d/authkeys
echo "1 crc" >> /etc/ha.d/authkeys
chmod 600 /etc/ha.d/authkeys

echo "debugfile /var/log/ha-debug" > /etc/ha.d/ha.cf
echo "logfile /var/log/ha-log" >> /etc/ha.d/ha.cf
echo "logfacility local0" >> /etc/ha.d/ha.cf
echo "keepalive 100ms" >> /etc/ha.d/ha.cf
echo "warntime 500ms" >> /etc/ha.d/ha.cf
echo "deadtime 1" >> /etc/ha.d/ha.cf
echo "initdead 10" >> /etc/ha.d/ha.cf
echo "node www1" >> /etc/ha.d/ha.cf
echo "ucast eth1 192.168.56.11" >> /etc/ha.d/ha.cf
echo "node www2" >> /etc/ha.d/ha.cf
echo "ucast eth1 192.168.56.12" >> /etc/ha.d/ha.cf
echo "udpport 694" >> /etc/ha.d/ha.cf
echo "auto_failback on" >> /etc/ha.d/ha.cf

echo "www1 192.168.56.10 apache2" > /etc/ha.d/haresources
echo "ServerName www1" >> /etc/apache2/sites-available/000-default.conf
mount.glusterfs gfs1:/html /var/www/html
echo "gfs1:/html /var/www/html nfs defaults,_netdev,mountproto=tcp 0 0" >> /etc/fstab

if [[ `hostname` == "www1" ]]; then
 wget -q https://wordpress.org/latest.tar.gz
 tar -zxf latest.tar.gz
 mv wordpress/* /var/www/html/
 rm -rf latest.tar.gz wordpress
 mv /tmp/wp-config.php /var/www/html/
 rm -f /var/www/html/wp-config-sample.php
 chown -R www-data:www-data /var/www/html
 curl "http://192.168.56.10/wp-admin/install.php?step=2" --data-urlencode "weblog_title=wp" --data-urlencode "user_name=wp" --data-urlencode "admin_email=wp@localhost.localdomain" --data-urlencode "admin_password=qwerty" --data-urlencode "admin_password2=qwerty" --data-urlencode "pw_weak=1"
fi

systemctl enable heartbeat.service
systemctl start heartbeat.service
