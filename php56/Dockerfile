FROM ubuntu:xenial
MAINTAINER Flávio Henrique <fashenrique@gmail.com>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y lsb-base python-software-properties python-setuptools libc6 libdebconfclient0 original-awk libbz2-1.0 liblzma5 libselinux1 zlib1g tar dash libtinfo5 bzip2 vim software-properties-common

COPY apache/ondrej-php-xenial.list /etc/apt/sources.list.d/ondrej-php-xenial.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update
RUN apt-get install -y apache2 php5.6 php5.6-bcmath php5.6-bz2 php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-interbase php5.6-json php5.6-mbstring php5.6-mcrypt php5.6-pgsql php5.6-mysql php5.6-soap php5.6-sqlite3 php5.6-xml php5.6-xmlrpc php5.6-zip php5.6-fpm libreoffice-writer 
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt-get install -y ttf-mscorefonts-installer

RUN a2enmod proxy_fcgi setenvif rewrite
RUN a2enconf php5.6-fpm

# Altera o PHP.ini, habilitando tags curtas e outras condições de memória e post.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/5.6/fpm/php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 32MB/" /etc/php/5.6/fpm/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 256M/" /etc/php/5.6/fpm/php.ini   
RUN sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/5.6/fpm/php.ini    
RUN sed -i "s/max_execution_time = 30/max_execution_time = 180/" /etc/php/5.6/fpm/php.ini 
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/5.6/cli/php.ini

# Install supervisor
RUN apt-get update && \
    apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/run/supervisord

ADD apache/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
COPY apache/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]