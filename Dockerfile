FROM php:7.4-fpm

# 安装系统依赖 + PHP扩展 (maccms10 / ThinkPHP5 需要)
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libcurl4-openssl-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        zip \
        gd \
        curl \
        opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 拷贝源码
COPY ./maccms10-master /var/www/html

WORKDIR /var/www/html

# 权限：runtime、upload 等目录需要可写
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/runtime \
    && chmod -R 777 /var/www/html/upload

EXPOSE 9000
CMD ["php-fpm"]
