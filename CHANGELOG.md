# CHANGELOG

## v1.4.0

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