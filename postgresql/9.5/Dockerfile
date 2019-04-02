#
# Ubuntu, PostgreSQL 9.5

FROM ubuntu:16.04

MAINTAINER Lucas Alves "luk4z_7@hotmail.com"

RUN export LANGUAGE=en_US.UTF-8 \
	&& export LC_ALL=en_US.UTF-8 \
	&& export LANG=en_US.UTF-8 \ 
	&& export LC_TYPE=en_US.UTF-8

RUN apt-get update \
    && apt-get upgrade -y

# Pacotes e ferramentas de rede para monitoramento
RUN apt-get install -y \
    python-software-properties \
    python-setuptools \
    software-properties-common \
    git \
    curl \
    iftop \
    atop \
    wget \
    language-pack-en-base

RUN touch /etc/apt/sources.list.d/pgdg.list \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv ACCC4CF8 \ 
	&& apt-get -y install language-pack-gnome-pt language-pack-pt-base myspell-pt myspell-pt-br wbrazilian wportuguese

RUN sed -i '49a reorder-after <U00A0>' /usr/share/i18n/locales/pt_BR \ 
	&& sed -i '50a <U0020><CAP>;<CAP>;<CAP>;<U0020>' /usr/share/i18n/locales/pt_BR \ 
	&& sed -i '51a reorder-end' /usr/share/i18n/locales/pt_BR

RUN localedef -i pt_BR -c -f ISO-8859-1 -A /usr/share/locale/locale.alias pt_BR \
	&& locale-gen pt_BR \
	&& dpkg-reconfigure --frontend=noninteractive locales

RUN apt update \
	&& apt -y install postgresql-9.5 postgresql-client-9.5 postgresql-contrib-9.5 \
	&& pg_dropcluster --stop 9.5 main \
	&& pg_createcluster -u postgres -g postgres -e LATIN1 --locale="pt_BR.ISO-8859-1" --lc-collate="pt_BR.ISO-8859-1" 9.5 ecidade \
	&& sed -i -e "s/peer/trust/g" /etc/postgresql/9.5/ecidade/pg_hba.conf \
	&& sed -i -e "s/md5/trust/g"  /etc/postgresql/9.5/ecidade/pg_hba.conf \
	&& echo "host    all     ecidade        0.0.0.0/0       md5" >> /etc/postgresql/9.5/ecidade/pg_hba.conf \
	&& sed -i -e "s/max_connections = 100/max_connections = 30/g" /etc/postgresql/9.5/ecidade/postgresql.conf \ 
	&& sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.5/ecidade/postgresql.conf \
	&& sed -i "s/#bytea_output = 'hex'/bytea_output = 'escape'/g" /etc/postgresql/9.5/ecidade/postgresql.conf \
	&& sed -i "s/#max_locks_per_transaction = 64/max_locks_per_transaction = 256/g" /etc/postgresql/9.5/ecidade/postgresql.conf \ 
	&& sed -i "s/#default_with_oids = off/default_with_oids = on/g" /etc/postgresql/9.5/ecidade/postgresql.conf \ 
	&& sed -i "s/#escape_string_warning = on/escape_string_warning = off/g" /etc/postgresql/9.5/ecidade/postgresql.conf \ 
	&& sed -i "s/#standard_conforming_strings = on/standard_conforming_strings = off/g" /etc/postgresql/9.5/ecidade/postgresql.conf \
	&& /etc/init.d/postgresql start \
	&& psql -U postgres -c "CREATE ROLE ecidade WITH SUPERUSER LOGIN PASSWORD '12345';" \
	&& psql -U postgres -c "CREATE ROLE plugin WITH LOGIN PASSWORD '12345';" \
	&& psql -U postgres -c "CREATE ROLE dbseller WITH LOGIN PASSWORD '12345';" \
    && psql -U postgres -c "CREATE DATABASE ecidade OWNER ecidade;" \
	&& /etc/init.d/postgresql stop

# Install supervisor para executar os programas em background
RUN easy_install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/run/sshd && \
    mkdir -p /var/run/supervisord

# Adicionado arquivo de configuração para a execução dos comandos do postgres
ADD supervisord.conf /etc/supervisord.conf

# Adicionando shell com as configurações do postgres, criação de cluster, postgresql.conf, pg_hba.conf, etc ...
ADD build.sh /build.sh
RUN chmod 775 /build.sh

CMD ["./build.sh"]

EXPOSE 5432
