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

apt-get install -y glusterfs-server
mkdir -p /var/www

if [[ `hostname` == "gfs1" ]]; then
 gluster peer probe gfs1
 gluster peer probe gfs2
 gluster peer probe gfs3
 gluster peer status
 sleep 60
 gluster volume create html replica 3 transport tcp gfs1:/var/www/html gfs2:/var/www/html gfs3:/var/www/html force
 sleep 10
 gluster volume set html auth.allow 192.168.56.*
 gluster volume start html
fi
