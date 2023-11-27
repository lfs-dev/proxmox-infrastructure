# Criação de VMs Baseadas em Templates do Packer
provider "proxmox" {

  pm_api_url          = var.proxmox_api_url
  # pm_api_url = "http://<ip>:<porta>/api2/json"
  pm_api_token_id     = var.proxmox_api_token_id
  # pm_api_token_id = "<user-name>@pam!<token-name>"
  pm_api_token_secret = var.proxmox_api_token_secret
  # pm_api_token_secret = "<token-secret>"

  # Pular verificação TLS
  pm_tls_insecure = true

}

resource "proxmox_vm_qemu" "ubuntu_vm" {

  # Definições Gerais da VM
  target_node = "pve"                         #Nome do Node no Proxmox
  count       = 1                                            #Quantidade de VMs 
  name        = "${var.vm_name}.develop" #Nome da VM
  # name        = "<nome-da-vm>" 
  desc        = "Ambiente de Desenvolvimento do Projeto ${var.vm_name}"   #Descrição   
  # desc        = "Ambiente de Produção do Projeto <nome-do-projeto>" 

  # Iniciar VM após a criação (true/false)
  onboot = true

  # Template utilizado
  clone = "<template>" #Nome do Template que será utilizado

  agent = 1

  # Processador
  cores   = 1
  sockets = 1
  cpu     = "host"

  # Memória
  memory = 1024

  # Rede predefinida no Proxmox
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Disco
  disk {
    storage = "local-lvm" #Disco no Proxmox
    type    = "virtio"
    size    = "10G" #Tamanho do Disco
  }

  # Tipo de Sistema Operacional
  os_type = "cloud-init"

  # IP e Gateway Padrão
  ipconfig0 = "ip=${var.vm_ip}/16,gw=192.168.0.1" #IPv4 e Gateway Padrão
  # ipconfig0 = "ip=<ip-da-vm>/16,gw=<seu-gateway-padrão>" 

  # Usuário padrão da(s) VMs
  ciuser     = "<user>" #Usuário 
  cipassword = "<password>"   #Senha

  # Chave SSH Pública  
  sshkeys = "${var.ssh_public_key}" #Chave SSH Pública para acessar as VMs 
  # sshkeys = <<EOF
  # <sua-chave-ssh>
  # EOF
}
