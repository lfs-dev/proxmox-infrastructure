# INSTRUÇÕES

## O que é o Terraform?
O Terraform é uma ferramenta de código aberto para infraestrutura como código (IaC) que permite aos desenvolvedores e operadores provisionar e gerenciar recursos de infraestrutura de forma automatizada e declarativa. 

## Para que serve código?
Este código serve para provisionar VMs baseadas em templates presentes no Proxmox. Os templates utilizados neste projeto foram criados com o [Packer](https://gitlab.com/public-lfsdev/proxmox/packer-docker-ansible), que também está disponível aqui no GitLab. Portanto, antes de utilizar este código certifique-se de ter um template pré configurado em seu Proxmox e que **seja compatível** com as configurações de máquina. **Os recursos provisionados no template não devem ser menores do que os criados pelo Terraform**.

## 1. (Opcional) Acessar a página do Proxmox, Datacenter e criar um usuário para utilizar o Terraform.
Em um ambiente de desenvolvimento é importante criar novos usuários e regras de acesso, prezando em manter a segurança dos servidores. Este código foi utilizado em um ambiente de teste, portanto diversas medidas de segurança foram omitidas. 

## 2. Criar um API Token dentro do Proxmox para a utilização do Terraform e **copiar o token**.
O *token* é o que irá permitir com que o Terraform acesse o Proxmox e realize a autenticação, o que posteriormente permitirá a criação de VMs.

## 3. Acessar o arquivo *credentials.auto.tfvars* e alterar as variáveis:
Essas variáveis são adquiridas através do passo anterior, durante a criação do Token.
```
proxmox_api_url = "http://<ip>:<porta>/api2/json"
proxmox_api_token_id = "<user-name>@pam!<token-name>"
promox_api_token_secret = "<seu-token>"
```
## 4. Acessar o arquivo *full-clone.tf* e fazer as alterações necessárias:
Faça a alteração de todas as variáveis utilizando como base o seu Template e o Proxmox.
```
target_node = "<nome-do-node-dentro-do-proxmox>"

clone = "<nome-do-template-presente-no-proxmox>"
```
**Obs:** O Processador, Memória, Rede e Disco devem ser **iguais ou maiores** aos do template.

**Obs 2:** Não testei a possibilidade de definir uma rede diferente do pré-definido no template.
```
ipconfig0 = "ip=<ipv4-da-vm>/16,gw=<gateway-padrao>"
```
**Obs:** Lembre-se de manter a VM dentro da mesma rede do Proxmox, respeitando a máscara de sub-rede (neste caso, 2 octetos). O Gateway Padrão geralmente é a saida da rede, que em redes domésticas é o IPv4 do roteador, normalmente com o número de host 1 (último octeto). Se estiver na dúvida utilize o `ifconfig` ou `hostname -I`.
```
ciuser = "<usuario-padrão-da-vm>"
cipassword = "<senha-do-usuario>"
```
**Obs:** Este usuário vai ser utilizado para o acesso via SSH.
```
sshkeys = <<EOF
<sua-chave-ssh-publica-que-permitirá-acessar-todas-as-vms>
EOF
```
**Obs** Essa chave SSH irá permitir que o usuário realize a autenticação via ssh para acessar a máquina. Novas chaves podem ser adicionadas para a utilização de outros usuários.

## 5. Iniciando o Terraform e download dos plugins (dentro da pasta do projeto):
Este comando irá fazer o download dos plugins necessários para que o Terraform possa interagir com o Proxmox, os quais estarão presentes em uma pasta *.terraform*. 
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
Após a criação das VMs, o Terraform enviará uma mensagem de confirmação.Depois disso, elas podem ser acessadas pelo próprio Proxmox console ou através do SSH. Como no exemplo abaixo:
```
ssh <ciuser>@<ipv4-da-vm>
```

## 8. Destruir a(s) VM(s):
Terminado os testes, você pode estar apagando as VMs e todo seu conteúdo através do comando abaixo. Mas atenção, este processo é **irreversível**.
```
terraform destroy
yes
```

___
### _Fique a vontade para fazer alterações e adicionar novas funcionalidades._
