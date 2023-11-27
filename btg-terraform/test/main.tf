# Configurações do Proxmox
provider "proxmox" {
  endpoint = var.proxmox_endpoint #Site do terraform
  #endpoint = "http://<ip>:<porta>/""
  api_token = var.proxmox_api_token
  #api_token = "<user>@pam!<token-name>=<token-secret>"
  insecure  = true #Configurações SSL
  ssh {
    agent    = true
    username = "root"
  }
}

# Configurações Gerais da VM
resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = "${var.vm_name}.test" #Nome da VM
  # name        = "<nome-da-vm>" 
  description = "Ambiente de Testes do Projeto ${var.vm_name}" #Descrição
  # description        = "Ambiente de Testes do Projeto <nome-do-projeto>" 
  tags        = ["${var.vm_name}"] #Tags coloridas do Proxmox
  # tags        = ["<nome-da-tag>"]
  node_name = "pve" #Nome do Node no Proxmox

  #Configurações avançadas
  agent {
    enabled = false
  }

  # Template utilizado
  clone {
    datastore_id = "local-lvm" #Disco no Proxmox
    vm_id = 900 #Número do Template no Proxmox
  }

  # Configurações de Rede e Acesso
  initialization {
    ip_config {
      ipv4 {
        address = "${var.vm_ip}/16" #IPv4
        # address = "<ip-da-vm>/16"
        gateway = "192.168.0.1" #Gateway Padrão
      }
    }

  # Usuário padrão da(s) VMs
  user_account {
      password = "<user>" #Usuário 
      username = "<password>" #Senha
    }
  }

  # Rede predefinida no Proxmox
  network_device {
    bridge = "vmbr0"
  }
}