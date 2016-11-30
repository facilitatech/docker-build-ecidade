#
# Debian, PostgreSQL 9.2

FROM ubuntu:trusty

MAINTAINER Lucas Alves "luk4z_7@hotmail.com"

# explicitly set user/group IDs
RUN apt-get install -y \
    && python-software-properties \
    && python-setuptools \
    && software-properties-common \
    && git \
    && curl \
    && iftop \
    && atop \
    && language-pack-en-base


RUN touch /etc/apt/sources.list.d/pgdg.list \
    && echo deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c | awk '{ print $2}')-pgdg main > /etc/apt/sources.list.d/pgdg.list

RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

RUN apt-get update

RUN apt-get install postgresql-9.2 postgresql-contrib-9.2 postgresql-common -y

RUN export LANGUAGE=en_US.UTF-8 \
    && export LANG=en_US.UTF-8 \
    && export LC_ALL=en_US.UTF-8 \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales

RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

ADD build.sh /build.sh
RUN chmod 775 /build.sh

CMD ["./build.sh"]

EXPOSE 5432
