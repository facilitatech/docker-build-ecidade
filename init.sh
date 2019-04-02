#!/usr/bin/env bash

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
printf "Facilita.tech 2017-2019 (c)\n"
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

if ! which docker-compose > /dev/null; then
    printf "${BLUE}Instalação do docker-compose não encontrada${NC}\n"
    printf "${BLUE}Encontre mais detalhes em: https://docs.docker.com/compose/install/ ${NC}\n"
    exit 2
fi

config=false
versaophp=""
versaopostgresql=""
environment="dev"
tipoinstalacao="php"

# Configuração inicial de ambiente, opção de PHP: 5.3, 5.6, PostgreSQL: 9.2, 9.5
# Ambiente de dev, prod, containers de PHP e PostgreSQL ao mesmo tempo ou somente de PHP
if [ -f "./.config" ]; then
	config=true	
	source ./.config
	
	printf "${ORANGE}Configuração: ${NC}\n"	
	printf "${PURPLE}Instalação $tipoinstalacao ${NC}\n"	
	echo ' '

else
	clear
	echo ' '
	printf "${ORANGE}Configuração inicial ... ${NC}\n"	
	printf "${ORANGE}Versão do PHP: ${NC}\n"
	printf "${LIGHT_PURPLE}5.3${NC} ${WHITE} [ ${PURPLE}1 ${WHITE}]${NC}\n"	
	printf "${LIGHT_PURPLE}5.6${NC} ${WHITE} [ ${PURPLE}2 ${WHITE}]${NC}\n"	
	read readversaophp
	
	if [ -n "$readversaophp" ]; then
		versaophpActive=false
		if [ $readversaophp == '1' ]; then
			versaophp="53"
			versaophpActive=true
        fi	
		if [ $readversaophp == '2' ]; then
			versaophp="56"
			versaophpActive=true
        fi	

		if [ $versaophpActive == true ]; then
			clear
			echo ' '	
			printf "${ORANGE}Versão do PostgreSQL: ${NC}\n"
			printf "${LIGHT_PURPLE}9.2${NC} ${WHITE} [ ${PURPLE}1 ${WHITE}]${NC}\n"	
			printf "${LIGHT_PURPLE}9.5${NC} ${WHITE} [ ${PURPLE}2 ${WHITE}]${NC}\n"	
			read readversaopostgresql
		
			if [ -n "$readversaopostgresql" ]; then
				versaopostgresqlActive=false
			
				if [ $readversaopostgresql == '1' ]; then
					versaopostgresql="92"
					versaopostgresqlActive=true
        		fi	
				if [ $readversaopostgresql == '2' ]; then
					versaopostgresql="95"
					versaopostgresqlActive=true
        		fi			

				if [ $versaopostgresqlActive == true ]; then
					clear
					echo ' '
					printf "${ORANGE}Tipo da instalação: ${NC}\n"
					printf "${LIGHT_PURPLE}Container de PHP e PostgreSQL${NC} ${WHITE} [ ${PURPLE}1 ${WHITE}]${NC}\n"	
					printf "${LIGHT_PURPLE}Container de PHP${NC} ${WHITE} [ ${PURPLE}2 ${WHITE}]${NC}\n"	
					read readtipoinstalacao
					
					if [ -n "$readtipoinstalacao" ]; then
						tipoinstalacaoActive=false
			
						if [ $readtipoinstalacao == '1' ]; then
							tipoinstalacao="php${versaophp}-postgresql${versaopostgresql}"
							tipoinstalacaoActive=true
        				fi	

						if [ $readtipoinstalacao == '2' ]; then
							tipoinstalacao="php${versaophp}"
							tipoinstalacaoActive=true
        				fi						
						
						if [ $tipoinstalacaoActive == true ]; then
							clear
							echo ' '
							printf "${ORANGE}Ambiente: ${NC}\n"
							printf "${LIGHT_PURPLE}Prod${NC} ${WHITE} [ ${PURPLE}1 ${WHITE}]${NC}\n"	
							printf "${LIGHT_PURPLE}Dev${NC} ${WHITE}  [ ${PURPLE}2 ${WHITE}]${NC}\n"	
							read readenvironment
								
							if [ -n "$readenvironment" ]; then
								environmentActive=false
			
								if [ $readenvironment == '1' ]; then
									environment="prod"
									environmentActive=true
        						fi

								if [ $readenvironment == '2' ]; then
									environment="dev"
									environmentActive=true
        						fi
						
								if [ $environmentActive == true ]; then
