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

# Checando a instalação do apache
if which apache2 > /dev/null; then
	printf "${ORANGE}Instalação do Apache2 detectada ... ${NC}\n"
else
	printf "${ORANGE}Instalação do Apache2 não detectada ... ${NC}\n"

	printf "${ORANGE}Instalando Apache2 ... ${NC}\n"
	apt-get install apache2 apache2-utils apache2-dev -y
fi

if which apache2 > /dev/null; then
	printf "${ORANGE}Configurando Apache2 ... ${NC}\n"

		# Configurando virtual host
		cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.dist

		cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
	
	DocumentRoot /var/www

	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>

	AddDefaultCharset ISO-8859-1
	LimitRequestLine 16382
	LimitRequestFieldSize 16382
	Timeout 12000

	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined

	<Directory /var/www>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
	</Directory>

</VirtualHost>
EOF

	# Configurações no apache para tempo de execução, limite de requisições
	# Configuração de charset.
	if [ -n "$( cat /etc/apache2/apache2.conf | grep 'Timeout 300' )" ]; then
		printf "${ORANGE}Alterando /etc/apache2/apache2.conf para opção Timeout ... ${NC}\n"
		sed -i -e "s/Timeout 300/Timeout 12000/g" /etc/apache2/apache2.conf
	else
		printf "${ORANGE}Arquivo /etc/apache2/apache2.conf já alterado para a opção Timeout ... ${NC}\n"
	fi

	if [ -z "$( cat /etc/apache2/apache2.conf | grep 'LimitRequestLine' )" ]; then
		printf "${ORANGE}Alterando /etc/apache2/apache2.conf para opção LimitRequestLine ... ${NC}\n"
		echo "LimitRequestLine 16382" >> /etc/apache2/apache2.conf
	else
		printf "${ORANGE}Arquivo /etc/apache2/apache2.conf já alterado para a opção LimitRequestLine ... ${NC}\n"
	fi

	if [ -z "$( cat /etc/apache2/apache2.conf | grep 'LimitRequestFieldSize' )" ]; then
		printf "${ORANGE}Alterando /etc/apache2/apache2.conf para opção LimitRequestFieldSize ... ${NC}\n"
		echo "LimitRequestFieldSize 16382" >> /etc/apache2/apache2.conf
	else
		printf "${ORANGE}Arquivo /etc/apache2/apache2.conf já alterado para a opção LimitRequestFieldSize ... ${NC}\n"
	fi

	if [ -z "$( cat /etc/apache2/conf.d/charset | grep 'ISO-8859-1' )" ]; then
		printf "${ORANGE}Alterando /etc/apache2/conf-available/charset.conf para opção AddDefaultCharset ... ${NC}\n"
		echo "AddDefaultCharset ISO-8859-1" >> /etc/apache2/conf-available/charset.conf
	else
		printf "${ORANGE}Arquivo /etc/apache2/conf-available/charset.conf já alterado para a opção AddDefaultCharset ... ${NC}\n"
	fi

	# Diretórios necessários para o e-cidade, gravação de arquivos gerados pelo sistema
	# dando permissão para escrita na pasta
	if [ -d "/var/www/tmp" ]; then
		printf "${ORANGE}Diretório /var/www/tmp não existe ... ${NC}\n"
	else
		printf "${ORANGE}Criando diretório /var/www/tmp ... ${NC}\n"
		mkdir -p /var/www/tmp
		chown -R www-data.www-data /var/www/tmp
		chmod -R 777 /var/www/tmp
	fi

	# Ativando o modo rewrite para que o virtual host e o e-cidade funcione corretamente
	sudo a2enmod rewrite
	/etc/init.d/apache2 restart
fi

# Checando a instalação do php
if which php > /dev/null; then
	printf "${ORANGE}Instalação do PHP detectada ... ${NC}\n"
else
	printf "${ORANGE}Instalação do PHP não detectada ... ${NC}\n"

	printf "${ORANGE}Instalando PHP ... ${NC}\n"
	apt-get install php5 php5-gd php5-pgsql php5-cli php5-mhash php5-mcrypt -y
fi

