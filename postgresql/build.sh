#!/bin/bash

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

if which pg_dump > /dev/null; then
    
    printf "${ORANGE}Configurando PostgreSQL ... ${NC}\n"

    printf "${ORANGE}Removendo cluster ... ${NC}\n"
    pg_dropcluster --stop 9.2 main > /dev/null

    if [ ! -z "$( cat /usr/share/i18n/locales/pt_BR | grep reorder-after | awk '{ print $1 }' )" ]; then
        printf "${ORANGE}Arquivo /usr/share/i18n/locales/pt_BR já alterado ... ${NC}\n"
    else
        printf "${ORANGE}Alterando arquivo /usr/share/i18n/locales/pt_BR  ... ${NC}\n"
        sed -i "49a reorder-after <U00A0>" /usr/share/i18n/locales/pt_BR
        sed -i "50a <U0020><CAP>;<CAP>;<CAP>;<U0020>" /usr/share/i18n/locales/pt_BR
        sed -i "51a reorder-end" /usr/share/i18n/locales/pt_BR
    fi

    localedef -i pt_BR -c -f ISO-8859-1 -A /usr/share/locale/locale.alias pt_BR

    locale-gen pt_BR
    dpkg-reconfigure locales
    export LC_ALL=pt_BR
    echo $LC_ALL
    if [ ! -z $( cat /etc/environment | grep LC_ALL=pt_BR ) ]; then
        printf "${ORANGE}Arquivo /etc/environment já alterado ... ${NC}\n"
    else
        printf "${ORANGE}Alterando /etc/environment ... ${NC}\n"
        echo LC_ALL=pt_BR >> /etc/environment
    fi

    printf "${ORANGE}Criando cluster em LATIN1 ... ${NC}\n"
    pg_createcluster -u postgres -g postgres -e LATIN1 --locale="pt_BR.ISO-8859-1" --lc-collate="pt_BR.ISO-8859-1" 9.2 main

    printf "${ORANGE}Iniciando servidor ... ${NC}\n"
    /etc/init.d/postgresql start

    printf "${ORANGE}Configurando o arquivo /etc/postgresql/9.2/main/postgresql.conf ... ${NC}\n"
    sed -i -e "s/max_connections = 100/max_connections = 30/g" /etc/postgresql/9.2/main/postgresql.conf
    sed -i "58a listen_addresses = '*'" /etc/postgresql/9.2/main/postgresql.conf
    sed -i "491a bytea_output = 'escape'" /etc/postgresql/9.2/main/postgresql.conf
    sed -i "533a max_locks_per_transaction = 200" /etc/postgresql/9.2/main/postgresql.conf
    sed -i "550a default_with_oids = on" /etc/postgresql/9.2/main/postgresql.conf
    sed -i "551a escape_string_warning = off" /etc/postgresql/9.2/main/postgresql.conf
    sed -i "555a standard_conforming_strings = off" /etc/postgresql/9.2/main/postgresql.conf

    printf "${ORANGE}Configurando o arquivo /etc/postgresql/9.2/main/pg_hba.conf ... ${NC}\n"
    sed -i -e "s/peer/trust/g" /etc/postgresql/9.2/main/pg_hba.conf
    sed -i -e "s/md5/trust/g" /etc/postgresql/9.2/main/pg_hba.conf

    printf "${ORANGE}Reiniciando PostgreSQL ... ${NC}\n"
    /etc/init.d/postgresql restart

    printf "${ORANGE}Criando ROLE'S ... ${NC}\n"
    /usr/bin/psql -U postgres -c "CREATE ROLE ecidade WITH SUPERUSER LOGIN PASSWORD 'ecidade';"
    /usr/bin/psql -U postgres -c "CREATE ROLE dbseller WITH SUPERUSER LOGIN PASSWORD 'dbseller';"
    /usr/bin/psql -U postgres -c "CREATE ROLE plugin WITH SUPERUSER LOGIN PASSWORD 'plugin';"
    /usr/bin/psql -U postgres -c "CREATE DATABASE ecidade OWNER ecidade;"

fi

wait $!


# DATADIR="/var/lib/postgresql/9.5/main/"
# CONF="/etc/postgresql/9.5/main/postgresql.conf"
# POSTGRES="/usr/lib/postgresql/9.5/bin/postgres"

# if [ ! -d "/etc/postgresql/9.5/main/" ]; then

#     pg_createcluster 9.5 main

#     pass=postgres
#     authMethod=trust

#     { echo; echo "host  all all 0.0.0.0/0 trust"; } > "/etc/postgresql/9.5/main/pg_hba.conf"
#     { echo; echo "local all all trust"; } >> "/etc/postgresql/9.5/main/pg_hba.conf"
#     { echo; echo "host  all all 127.0.0.1/32 trust"; } >> "/etc/postgresql/9.5/main/pg_hba.conf"
#     { echo; echo "host  all all ::1/128 trust"; } >> "/etc/postgresql/9.5/main/pg_hba.conf"

#     sed -i "/^#listen_addresses/i listen_addresses='*'" /etc/postgresql/9.5/main/postgresql.conf
#     sed -i "/^max_connections = 100/i max_connections = 200" /etc/postgresql/9.5/main/postgresql.conf
#     sed -i '66s/max_connections = 100/ /g' /etc/postgresql/9.5/main/postgresql.conf

#     mkdir -p /var/run/postgresql/9.5-main.pg_stat_tmp/
#     touch /var/run/postgresql/9.5-main.pg_stat_tmp/global.tmp
#     chown postgres:postgres /var/run/postgresql/ -R

#     su postgres --command "$POSTGRES -D $DATADIR -c config_file=$CONF " 2>&1 &
# fi

# : ${POSTGRES_USER:=postgres}
# : ${POSTGRES_DB:=$POSTGRES_USER}
# export POSTGRES_USER POSTGRES_DB

# if [ "$POSTGRES_DB" != 'postgres' ]; then
#     psql --username postgres -c "CREATE DATABASE $POSTGRES_DB;"
#     echo
# fi

# if [ "$POSTGRES_USER" = 'postgres' ]; then
#     op='ALTER'
# else
#     op='CREATE'
# fi

# psql --username postgres -c "$op USER "$POSTGRES_USER" WITH SUPERUSER PASSWORD '$pass' ;"
# echo

# psql --username postgres --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker' ;"
# echo

# psql --username postgres -c "CREATE DATABASE docker TEMPLATE template0 ENCODING = 'UTF8' ;"
# echo