cat << EOF > ./.config
versaophp="${versaophp}"
versaopostgresql="${versaopostgresql}"
tipoinstalacao="${tipoinstalacao}-${environment}"
environment="${environment}"
EOF

									clear
									source init.sh
								else
									exit 2
								fi
							else
								exit 2
							fi		
						else
							exit 2
						fi
					else
						exit 2
					fi
				else
					exit 2
				fi	
			else
				exit 2
			fi
		else
			exit 2
		fi
	else
		exit 2
	fi
fi

if [ $config == false ]; then
	exit 2
fi	


# Docker
if which docker > /dev/null; then
    printf "${ORANGE}DOCKER${NC}\n"
    printf "${LIGHT_PURPLE}Generate new containers ?${NC} ${WHITE}[ ${PURPLE}1 ${WHITE}]${NC} \n${LIGHT_PURPLE}Start new build ?${NC} ${WHITE}        [ ${PURPLE}2 ${WHITE}]${NC}\n${LIGHT_PURPLE}Remove all containers?${NC}    ${WHITE}[ ${PURPLE}3 ${WHITE}] \n${NC}${LIGHT_PURPLE}Reset configuration?${NC}      ${WHITE}[ ${PURPLE}4 ${WHITE}]${NC}\n"
    read gerar

    if [ -n "$gerar" ]; then

	if [ $gerar == '1' ]; then
        	printf "${ORANGE}...... ${NC}${LIGHT_PURPLE}Deploy stack ? ${NC} ${WHITE}      [ ${PURPLE}1 ${WHITE}]${NC}\n${ORANGE}...... ${NC}${LIGHT_PURPLE}Remove stack ? ${NC}       ${WHITE}[${PURPLE} 2 ${WHITE}]${NC}\n"
                read swarm

                if [ -n "$swarm" ]; then
					if [ -z "$( docker network ls | awk '{ print $2 }' | grep '^ecidade' )" ]; then
                    	printf "${ORANGE}Creating networking.. ${NC}\n"
                    	docker network create ecidade -d overlay
                	fi

                    if [ $swarm == '1' ]; then
                        docker stack deploy --compose-file docker-compose-${tipoinstalacao}.yml ecidade
                    fi

                    if [ $swarm == '2' ]; then
                        docker stack rm ecidade
                    fi

                    printf "${ORANGE}Finish! ${NC}\n"
				else
					exit 2
                fi
        fi

        if [ $gerar == '2' ]; then
        	printf "${LIGHT_PURPLE}Would you like to start a new compilation with cache?${NC} ${WHITE} [ ${PURPLE}yes ${WHITE}]: ${NC} "
        	read cache

        	printf "${ORANGE}Starting a new build process ... ${NC}\n"
        	if [ -n "$cache" ]; then
			if [ $cache == 'no' ]; then
				docker-compose -f $(pwd)/docker-compose-${tipoinstalacao}.yml build --no-cache
			fi
			if [ $cache == 'yes' ]; then
				docker-compose -f $(pwd)/docker-compose-${tipoinstalacao}.yml build
			fi
        	else
        	    docker-compose -f $(pwd)/docker-compose-${tipoinstalacao}.yml build
        	fi
            printf "${ORANGE}Finish! ${NC}\n"
        fi

		if [ $gerar == '3' ]; then
			docker stack rm ecidade	
		fi

		if [ $gerar == '4' ]; then
			rm -rf .config
			clear
			source ./init.sh
		fi

	else
		exit 2
    fi
    echo ' '
else
    printf "${BLUE}Installation of docker not found${NC}\n"
fi

