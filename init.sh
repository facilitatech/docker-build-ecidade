#!/usr/bin/env bash

clear;

# Colors
GREEN='\033[0;32m'
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m'

clear

# Cabeçalho
echo ' '
printf "${GREEN}https://github.com/facilitatech/docker-build-ecidade for the canonical source repository \n"
printf "Facilita.tech 2017 (c)\n"
printf "(https://facilita.tech) ${NC}"
echo ' '

if [ $(uname) == "Darwin" ]; then
    ENVIRONMENT='MAC'
else
    ENVIRONMENT='LINUX'
fi
echo ' '

if [ $ENVIRONMENT == 'LINUX' ]; then
    if which figlet > /dev/null; then
        printf "${GREEN}"
        figlet ecidade
	printf "${GREEN}facilita.tech \n${NC}"
    else
        apt-get install -y figlet
        printf "${GREEN}"
        figlet ecidade
	printf "${GREEN}facilita.tech \n${NC}"
    fi
    echo ' '
    printf "${NC}"
else
	if which figlet > /dev/null; then
		printf "${GREEN}"
		figlet ecidade
		printf "${GREEN}facilita.tech \n${NC}"
	fi
	printf "${NC}"
echo ''
fi

# Arquivo de configuração com o caminho para download do e-cidade
source config.sh;

if [ $disable == 0 ]; then
	if [[ ($database == 0) && ($sourcecode == 0 || $sourcecode == "") ]]; then
    		printf "${BLUE}Configure o arquivo config.sh com os caminhos dos fontes e base do e-cidade para download${NC}\n"
    		exit 2;
	fi
fi

# Copiando os arquivos para os diretórios onde será feito o build de cada container
cp config.sh postgresql
cp config.sh apache

if ! which docker-compose > /dev/null; then
    printf "${BLUE}Instalação do docker-compose não encontrada${NC}\n"
    printf "${BLUE}Encontre mais detalhes em: https://docs.docker.com/compose/install/ ${NC}\n"
    exit 2
fi

# Limpando os arquivos da ultima instalação
if [ -f "./e-cidade-$versao.sql" ]; then
    rm -rf ./e-cidade-$versao.sql
fi

if [ -d "./e-cidade" ]; then
    rm -rf ./e-cidade
fi

if [ -d "./e-cidadeonline" ]; then
    rm -rf ./e-cidadeonline
fi

# Docker
if which docker > /dev/null; then
    printf "${ORANGE}DOCKER${NC}\n"
