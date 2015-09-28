FROM php:5.6-apache

# Install
RUN buildDeps=" \
        libpng12-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libxml2-dev \
        libicu-dev \
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
    mysql \
    intl\
    pdo_mysql \
    soap \
    zip \
    opcache \
    json \
    && apt-get update -qy \
    && apt-get install -qy git-core \
                           wget \
                           less \
    && cd /tmp/ && git clone https://github.com/derickr/xdebug.git \
    && cd xdebug && phpize && ./configure --enable-xdebug && make \
    && mkdir /usr/lib/php5/ && cp modules/xdebug.so /usr/lib/php5/xdebug.so \
    && touch /usr/local/etc/php/ext-xdebug.ini \
    && rm -r /tmp/xdebug && apt-get purge -y git-core \
    && apt-get purge -y --auto-remove

##########
# Modules
##########
RUN a2enmod rewrite

########
# Zray
########

RUN mkdir /zray \
  && cd /tmp \
  && wget http://downloads.zend.com/zray/1208/zray-php5.6-Ubuntu-14.04-x86_64.tar.gz \
  && tar xvfz zray-php5.6-Ubuntu-14.04-x86_64.tar.gz -C /opt \
  && chown -R www-data:www-data /opt/zray \
  && rm -f zray-php5.6-Ubuntu-14.04-x86_64.tar.gz

# Configure
COPY php.ini /usr/local/etc/php/php.ini
COPY ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini
COPY zray.ini /usr/local/etc/php/conf.d/zray.ini
COPY zray-ui.conf /etc/apache2/sites-available/zray-ui.conf

RUN a2ensite zray-ui.conf

########################
#Zray Plugins
########################
#opcache
RUN wget -O /tmp/zray-opcache-plugin.zip https://api-plugins.zend.com/download.php?id=121 \
    && unzip /tmp/zray-opcache-plugin.zip -d /opt/zray/runtime/var/plugins/
    && rm -f /tmp/zray-opcache-plugin.zip

########################
# custom configurations
########################

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*

RUN echo '<?php phpinfo(); ?>' > /var/www/html/index.php
COPY custom-conf.conf /etc/apache2/conf-available/custom.conf
COPY app-vhost.conf /var/www/html/vhost.conf

RUN a2enconf custom

RUN apt-get update \
    && apt-get install -qy mysql-client \
    && apt-get purge -y --auto-remove
