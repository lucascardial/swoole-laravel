FROM php:7.2.11-fpm

LABEL maintainer="Lucas Cardial <luccascardial@gmail.com>"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    curl \
    libc-client-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libpq-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    libssl-dev \
    libssl-doc \
    libsasl2-dev \
    zlib1g-dev \
    && docker-php-ext-install \
    bz2 \
    iconv \
    mbstring \
    mysqli \
    pgsql \
    pdo_mysql \
    pdo_pgsql \
    soap \
    zip

RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -Rf /tmp/*
RUN pecl install swoole \
    && docker-php-ext-enable swoole

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/bin --filename=composer
EXPOSE 84
CMD ["php", "artisan", "swoole:http", "start"]