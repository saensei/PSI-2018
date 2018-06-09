ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|


	#pamięć, procesor dla boxa, nazwa, gui do podglądu
	config.vm.provider "virtualbox" do |vb|

		vb.name = "MintBox"
		vb.memory = 4096
		vb.gui = true

	end

	
	#folder udostepniony, system, user, pswd
	config.vm.synced_folder ".", "/home/vagrant/shared"
	config.vm.box = "Mint"
	config.ssh.username = "vagrant"
	config.ssh.password = "vagrant"

	
	#aktualizacja, install doker, composer, mysql, wordpress, phpmyadmin, mkdirs, .yml, tiimezone, .sh reboot
	config.vm.provision "shell", inline: <<-SHELL

	
		sudo apt-get update && sudo apt-get upgrade -y
		sudo apt-get install -y docker.io
		sudo apt-get install -y docker-compose
		sudo docker pull eeacms/haproxy
		sudo docker pull wordpress
		sudo docker pull hauptmedia/mariadb:10.1
		sudo docker pull phpmyadmin/phpmyadmin
		sudo mkdir /docker
		sudo mkdir /docker/mysql
		sudo mkdir /docker/wordpress
		sudo cp /home/vagrant/shared/docker-compose.yml /docker/docker-compose.yml
		sudo chown -R vagrant /docker
		timedatectl set-timezone Europe/Warsaw
		sudo timedatectl set-ntp on
		sudo cp /home/vagrant/shared/mydocker.sh /etc/init.d/mydocker.sh
		sudo chmod +x /etc/init.d/mydocker.sh
		sudo update-rc.d mydocker.sh defaults
		sudo reboot

		
	SHELL
	

end