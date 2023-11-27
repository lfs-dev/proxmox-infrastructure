# INSTRUÇÕES

## O que é o Terraform?

O Terraform é uma ferramenta de código aberto para infraestrutura como código (IaC) que permite aos desenvolvedores e operadores provisionar e gerenciar recursos de infraestrutura de forma automatizada e declarativa.

## Para que serve código?

Este código serve para provisionar VMs baseadas em templates presentes no Proxmox. Os templates utilizados neste projeto foram criados com o [Packer](https://github.com/lfs-dev/proxmox-infrastructure/tree/main/packer/ubuntu2204-docker-ansible), que também está disponível aqui no GitHub. Portanto, antes de utilizar este código certifique-se de ter um template pré configurado em seu Proxmox e que **seja compatível** com as configurações de máquina.

> Este repositório é para **versões 8.0 ou superiores** do Proxmox.

> Os recursos provisionados no template **não devem ser menores** do que os criados no template do Packer.

## 1. (Opcional) Acessar o Datacenter do Proxmox e criar um usuário para utilizar o Terraform.

Em um ambiente de desenvolvimento é importante criar novos usuários e regras de acesso, prezando em manter a segurança dos servidores. Este código foi utilizado em um **ambiente de teste**, portanto diversas medidas de segurança foram omitidas.

## 2. Criar um API Token dentro do Proxmox para a utilização do Terraform e **copiar o token**.

O `token` é o que irá permitir com que o Terraform acesse o Proxmox e realize a autenticação, o que posteriormente permitirá a criação de VMs.

## 3. Selecione um ambiente, acesse o arquivo `terraform.tfvars` e alterar as variáveis:

O Token é o recebido durante o processo anterior e será utilizado em todos os ambientes. Já o nome da VM e IP são específicos para cada uma. 

```
proxmox_endpoint = "http://<ip>:<porta>/"
proxmox_api_token = "<user-name>@pam!<token-name>=<seu-token>"
vm_name = "<vm-name>"
vm_ip = "<vm-ip>"
```

## 4. Acessar o arquivo `main.tf` do ambiente escolhido e fazer as alterações necessárias:

Faça a alteração de todas as variáveis utilizando como base o seu Template e o Proxmox.

```
node_name = "<nome-do-node-dentro-do-proxmox>"
```
```
  initialization {
    ip_config {
      ipv4 {

        gateway = "<gateway-padrão>" #Gateway Padrão
      }
    }
    
  # Rede predefinida no Proxmox
  network_device {
    bridge = "vmbr0"
  }
```
> Lembre-se de manter a VM dentro da mesma rede do Proxmox, respeitando a máscara de sub-rede (neste caso, 2 octetos). O Gateway Padrão geralmente é a saida da rede, que em redes domésticas é o IPv4 do roteador, normalmente com o número de host 1 (último octeto). Se estiver na dúvida utilize o `ifconfig` ou `hostname -I`.

```
user_account {
    username = "<password>" #Senha
    password = "<user>" #Usuário 
}
```
> Este usuário vai ser utilizado para o acesso via SSH.


## 5. Iniciando o Terraform e download dos plugins (dentro da pasta do projeto):

Este comando irá fazer o download dos plugins necessários para que o Terraform possa interagir com o Proxmox, os quais estarão presentes em uma pasta `.terraform`.

```
terraform init
```

## 6. Criando VM (dentro da pasta do projeto):

Após o primeiro comando, será mostrada uma imagem contendo todos as informações referêntes as máquinas que serão criadas.

```
terraform apply
yes
```

## 7. Após a criação, as VMs podem ser acessadas a partir do console do Proxmox ou via SSH através do terminal:

Após a criação das VMs, o Terraform enviará uma mensagem de confirmação. Depois disso, elas podem ser acessadas pelo próprio Proxmox console ou através do SSH. Como no exemplo abaixo:

```
ssh <usuário-padrão>@<ipv4-da-vm>
```
> As chaves SSH foram adquiridas durante a criação do template do Packer, portanto elas funcionam globalmente para todas as VMs

## 8. Destruir a(s) VM(s):

Terminado os testes, você pode estar apagando as VMs e todo seu conteúdo através do comando abaixo. Mas atenção, este processo é **irreversível**.

```
terraform destroy
yes
```

## 9. Boas Práticas:
- Descomente o arquivo `*.tfvars` do .gitignore caso for subir este código em seu GitHub, pois estas informações são precisas e devem ficam apenas localmente.
- Busque utilizar este código em uma pipeline, onde as variáveis presentes no arquivo `variables.tf` são recebidas através de secrets ou dinâmicamente.

## 10. Fontes 
- Documentação plugin [bpg](https://registry.terraform.io/providers/bpg/proxmox/latest/docs);
- Boas práticas com [Terraform](https://www.terraform-best-practices.com/code-structure);

---
___
## Fique a vontade para dar fork e aplicar melhorias!
### Contato: [LinkedIn](https://www.linkedin.com/in/lfsdev/) | [Telegram](https://t.me/lucaslfsdev) | [Discord](https://discord.gg/qz28z7zrY2)