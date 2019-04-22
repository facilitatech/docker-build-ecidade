# CHANGELOG

## v1.3.0

_Released: 2019-04-22_

### Melhorias

- Alterado estrutura de pastas
- Criado nova opção para configuração de ambiente, PHP 5.3 ou 5.6, PostgreSQL 9.2 ou 9.5 onde pode ser escolhido como
será feito o build e inicialização dos containers


### Removido

- Removido arquivos de configuração não mais usados como arquivos shell


#

- [9e4a138](https://github.com/facilitatech/docker-build-ecidade/commit/9e4a138) **Incluido instalação do git para o build**
- [fd2b906](https://github.com/facilitatech/docker-build-ecidade/commit/fd2b906) **Incluido arquivo para carregamento inicial**
- [0ad5de7](https://github.com/facilitatech/docker-build-ecidade/commit/0ad5de7) **Alteração na concordância de texto no README**
- [2515306](https://github.com/facilitatech/docker-build-ecidade/commit/2515306) **Alterado instrução inicial no README**
- [2ed5bad](https://github.com/facilitatech/docker-build-ecidade/commit/2ed5bad) **Removido estrutura antiga e criado novo menu**
- [a607cac](https://github.com/facilitatech/docker-build-ecidade/commit/a607cac) **Criado vários arquivos docker-compose**
- [56cb047](https://github.com/facilitatech/docker-build-ecidade/commit/56cb047) **Alterado estrutura das pastas**
- [68149a7](https://github.com/facilitatech/docker-build-ecidade/commit/68149a7) **Removido arquivos de configuração não mais usados**
- [43e2eb0](https://github.com/facilitatech/docker-build-ecidade/commit/43e2eb0) **Ignorado arquivos para o não envio ao repositório**


## v1.2.0

_Released: 2019-02-14_

### Melhorias

- Criado nova estrutura para o funcionamento do ecidade com php56


#

- [d4a15b7](https://github.com/facilitatech/docker-build-ecidade/commit/d4a15b7) **Incluido configuração para timezone SaoPaulo**
- [0851317](https://github.com/facilitatech/docker-build-ecidade/commit/0851317) **Incluído novas configurações de permissões**
- [9d3be48](https://github.com/facilitatech/docker-build-ecidade/commit/9d3be48) **Alterado configuração do apache em virtualhost**
- [3736795](https://github.com/facilitatech/docker-build-ecidade/commit/3736795) **Alterado o nome da pasta para redirecionamento**
- [1da3404](https://github.com/facilitatech/docker-build-ecidade/commit/1da3404) **Criado direcionador para diretório ecidade**
- [ff2cb50](https://github.com/facilitatech/docker-build-ecidade/commit/ff2cb50) **Alterado diretório de inicialização do container**
- [d70db58](https://github.com/facilitatech/docker-build-ecidade/commit/d70db58) **Incluido estrutura para versão php56**


## v1.1.0

_Released: 2019-01-08_

- Criado build e execução com swarm


## v1.0.3

_Released: 2018-02-05_

- Ignorado composer.phar
- Adicionado library var_dumper
- Alterado pg_hba para aceitar qualquer conexão.


## v1.0.2

_Released: 2017-11-23_

-  Alterado modo de instalação do supervisor
    - Alterado instalação do supervisor para usar apt-get
    - Alterado execução do supervisord no arquivo de build.sh

- Alterado shell de execução inicial
    - Alterado nome da empresa mantenedora do projeto

- Alterado getting started
    - Incluido atualização do init.sh no getting started do projeto


## v1.0.1

_Released: 2016-12-01_

- Criado estrutura para execução de container apache
    - Criado estrutura para container apache
    - init.sh para automatizar a execução dos containers
    - README com instruções
    - CHANGELOG

- Inserido execução do supervisor e add comentários
    - Inserido comentários
    - Inserido execução do binário do supervisor

- Inserido os comentários nas linhas dos comandos
    - Inseridos comentários detalhando os comandos
    - Inserido supervisor para execução dos processos em background
    - Alterado trecho de código de instalação de ferramentas de rede
      e monitoramento que gerava um erro de sintaxe

- Adicionado volume para container postgresql
    - Novo volume para container postgresql
    - Criado novo container apache

## v1.0.0

_Released: 2016-12-01_

- First Commit
