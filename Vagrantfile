Vagrant.configure("2") do |config|
  
  # Box Ubuntu 22.04 LTS
  config.vm.box = "ubuntu/jammy64"

  # Definição do nome da VM e recursos
  config.vm.provider "virtualbox" do |vb|
    vb.name = "ZabbixDockerServer"
    vb.memory = 4096
    vb.cpus = 2
  end

  # Atualização básica (bash já vem instalado, mas ok manter)
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update
  SHELL

  # Copia o script de instalação do Zabbix para a VM
  config.vm.provision "file",
    source: "./scripts/zabbix.sh",
    destination: "/home/vagrant/zabbix_install.sh"

  # Corrige CRLF, aplica permissão e executa
  config.vm.provision "shell", inline: <<-SHELL
    # Remove \\r (CRLF -> LF)
    sed -i 's/\\r$//' /home/vagrant/zabbix_install.sh

    # Garante permissões
    chmod +x /home/vagrant/zabbix_install.sh

    # Executa
    /home/vagrant/zabbix_install.sh
  SHELL

  # Configuração de rede
  config.vm.network "public_network", bridge: 1, ip: "192.168.2.105"

  # Port forwarding (útil se mudar para private_network depois)
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 10051, host: 10051
  config.vm.network "forwarded_port", guest: 10050, host: 10050

end