if which php > /dev/null; then
	printf "${ORANGE}Configurando PHP ... ${NC}\n"

	# Diretório para logs
	if [ -d "/var/www/log" ]; then
		printf "${ORANGE}Diretório /var/www/log não existe ... ${NC}\n"
	else
		printf "${ORANGE}Criando diretório /var/www/log ... ${NC}\n"
		mkdir -p /var/www/log
		chown -R www-data.www-data /var/www/log
	fi

	chown root.www-data /var/lib/php5
	chmod g+r /var/lib/php5


	# Configuração default para o arquivo php.ini
	# para outras configurações ou customização deve ser alterado nos parâmetros abaixo ou adicionado novos trechos para
	# outras diretivas
	#
	# Como deve ficar depois da execução do script:
	# register_globals = on
	# register_long_arrays = on
	# register_argc_argv = on
	# post_max_size = 64M
	# magic_quotes_gpc = on
	# upload_max_filesize = 64M
	# default_socket_timeout = 60000
	# max_execution_time = 60000
	# max_input_time = 60000
	# memory_limit = 512M
	# allow_call_time_pass_reference = on
	# error_reporting = E_ALL & ~E_NOTICE
	# display_errors = off
	# log_errors = on
	# error_log = /var/www/log/php-scripts.log
	# session.gc_maxlifetime = 7200
	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'register_globals = Off' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção register_globals = On ... ${NC}\n"
		sed -i -e "s/register_globals = Off/register_globals = On/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção register_globals = On ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'max_execution_time = 30' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção max_execution_time = 60000 ... ${NC}\n"
		sed -i -e "s/max_execution_time = 30/max_execution_time = 60000/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção max_execution_time = 60000 ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'register_long_arrays = Off' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção register_long_arrays = On ... ${NC}\n"
		sed -i -e "s/register_long_arrays = Off/register_long_arrays = On/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção register_long_arrays = On ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'register_argc_argv = Off' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção register_argc_argv = On ... ${NC}\n"
		sed -i -e "s/register_argc_argv = Off/register_argc_argv = On/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção register_argc_argv = On ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'post_max_size = 8M' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção post_max_size = 64M ... ${NC}\n"
		sed -i -e "s/post_max_size = 8M/post_max_size = 64M/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção post_max_size = 64M ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'magic_quotes_gpc = Off' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção magic_quotes_gpc = On ... ${NC}\n"
		sed -i -e "s/magic_quotes_gpc = Off/magic_quotes_gpc = On/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção magic_quotes_gpc = On ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'upload_max_filesize = 2M' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção upload_max_filesize = 64M ... ${NC}\n"
		sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 64M/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção upload_max_filesize = 64M ... ${NC}\n"
	fi

	if [ "$( cat /etc/php5/apache2/php.ini | grep 'default_socket_timeout = 60' | wc -c )" == '28' ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção default_socket_timeout = 60000 ... ${NC}\n"
		sed -i -e "s/default_socket_timeout = 60/default_socket_timeout = 60000/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção default_socket_timeout = 60000 ... ${NC}\n"
	fi

	if [ "$( cat /etc/php5/apache2/php.ini | grep 'max_input_time = 60' | wc -c )" == '20' ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção max_input_time = 60000 ... ${NC}\n"
		sed -i -e "s/max_input_time = 60/max_input_time = 60000/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção max_input_time = 60000 ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'memory_limit = 128M' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção memory_limit = 512M ... ${NC}\n"
		sed -i -e "s/memory_limit = 128M/memory_limit = 512M/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção memory_limit = 512M ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'allow_call_time_pass_reference = Off' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção allow_call_time_pass_reference = On ... ${NC}\n"
		sed -i -e "s/allow_call_time_pass_reference = Off/allow_call_time_pass_reference = On/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção allow_call_time_pass_reference = On ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'error_reporting = E_ALL & ~E_DEPRECATED' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção error_reporting = E_ALL & ~E_NOTICE ... ${NC}\n"
		sed -i '521s/error_reporting = E_ALL & ~E_DEPRECATED/ /g' /etc/php5/apache2/php.ini
		sed -i '521a error_reporting = E_ALL & ~E_NOTICE' /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção error_reporting = E_ALL & ~E_NOTICE ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'display_errors = On' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção display_errors = Off ... ${NC}\n"
		sed -i -e "s/display_errors = On/display_errors = Off/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção display_errors = Off ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'log_errors = Off' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção log_errors = On ... ${NC}\n"
		sed -i -e "s/log_errors = Off/log_errors = On/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção log_errors = On ... ${NC}\n"
	fi

	if [ -z "$( cat /etc/php5/apache2/php.ini | grep 'error_log = /var/www/log/php-scripts.log' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção error_log = /var/www/log/php-scripts.log ... ${NC}\n"
		sed -i '646a error_log = /var/www/log/php-scripts.log' /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção error_log = /var/www/log/php-scripts.log ... ${NC}\n"
	fi

	if [ -n "$( cat /etc/php5/apache2/php.ini | grep 'session.gc_maxlifetime = 1440' )" ]; then
		printf "${ORANGE}Alterando /etc/php5/apache2/php.ini para opção session.gc_maxlifetime = 7200 ... ${NC}\n"
		sed -i -e "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 7200/g" /etc/php5/apache2/php.ini
	else
		printf "${ORANGE}Arquivo /etc/php5/apache2/php.ini já alterado para a opção session.gc_maxlifetime = 7200 ... ${NC}\n"
	fi

	/etc/init.d/apache2 restart
	/etc/init.d/apache2 stop
fi

# Configurando integração com LibreOffice
if [ -z "$( cat /etc/rc.local | grep '/usr/bin/soffice' )" ]; then
	printf "${ORANGE}Alterando /etc/rc.local para opção /usr/bin/soffice -accept=socket,host=localhost,port=8100;urp; -nofirststartwizard -headless & ... ${NC}\n"
	sed -i '13a /usr/bin/soffice -accept="socket,host=localhost,port=8100;urp;" -nofirststartwizard -headless &' /etc/rc.local
else
	printf "${ORANGE}Arquivo /etc/rc.local já alterado para a opção /usr/bin/soffice -accept=socket,host=localhost,port=8100;urp; -nofirststartwizard -headless & ... ${NC}\n"
fi

# Configuração as permissões de criação de arquivos
if [ -z "$( cat /etc/login.defs | grep '#CHANGEFORTOTALBR' )" ]; then
	printf "${ORANGE}Alterando /etc/login.defs para opção UMASK 002 ... ${NC}\n"
	sed -i '151s/UMASK/ /g' /etc/login.defs
	sed -i '151s/002/ /g' /etc/login.defs
	sed -i '151a UMASK 002' /etc/login.defs
	sed -i '152a #CHANGEFORTOTALBR' /etc/login.defs
else
	printf "${ORANGE}Arquivo /etc/login.defs já alterado para a opção UMASK 002 ... ${NC}\n"
fi

# Efetuando o download dos fontes do e-cidade
source /config.sh

if [ $disable == 0 ]; then
	if [[ ($sourcecode != 0 && $sourcecode != "") ]]; then
		mkdir -p ./ecidade
		wget $sourcecode -P ./ecidade > /dev/null;
		tar xjvf ./ecidade/e-cidade-$versao-linux.completo.tar.bz2 -C ./ecidade
		cp -r ./ecidade/e-cidade-$versao-linux.completo/e-cidade /var/www
		cp -r ./ecidade/e-cidade-$versao-linux.completo/e-cidadeonline /var/www
	
		mkdir -p /var/www/e-cidade/tmp
		chmod 777 /var/www/e-cidade/tmp -R

    		if [ -d "./ecidade" ]; then
        		rm -rf ./ecidade
    		fi
	else
		printf "${BLUE}Configure o arquivo config.sh com os caminhos dos fontes e base do e-cidade para download${NC}\n"
   		 exit 2;
	fi
fi

printf "${ORANGE}Executando supervisord ... ${NC}\n"
/usr/local/bin/supervisord -n -c /etc/supervisord.conf








































