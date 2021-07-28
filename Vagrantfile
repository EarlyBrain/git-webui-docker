# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/amazonlinux-2"
  config.vm.network "forwarded_port", guest: 9000, host: 9000       # Git WebUI:latest
  config.vm.network "forwarded_port", guest: 8000, host: 8000       # cloud9
  config.vm.network "forwarded_port", guest: 8008, host: 8008       # Git WebUI:stable
  config.vm.hostname = "git-webui-docker"
  config.vm.synced_folder ".", "/var/code", type:"virtualbox"

  # root
  config.vm.provision "shell", inline: <<-'SHELL'
    # Update Packages
    yum -y update

    # Importing localhost root CA Certificate
    cp -p /var/code/etc/nginx/ssl/rootCA.pem /etc/pki/ca-trust/source/anchors/rootCA.pem
    update-ca-trust

    # Install Docker
    yum -y install docker
    usermod -a -G docker vagrant
    sudo chmod 666 /var/run/docker.sock
    curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod 744 /usr/local/bin/docker-compose
    systemctl start docker
    systemctl enable docker

    # Install Docker Plugin
    mkdir -p ~/.docker/cli-plugins
    wget -q -O ~/.docker/cli-plugins/docker-pushrm https://github.com/christian-korneck/docker-pushrm/releases/download/v1.8.0/docker-pushrm_linux_amd64
    chmod +x ~/.docker/cli-plugins/docker-pushrm

    # Docker Container Start
    pushd /var/code
    /usr/local/bin/docker-compose up -d
    popd

    # Install figlet
    wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/f/figlet-2.2.5-9.el7.x86_64.rpm
    rpm -Uvh figlet-2.2.5-9.el7.x86_64.rpm
    rm -f figlet-2.2.5-9.el7.x86_64.rpm
  SHELL

  # vagrnt
  config.vm.provision "shell", privileged: false, inline: <<-'SHELL'

    # Login Directory Setting
    cat <<-'EOS' >> ~/.bash_profile
			cd /var/code
		EOS
  SHELL

  # Startup Script
  config.vm.provision "shell", run: "always", inline: <<-'SHELL'
    docker restart cloud9
    cat <<-EOS

			`figlet -f banner 'WELCOME!!'`

			cloud9 URL
			https://localhost:8000/

			Git WebUI URL
			https://localhost:8008/

			Developer Tool.
			vagrant ssh -c "./menu.sh"

		EOS
  SHELL

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  end
end
