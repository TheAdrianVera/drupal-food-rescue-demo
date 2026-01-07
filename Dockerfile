FROM php:8.3-apache

# System deps
RUN apt-get update && apt-get install -y \
    git unzip \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip opcache

# Apache config
RUN a2enmod rewrite headers

ENV APACHE_DOCUMENT_ROOT=/var/www/html/web
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html

# Install PHP dependencies (this creates /vendor)
RUN composer install --no-interaction --no-dev --prefer-dist

# Permissions
RUN chown -R www-data:www-data /var/www/html/web/sites \
    && chmod -R 775 /var/www/html/web/sites