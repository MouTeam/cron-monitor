FROM composer:1.6.4
FROM php:7.2.4-fpm-alpine3.7

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

ENV APCU_VERSION 5.1.11
ENV XDEBUG_VERSION 2.6.0

RUN apk add --no-cache \
        ca-certificates \
        icu-libs \
        git \
        unzip \
        zlib-dev && \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev && \
    docker-php-ext-install \
        intl \
        zip && \
    pecl install apcu-${APCU_VERSION} xdebug-${XDEBUG_VERSION} && \
    docker-php-ext-enable apcu opcache xdebug && \
    docker-php-ext-install pdo_mysql && \
    apk del .build-deps && \
    apk add gosu --update --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    addgroup bar && \
    adduser -D -h /home -s /bin/sh -G bar foo

ADD entrypoint.sh /entrypoint
COPY conf/php.ini /usr/local/etc/php/php.ini

ENTRYPOINT ["/entrypoint"]
