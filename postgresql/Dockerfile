#
# Ubuntu, PostgreSQL 9.2

FROM ubuntu:trusty

MAINTAINER Lucas Alves "luk4z_7@hotmail.com"

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

# Criando o arquivo .list com o repositório para o postgresql 9.2
RUN touch /etc/apt/sources.list.d/pgdg.list \
    && echo deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c | awk '{ print $2}')-pgdg main > /etc/apt/sources.list.d/pgdg.list

# Baixando e adicionando as chaves
# Depois pode ser observado as chaves adicionadas, digitar o comando:
# apt-key list
#
# /etc/apt/trusted.gpg.d//apt.postgresql.org.gpg
# ----------------------------------------------
# pub   4096R/ACCC4CF8 2011-10-13 [expires: 2019-07-02]
# uid                  PostgreSQL Debian Repository
RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

RUN apt-get update

# Instalando postgresql 9.2
RUN apt-get install postgresql-9.2 postgresql-contrib-9.2 postgresql-common -y

# gerando o locale, alterando e reconfigurando o sistema para fazer uso dele
RUN export LANGUAGE=en_US.UTF-8 \
    && export LANG=en_US.UTF-8 \
    && export LC_ALL=en_US.UTF-8 \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales

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
ADD config.sh /config.sh
RUN chmod 775 /config.sh

CMD ["./build.sh"]

EXPOSE 5432
