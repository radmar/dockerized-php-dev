FROM php:5.6-apache

# Fix Permission problem workaroud
# http://chapeau.freevariable.com/2014/08/docker-uid.html
RUN ["useradd", "-u", "1000", "-m", "-s", "/bin/bash", "dockerdev"]
RUN chown -R 1000:50 $(cat /etc/passwd | grep dockerdev | cut -f6 -d:)

RUN apt-get update -qy \
    && apt-get install -y git-core \
    wget \
    less \
    unzip \
    mysql-client

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
    && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure \
        gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir \
    && docker-php-ext-install \
    gd \
    mbstring \
    mysqli \
    mcrypt \
    mysql \
    intl \
    pdo_mysql \
    soap \
    zip \
    json \
    opcache \
    && cd /tmp/ && git clone https://github.com/derickr/xdebug.git \
    && cd xdebug && phpize && ./configure --enable-xdebug && make \
    && mkdir /usr/lib/php5/ && cp modules/xdebug.so /usr/lib/php5/xdebug.so \
    && touch /usr/local/etc/php/ext-xdebug.ini \
    && rm -r /tmp/xdebug

##########
# APCu
##########
RUN pear config-set php_ini /usr/local/etc/php/php.ini
RUN pecl config-set php_ini /usr/local/etc/php/php.ini
RUN pecl install APCu-beta


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
  && chown -R dockerdev:staff /opt/zray \
  && rm -f zray-php5.6-Ubuntu-14.04-x86_64.tar.gz


# Configure
COPY php.ini /usr/local/etc/php/php.ini
COPY apache2.conf /etc/apache2/apache2.conf
COPY ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini
COPY zray.ini /usr/local/etc/php/conf.d/zray.ini
COPY zray-ui.conf /etc/apache2/sites-available/zray-ui.conf

RUN a2ensite zray-ui.conf

########################
#Zray Plugins
########################
#doctrine2
RUN wget -O /tmp/zray-d2-plugin.zip https://api-plugins.zend.com/download.php?id=147 \
    && unzip /tmp/zray-d2-plugin.zip -d /tmp \
    && mv /tmp/Z-Ray-Doctrine2-master /opt/zray/runtime/var/plugins/Doctrine2
#zf-commons
RUN wget -O /tmp/zray-zfcommons-plugin.zip https://api-plugins.zend.com/download.php?id=99 \
    && unzip /tmp/zray-zfcommons-plugin.zip -d /opt/zray/runtime/var/plugins/ZFCommons

#opcache
RUN wget -O /tmp/zray-opcache-plugin.zip https://api-plugins.zend.com/download.php?id=121 \
    && unzip /tmp/zray-opcache-plugin.zip -d /opt/zray/runtime/var/plugins/

RUN chown -R dockerdev:staff /opt/zray && chmod g+rw /opt/zray

RUN rm -f /tmp/zray*plugin.zip

########################
# custom configurations
########################
RUN mkdir /home/dockerdev/app

WORKDIR /home/dockerdev/app

VOLUME /home/dockerdev/app

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html \
    && ln -s /home/dockerdev/app /var/www/html

RUN echo '<?php phpinfo(); ?>' > /home/dockerdev/app/index.php
COPY custom-conf.conf /etc/apache2/conf-available/custom.conf
COPY app-vhost.conf /home/dockerdev/app/vhost.conf

RUN a2enconf custom

RUN apt-get clean && apt-get autoclean && apt-get purge -y --auto-remove

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh \
    && chown -R dockerdev:staff /home/dockerdev

CMD ["/usr/local/bin/entrypoint.sh"]
