ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|


	#pamięć, procesor dla boxa, nazwa, gui do podglądu
	config.vm.provider "virtualbox" do |vb|

		vb.name = "MintBox"
		vb.memory = 4096
		vb.gui = true

	end

	
	#folder udostepniony, lub nie dla wersji bez udostepnienia
	#wersja bez udostępnienia tworzy pliki docker-compose i mydocker.sh dla fikołka systemu
	#config.vm.synced_folder ".", "/home/vagrant/shared"
	
	#system, user, pswd
	config.vm.box = "Mint"
	config.ssh.username = "vagrant"
	config.ssh.password = "vagrant"

	
	#aktualizacja, install doker, composer, mysql, wordpress, phpmyadmin, mkdirs, .yml, tiimezone, .sh reboot
	config.vm.provision "shell", inline: <<-SHELL

	
		#sudo apt-get update && sudo apt-get upgrade -y
		sudo apt-get install -y docker.io
		sudo apt-get install -y docker-compose
		sudo docker pull eeacms/haproxy
		sudo docker pull wordpress
		sudo docker pull hauptmedia/mariadb:10.1
		sudo docker pull phpmyadmin/phpmyadmin
		sudo mkdir /docker
		sudo mkdir /docker/mysql
		sudo mkdir /docker/wordpress
		
		#wersja bez udostepnonego foldera
		#sudo cp /home/vagrant/shared/docker-compose.yml /docker/docker-compose.yml
		sudo touch /docker/docker-compose.yml
		sudo echo -e "version: '2'

services:


  db1:
    image: hauptmedia/mariadb:10.1
    hostname: db1
    container_name: db1
    ports:
      - 13306:3306
#    volumes:
#      - ./mysql/node1:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=123
      - REPLICATION_PASSWORD=wordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
      - GALERA=On
      - NODE_NAME=db1
      - CLUSTER_NAME=maria_cluster
      - CLUSTER_ADDRESS=gcomm://
    command: --wsrep-new-cluster
    networks:
      mariadb:
        ipv4_address: 172.43.43.10


  db2:
    image: hauptmedia/mariadb:10.1
    hostname: db2
    container_name: db2
    links:
      - db1
    ports:
      - 23306:3306
#    volumes:
#      - ./mysql/node2:/var/lib/mysql
    restart: always
    environment:
      - REPLICATION_PASSWORD=wordpress
      - GALERA=On
      - NODE_NAME=db2
      - CLUSTER_NAME=maria_cluster
      - CLUSTER_ADDRESS=gcomm://db1
      - MYSQL_ROOT_PASSWORD=123
    networks:
      mariadb:
        ipv4_address: 172.43.43.11


  db3:
    image: hauptmedia/mariadb:10.1
    hostname: db3
    container_name: db3
    links:
      - db1
    ports:
      - 33306:3306
#    volumes:
#      - ./mysql/node3:/var/lib/mysql
    restart: always
    environment:
      - REPLICATION_PASSWORD=wordpress
      - GALERA=On
      - NODE_NAME=db3
      - CLUSTER_NAME=maria_cluster
      - CLUSTER_ADDRESS=gcomm://db1
      - MYSQL_ROOT_PASSWORD=123
    networks:
      mariadb:
        ipv4_address: 172.43.43.12


  adm1:
    image: phpmyadmin/phpmyadmin
    container_name: adm1
    networks:
      mariadb:
        ipv4_address: 172.43.43.13
    links:
      - db1:mysql
    restart: always
    environment:
      MYSQL_ROOT_USERNAME: root
      MYSQL_ROOT_PASSWORD: 123
      PMA_HOST: db1


  adm2:
    image: phpmyadmin/phpmyadmin
    container_name: adm2
    networks:
      mariadb:
        ipv4_address: 172.43.43.14
    links:
      - db2:mysql
    restart: always
    environment:
      MYSQL_ROOT_USERNAME: root
      MYSQL_ROOT_PASSWORD: 123
      PMA_HOST: db2


  adm3:
    image: phpmyadmin/phpmyadmin
    container_name: adm3
    networks:
      mariadb:
        ipv4_address: 172.43.43.15
    links:
      - db3:mysql
    restart: always
    environment:
      MYSQL_ROOT_USERNAME: root
      MYSQL_ROOT_PASSWORD: 123
      PMA_HOST: db3


  web1:
    image: wordpress
    container_name: web1
    networks:
      mariadb:
        ipv4_address: 172.43.43.16
    depends_on:
      - db1
    links:
      - db1:mysql
    restart: always
#    volumes:
#      - ./wordpress
    environment:
      WORDPRESS_DB_DATABASE: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_HOST: db1:3306


  web2:
    image: wordpress
    container_name: web2
    networks:
      mariadb:
        ipv4_address: 172.43.43.17
    depends_on:
      - db2
    links:
      - db2:mysql
    restart: always
#    volumes:
#      - ./wordpress
    environment:
      WORDPRESS_DB_DATABASE: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_HOST: db2:3306


  web3:
    image: wordpress
    container_name: web3
    networks:
      mariadb:
        ipv4_address: 172.43.43.18
    depends_on:
      - db3
    links:
      - db3:mysql
    restart: always
#    volumes:
#      - ./wordpress
    environment:
      WORDPRESS_DB_DATABASE: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_HOST: db3:3306


  proxy:
    image: eeacms/haproxy
    container_name: haproxy
    depends_on:
      - web1
      - web2
      - web3
    environment:
      FRONTEND_NAME: web1
      FRONTEND_PORT: 80
      BACKENDS: '172.43.43.16 172.43.43.17 172.43.43.18'
      DNS_ENABLED: 'true'
    networks:
      mariadb:
        ipv4_address: 172.43.43.7


networks:
  mariadb:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.43.43.0/24
          gateway: 172.43.43.1\n" > /docker/docker-compose.yml
		
		
		sudo chown -R vagrant /docker
		timedatectl set-timezone Europe/Warsaw
		sudo timedatectl set-ntp on
		
		#wersja bez udostpnonego foldera
		#sudo cp /home/vagrant/shared/mydocker.sh /etc/init.d/mydocker.sh
		sudo touch /etc/init.d/mydocker.sh
		sudo echo -e '#!/bin/sh

### BEGIN INIT INFO
# Provides:          mydocker
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO

case "$1" in
start)
	cd docker
	sudo docker-compose up
	;;
*)
	exit 3
	;;
esac' > /etc/init.d/mydocker.sh
		
		sudo chmod +x /etc/init.d/mydocker.sh
		sudo update-rc.d mydocker.sh defaults
		sudo reboot

		
	SHELL
	

end