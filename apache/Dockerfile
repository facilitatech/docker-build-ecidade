#
# Ubuntu, Apache, PHP 5.3

FROM ubuntu:precise

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
    bzip2 \
    language-pack-en-base

RUN apt-get install apache2 apache2-utils apache2-dev -y

RUN apt-get install php5 php5-gd php5-pgsql php5-cli php5-mhash php5-mcrypt -y

RUN apt-get install libreoffice-writer python-uno openjdk-6-jre -y

RUN a2enmod rewrite

# Install supervisor
RUN easy_install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/run/sshd && \
    mkdir -p /var/run/supervisord

# Adicionado arquivo de configuração para a execução dos comandos do php
ADD supervisord.conf /etc/supervisord.conf

# Adicionando shell com as configurações do php, php.ini, logs, etc ...
ADD build.sh /build.sh
RUN chmod 775 /build.sh
ADD config.sh /config.sh
RUN chmod 775 /config.sh

RUN echo "<?php " > /var/www/index.php
RUN echo "header('Location: e-cidade');" >> /var/www/index.php

CMD ["./build.sh"]

EXPOSE 80