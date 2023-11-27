# Packer Template para Proxmox com Ubuntu Server 22.04, Docker e Ansible
# ---
# Plugins Necessários
packer {
  required_plugins {
    proxmox = {
      version = " >= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
# Definição de Variáveis (credentials.pkr.hcl)
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

# Definição de recursos para a criação do template
source "proxmox-iso" "ubuntu-docker-ansible" {
 
    # Configurações de Acesso ao Proxmox
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # (Opcional) Pular a verificação TLS
    insecure_skip_tls_verify = true
    
    # Configurações Gerais da VM
    node = "pve" #Node do Proxmox
    vm_id = "830" #Número do Template
    vm_name = "ubuntu-server-2204-docker-ansible" #Nome do Template
    template_description = "Ubuntu Server Com Docker e Ansible" #Descrição do Template

    # Sistema Operacional Utilizado
    # (Opção 1) Arquivo ISO salvo no Proxmox
    iso_file = "local:iso/ubuntu-22.04.3-live-server-amd64.iso" #Nome do OS salvo no Proxmox

    # (Opção 2) Baixar ISO durante a instalação
    # iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
    # iso_checksum = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"

    iso_storage_pool = "local"
    unmount_iso = true

    # Configurações de Agente na VM
    qemu_agent = true

    # Configurações de Disco na VM
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "20G" #Tamanho do Disco
        format = "raw"
        storage_pool = "local-lvm" #Disco no Proxmox
        type = "virtio"
    }

    # Configurações de CPU na VM
    cores = "1"
    
    # Configurações de Memória na VM
    memory = "1024" 

    # Configurações de Rede da VM
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    # Configurações do Cloud-Init
    cloud_init = true
    cloud_init_storage_pool = "local-lvm" #Disco no Proxmox

    # Comandos de Boot do Packer (instalação manual do OS)
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    boot = "c"
    boot_wait = "5s"

    # Auto instalação do PACKER
    http_directory = "http" 

    # Nome do usuário SSH
    ssh_username = "<user>" 

    # (Opção 1) Senha do SSH
    # ssh_password = "<password>"

    # (Opção 2) Adicionar a chave SSH Privada
    ssh_private_key_file = "~/.ssh/id_rsa" #Local onde está a sua chave SSH Privada
    # ssh_private_key_file = "../id_rsa"

    # Tempo para esperar o SSH ser reconhecido antes de parar a aplicação
    ssh_timeout = "25m"
}

# Construindo as definições para criar a VM
build {

    name = "ubuntu-server-docker-ansible"
    sources = ["source.proxmox-iso.ubuntu-server-docker-ansible"]

    # Adicionando a integração com o Cloud-Init no Proxmox 
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # Instalando o Docker #4
    provisioner "shell" {
        inline = [
            "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
            "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
            "sudo apt-get -y update",
            "sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
        ]
    }

    # Instalando o Docker-Compose #5
    provisioner "shell" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get upgrade -y",
            "sudo apt-get install docker-compose-plugin"
        ]
    }

    # Instalando o Ansible #
    provisioner "shell" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get upgrade -y",
            "curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py",
            "sudo add-apt-repository --yes --update ppa:ansible/ansible",
            "sudo apt install ansible -y"
        ]
    }
}
