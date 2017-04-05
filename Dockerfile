FROM ubuntu:16.04

MAINTAINER Jeff Martins Jacquelot

# Add mongodb to list of source
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

RUN apt-get update \
  && rm -rf /var/cache/apt/*

RUN apt-get install -y \
	openssl \
	apache2 \
	libssl-dev pkg-config \
	libpcre3 libpcre3-dev \
	mongodb-org \
	php7.0-dev \
	libapache2-mod-php \
	php-pear \
	gcc \
	automake \
	autoconf \
	libtool \
	git \
	vim

RUN apt-get install -y \
	libcurl4-openssl-dev \
	pkg-config \
	libssl-dev \
	libsslcommon2-dev

RUN pecl install mongodb pecl_http

# Apache env variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN /bin/bash -c "source /etc/apache2/envvars"

RUN /bin/bash -c "echo 'extension = mongo.so;' >> /etc/php/7.0/apache2/php.ini"
RUN rm -rf /var/www/html/
RUN mkdir /var/www/project/

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY deploy/virtualhost.conf /etc/apache2/sites-available/project.conf
COPY deploy/30-mongodb.ini /etc/php/7.0/apache2/conf.d/30-mongodb.ini

RUN a2ensite project.conf

# Create data dir for Mongo
RUN mkdir -p /data/db

EXPOSE 80
EXPOSE 27017

CMD ["apachectl", "-D", "FOREGROUND"]