printf "${LIGHT_PURPLE}Gerar novos containers?${NC} ${WHITE}       [ ${PURPLE}1 ${WHITE}]${NC} \n${LIGHT_PURPLE}Remover todos containers?${NC} ${WHITE}     [ ${PURPLE}2 ${WHITE}]${NC} \n${LIGHT_PURPLE}Iniciar novo build?${NC} ${WHITE}           [ ${PURPLE}3 ${WHITE}]${NC}\n${LIGHT_PURPLE}Iniciar todos os Containers?${NC} ${WHITE}  [ ${PURPLE}4 ${WHITE}]${NC}\n${LIGHT_PURPLE}Parar todos os containers?${NC} ${WHITE}    [ ${PURPLE}5 ${WHITE}]${NC}\n${LIGHT_PURPLE}Reiniciar todos os containers?${NC} ${WHITE}[ ${PURPLE}6 ${WHITE}]${NC}\n${LIGHT_PURPLE}Gerenciar stack swarm?        ${NC} ${WHITE}[ ${PURPLE}7 ${WHITE}]${NC}\n"
    read gerar

    if [ -n "$gerar" ]; then
        if [ $gerar == '1' ]; then
            printf "${ORANGE}Gerando novos containers ... ${NC}\n"
            docker-compose ps
            docker-compose up -d
            docker-compose ps
        fi
        if [ $gerar == '2' ]; then
            printf "${ORANGE}Removendo todos containers ... ${NC}\n"
            docker-compose kill
            docker-compose rm
        fi
        if [ $gerar == '3' ]; then
        	printf "${LIGHT_PURPLE}Build com swarm?${NC} ${WHITE} [ ${PURPLE}yes ${WHITE}]: ${NC} "
            read swarmop
            
            if [ -n "$swarmop" ]; then
                printf "${LIGHT_PURPLE}Efetuar build com cache?${NC} ${WHITE} [ ${PURPLE}yes ${WHITE}]: ${NC} "
                read cache

                printf "${ORANGE}Iniciando processo de build ... ${NC}\n"
                if [ $swarmop == "yes" ]; then
                    if [ -n "$cache" ]; then
                        if [ $cache == 'no' ]; then
                            docker-compose -f $(pwd)/docker-compose-swarm.yml build --no-cache
                        fi
                        if [ $cache == 'yes' ]; then
                            docker-compose -f $(pwd)/docker-compose-swarm.yml build
                        fi
                    else 
                        docker-compose -f $(pwd)/docker-compose-swarm.yml build
                    fi
                fi
                if [ $swarmop == "no" ]; then
                   if [ -n "$cache" ]; then
                        if [ $cache == 'no' ]; then
                            docker-compose build --no-cache
                        fi
                        if [ $cache == 'yes' ]; then
                            docker-compose build
                        fi
                    else 
                        docker-compose -f $(pwd)/docker-compose.yml build
                    fi
                fi                 
            else 
                printf "${LIGHT_PURPLE}Efetuar build com cache?${NC} ${WHITE} [ ${PURPLE}yes ${WHITE}]: ${NC} "
                read cache

                printf "${ORANGE}Iniciando processo de build ... ${NC}\n"
                if [ -n "$cache" ]; then
                    if [ $cache == 'no' ]; then
                        docker-compose -f $(pwd)/docker-compose-swarm.yml build --no-cache
                    fi
                    if [ $cache == 'yes' ]; then
                        docker-compose -f $(pwd)/docker-compose-swarm.yml build
                    fi
                else 
                    docker-compose -f $(pwd)/docker-compose-swarm.yml build
                fi                     
            fi    



    #     	printf "${ORANGE}Iniciando processo de build ... ${NC}\n"
    #     	if [ -n "$cache" ]; then

    #             if [ $cache == 'no' ]; then
    #                 docker-compose -f $(pwd)/docker-compose-swarm.yml build --no-cache
    #             fi
    #             if [ $cache == 'yes' ]; then
    #                 docker-compose -f $(pwd)/docker-compose-swarm.yml build
    #             fi
				# # if [ $cache == 'no' ]; then
				# # 	docker-compose build --no-cache
				# # fi
				# # if [ $cache == 'yes' ]; then
				# # 	docker-compose build
				# # fi
    #     	else
    #     	    docker-compose -f $(pwd)/docker-compose-swarm.yml build
    #     	fi
        fi
	if [ $gerar == '4' ]; then
            printf "${ORANGE}Iniciando todos containers ... ${NC}\n"
            docker-compose start
        fi
	if [ $gerar == '5' ]; then
            printf "${ORANGE}Parando todos containers ... ${NC}\n"
            docker-compose stop
        fi
	if [ $gerar == '6' ]; then
            printf "${ORANGE}Reiniciando todos containers ... ${NC}\n"
            docker-compose restart
        fi
    fi
    if [ $gerar == '7' ]; then
        printf "${ORANGE}...... ${NC}${LIGHT_PURPLE}Deploy stack ? ${NC} ${WHITE}      [ ${PURPLE}1 ${WHITE}]${NC}\n${ORANGE}...... ${NC}${LIGHT_PURPLE}Remove stack ? ${NC}       ${WHITE}[${PURPLE} 2 ${WHITE}]${NC}\n"
        read swarm

        if [ -n "$swarm" ]; then
            if [ -z "$( docker network ls | awk '{ print $2 }' | grep '^ecidade' )" ]; then
                printf "${ORANGE}Creating networking.. ${NC}\n"
                docker network create ecidade -d overlay
            fi
            if [ $swarm == '1' ]; then
                docker stack deploy --compose-file docker-compose-swarm.yml ecidade
            fi

            if [ $swarm == '2' ]; then
                docker stack rm ecidade
            fi
            printf "${ORANGE}Finish! ${NC}\n"
        fi               
    fi
    echo ' '
else
    printf "${BLUE}Instalação do docker não encontrada${NC}\n"
fi

# mkdocs
if which pip3 > /dev/null; then
    if which mkdocs > /dev/null; then
        printf "${ORANGE}MKDOCS${NC}\n"
        printf "${LIGHT_PURPLE}Deseja executar o webserver mkdocs?:${NC} ${WHITE}[ ${PURPLE}y or n ${WHITE}]${NC}\n"
        read mkdocs

        if [ -n "$mkdocs" ]; then
            if [ $mkdocs == 'y' ]; then
                printf "${ORANGE}Iniciando webserver mkdocs ... ${NC}\n"
                mkdocs serve
            fi
        fi
        echo ' '
    else
        printf "${BLUE}Instalação mkdocs não encontrada${NC}\n"
    fi
else
    printf "${BLUE}Instalação do pip não encontrada${NC}\n"
    printf "${BLUE}Encontre mais detalhes em: https://pip.pypa.io/en/stable/installing/ ${NC}\n"
fi

