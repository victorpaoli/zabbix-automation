Vagrant.configure("2") do |config|
  
  # Box Ubuntu 22.04 LTS
  config.vm.box = "ubuntu/jammy64"

  # Definição do nome da VM e recursos.
  config.vm.provider "virtualbox" do |vb|
    vb.name = "ZabbixDockerServer"
    vb.memory = 4096
    vb.cpus = 2
  end

  # Provisionamento: Copiar o script e rodar dentro da VM.
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update && sudo apt install -y bash
  SHELL

# Copia o script de instalação do Zabbix para a VM e executá.
  config.vm.provision "file", source: "./scripts/zabbix.sh", destination: "/home/vagrant/zabbix_install.sh"
  config.vm.provision "shell", inline: <<-SHELL
    sudo chmod +x /home/vagrant/zabbix_install.sh
    sudo /home/vagrant/zabbix_install.sh
  SHELL

  #Configuração de rede
  config.vm.network "public_network", bridge: 1, ip: "192.168.2.105"
  # Redirecionar a porta 8080 (Zabbix Web) e outras portas úteis.
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 10051, host: 10051
  config.vm.network "forwarded_port", guest: 10050, host: 10050

end
