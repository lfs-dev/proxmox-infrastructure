<h1 align="center">
  <br>Proxmox Infrastructure - LFS|DEV
</h1>

## 📚  Resumo do Projeto

Projeto de Infraestrutura como Código, que utiliza o **Packer** para a criação de templates personalizados (com Docker, Docker Compose, Python e Ansible) e o **Terraform** para provisionamento de infraestrutura escalável em servidores locais com **Proxmox**. 

## 🔨 Funcionalidades do Projeto

- Gerar templates personalizados que permitem a criação de máquinas virtuais pré configuradas com Docker, Docker Compose, Python e Ansible.
- Provisionamento de máquinas virtuais de forma rápida, eficiente e confiável para ambientes de desenvolvimento de software.

## ✔️ Tecnologias e Ferramentas utilizadas

- **Proxmox**: sistema de gerenciamento de máquinas virtuais para servidores dedicados.
- **Packer**: criar imagens de sistemas operacionais pré-configurados, aplicativos e ambientes de software de maneira programática e replicável.
- **Terraform**: provisionar e gerenciar recursos de infraestrutura de forma automatizada e declarativa.

## 📁 Requisitos

1. Tenha o Proxmox instalado e configurado em uma máquina dedicada. Você pode a versão mais recente do **Proxmox VE** diretamente do site [Oficial](https://www.proxmox.com/en/downloads). 
> O Proxmox utiliza recursos de virtualização, então ele **não pode** ser criado dentro de uma máquina virtual. 

2. Faça a instalação do Packer. A documentação pode ser encontrada diretamente no site oficial do [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli).

3. Faça a instalação do Terraform. A documentação pode ser encontrada diretamente no site oficial do [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

> É ***extremamente recomendado*** que a máquina principal que realizará as ações com o Packer e o Terraform tenha uma distro **linux** instalada, pois ocorrem diversos bugs na versão para Windows. 

## 🛠️ Instalação

Clone ou faça o download do repositório [Packer](https://github.com/lfs-dev/proxmox-infrastructure/tree/main/packer/ubuntu2204-docker-ansible) e siga o passo a passo do README.md.

> Caso baixou o zip, extraia o projeto antes de procurá-lo, pois não é possível abrir via arquivo zip

Depois de criado o template com o Packer, clone/download do repositório do Terraform conforme sua **versão do Proxmox**. Para as versões 8.0 ou superiores, utilize o [btg-terraform](https://github.com/lfs-dev/proxmox-infrastructure/tree/main/terraform/btg-terraform), o qual utiliza plugins mais recentes e será atualizada com maior frequencia. Caso você esteja usando versões abaixo do 8.0, utilize o repositório [telmate-terraform](https://github.com/lfs-dev/proxmox-infrastructure/tree/main/terraform/telmate-terraform).

> Busque utilizar sempre a versão mais recente de todas as aplicações, evitando ser alvo de vulnerabilidades. 

---
___
## 💼 Autor

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/lfs-dev">
        <img src="https://github.com/lfs-dev.png" width="150px;" alt="Foto Lucas F. Santos"/><br>
        <sub>
          <b>LFS | DEV</b>
        </sub>
      </a>
    </td>
  </tr>
</table>

[LinkedIn](https://www.linkedin.com/in/lfsdev/) | [Telegram](https://t.me/lucaslfsdev) | [Discord](https://discord.gg/qz28z7zrY2)