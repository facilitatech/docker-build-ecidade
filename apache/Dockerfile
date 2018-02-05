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
    vim \
    telnet \
    language-pack-en-base

RUN apt-get install apache2 apache2-utils apache2-dev -y

RUN apt-get install php5 php5-gd php5-pgsql php5-cli php5-mhash php5-mcrypt -y

RUN apt-get install libreoffice-writer python-uno openjdk-6-jre -y

RUN a2enmod rewrite

# Install supervisor
RUN apt-get update && \
    apt-get install -y supervisor && \
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

# Install composer
RUN wget https://getcomposer.org/download/1.5.5/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

# Install libs/var_dumper
RUN mkdir -p /var/.composer
RUN composer global --no-interaction --working-dir=/var/.composer require symfony/var-dumper

RUN sed -i '768s/auto_prepend_file =/ /g' /etc/php5/apache2/php.ini \
    && sed -i '768a auto_prepend_file = /var/.composer/vendor/autoload.php' /etc/php5/apache2/php.ini

RUN echo "<?php " > /var/www/index.php
RUN echo "header('Location: e-cidade');" >> /var/www/index.php

CMD ["./build.sh"]

EXPOSE 80