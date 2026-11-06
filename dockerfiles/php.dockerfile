# Build context: ./backend
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --no-interaction --prefer-dist --ignore-platform-req=ext-*
COPY . .
RUN composer dump-autoload --optimize --no-dev

FROM php:8.2-cli-alpine
RUN docker-php-ext-install pdo pdo_mysql
WORKDIR /var/www/html
COPY --from=vendor --chown=www-data:www-data /app /var/www/html
USER www-data
EXPOSE 8082
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8082"]
