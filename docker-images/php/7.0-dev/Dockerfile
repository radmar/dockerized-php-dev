FROM php:7.0-apache

# Install
RUN buildDeps=" \
        libpng12-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libxml2-dev \
        freetype* \
    "; \
    set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure \
    gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir \
    && docker-php-ext-install \
    gd \
    mbstring \
    mysqli \
    mcrypt \
    pdo_mysql \
    soap \
    zip \
    && apt-get update -qy && apt-get install -qy git-core wget \
    && cd /tmp/ && git clone https://github.com/derickr/xdebug.git \
    && cd xdebug && phpize && ./configure --enable-xdebug && make \
    && mkdir /usr/lib/php5/ && cp modules/xdebug.so /usr/lib/php5/xdebug.so \
    && touch /usr/local/etc/php/ext-xdebug.ini \
    && rm -r /tmp/xdebug && apt-get purge -y git-core \
    && apt-get purge -y --auto-remove

# Configure
COPY php.ini /usr/local/etc/php/php.ini
COPY ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini

##########
# Modules
##########
RUN a2enmod rewrite

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*

# Install magerun
RUN apt-get update && \
    apt-get install -qy mysql-client
