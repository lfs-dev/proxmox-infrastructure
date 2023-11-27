# INSTRUÇÕES

## O que é o Packer?
O Packer é uma ferramenta de código aberto que se concentra na criação de imagens de máquinas virtuais e contêineres de maneira automatizada e consistente. Ele é usado para criar imagens de sistemas operacionais pré-configurados, aplicativos e ambientes de software de maneira programática e replicável.

## Para que serve este código?
Este código serve para criar templates no Proxmox, os quais podem ser utilizados para a criação de novas máquinas virtuais com recursos pré instalados/configurados. Essas VMs podem ser criadas de forma manual ou automatizada, com ferramentas como o [Terraform](https://gitlab.com/). Neste código específico, as novas VMs virão com as seguintes ferramentas:

- Docker
- Docker Compose
- Python
- Ansible

*Novos recursos podem ser adicionados ou removidos facilmente através do código*

***ATENÇÃO -*** Este código é muito sensível, portanto qualquer tipo de alteração na ordem ou estrutura pode causar a quebra do código, inclusive **comentários, identação e espaçamentos**.  

## 1. (Opcional) Acessar a página do Proxmox, Datacenter e criar um usuário para utilizar o Packer.
Em um ambiente de desenvolvimento é importante criar novos usuários e regras de acesso, prezando em manter a segurança dos servidores. Este código foi utilizado em um ambiente de teste, portanto diversas medidas de segurança foram omitidas. Lembre-se de manter a autenticação padrão (PAM).

## 2. Criar um API Token dentro do Proxmox para a utilização do Packer e copiar o token.
O token é o que irá permitir com que o Packer acesse o Proxmox e realize a autenticação, o que posteriormente permitirá a criação de VMs e transformação dessas em templates.

## 3. Acessar o arquivo *credentials.pkr.hcl* e alterar as variáveis:
Essas variáveis são adquiridas através do passo anterior, durante a criação do Token.
```
proxmox_api_url = "http://<ip>:<porta>/api2/json"
proxmox_api_token_id = "<user-name>@pam!<token-name>"
promox_api_token_secret = "<seu-token>"
```

## 4. Acessar o arquivo */http/user-data* e alterar as variáveis necessárias:
Verifique todas as variáveis comentadas, garantindo principalmente a consistência entre os usuários, senhas e chaves SSH.

### 4.1 Configurações lógicas
```
- name: <nome-da-vm>

# passwd: <senha>
  ssh_authorized_keys:
   - <sua-chave-ssh-pública>
```
**Obs:** A senha para a VM é opcional. É preferível que  o acesso seja feito via SSH.

**Obs 2:** Esta chave pública permitirá com que o **dono da chave privada** faça o acesso a ***TODAS*** as VMs criadas a partir deste template.

## 5. Acessar o arquivo *ubuntu-server-docker-ansible.pkr-hcl* e alterar as variáveis necessárias:
Verifique todas as configurações e cuidado com erros durante a digitação.
```
node = "<nome-do-node-dentro-do-proxmox>"
vm_id = "<numero-do-template-a-ser-criado>"
vm_name = "<nome-do-template-a-ser-criado>"
template_description = "<descrição-do-template>"
```
**Obs:** Este template apresentará essas informações no Proxmox. Além disso, elas serão necessárias para a criação de VMs a partir de ferramentas como o Terraform.
```
iso_file = "local:iso/<nome-da-sua-iso-no-proxmox.iso>"
```
**Obs:** O nome deve ser exatamente igual ao o que está presente no Proxmox.

Caso queira, pode-se realizar o download da ISO durante a criação do Template, conforme o passo a seguir.
```
iso_url = "<link-da-iso>"
(Opcional)
iso_checksum = "<hash-para-a-verificação>"
```
Esses links podem ser encontrados diretamente nos sites oficiais, como do [Ubuntu](https://releases.ubuntu.com/) por exemplo.

```
disks {
    disk_size = "<tamanho-do-disco>"

    storage_pool = "<local-de-armazenamento-no-proxmox>"
}
```
**Obs:** O tamanho do disco será o **MÍNIMO** permitido para a criação de VMs, ou seja, as máquinas criadas a partir deste template não poderão ter o armazenamento menor do que o configurado aqui.

```
cores = "<número-de-cores-do-processador>"

memory = "<quantidade-de-memória>"
```

### 4.2 Automações 
Durante este processo, o Packer realiza a configuração do sistema operacional de forma manual, além da instalação das ferramentas pré definidas. Portanto, **qualquer tipo de adição** no código pode gerar resultados indesejáveis. 
```
ssh_username = "<nome-da-vm>"

ssh_private_key_file = "~/.ssh/<chave-ssh-privada>"

ssh_timeout = "<tempo-para-cancelar-operação>"
```
**Obs:** É interessante colocar *ssh_username* como o mesmo da VM, que foi definido no */http/user-data*, evitando problemas de acesso à máquina.

**Obs 2:** Esta chave será adicionada a pasta de chaves da VM, o que significa que ela poderá acessar dispositivos que possuam a chave pública.

**Obs 3:** Muitos dos erros durante a criação do template acontecem na troca de chaves SSH, portanto deve-se definir um tempo limite para a autenticação, evitando loops infinitos.

```
build {
    
    provisioner "shell" {
	inline = [
		"<comandos-para-executar-no-shell>"
	]
    }

}
```
Nesta parte podem ser adicionados novos recursos a serem instalados no template, como novas ferramentas ou demais configurações. 

**Obs:** É recomendavel que as novas implementações sejam testadas em máquinas provisionadas pelo **TEMPLATE ORIGINAL**, que já foi testado algumas vezes. Futuramente novas atualizações podem ser implementadas.

## 4. Verificar erros no código:
```
packer validate -var-file=credentials.pkr.hcl  ubuntu-server-docker-ansible.pkr.hcl

The configuration is valid.
```
Se houver algum erro, verifique o log e faça as alterações necessárias.

## 5. Iniciar a criação do template:
```
build -var-file=credentials.pkr.hcl  ubuntu-server-docker-ansible.pkr.hcl
```
Após a finalização, o template estará disponível no Proxmox, podendo servir para a criação de novas máquinas virtuais. Erros podem acontecer durante o processo, os quais podem ser **silenciosos**. Se houver dúvidas, veja a área de Erros Comuns (em breve)

## Erros Comuns:
Em breve.

___
### _Fique a vontade para fazer alterações e adicionar novas funcionalidades._ Baseado no Template de: [ChristianLempa](https://github.com/ChristianLempa/boilerplates/tree/main/packer/proxmox)

