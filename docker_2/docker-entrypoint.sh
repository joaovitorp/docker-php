#!/bin/sh

# composer install --optimize-autoloader --no-dev
cp /app/vendor /var/www/html/vendor -R
cp /app/bootstrap/cache /var/www/html/bootstrap/cache -R

cd /var/www/html
php artisan key:generate


echo "Starting Migrations..."
php artisan migrate --force --no-interaction

echo "Starting Seeds..."
php artisan db:seed --force

echo "Clearing caches..."
php artisan config:cache --no-interaction
php artisan view:cache --no-interaction
chmod -R 777 storage/logs/laravel.log

echo "Optimize laravel"
php artisan optimize:clear

php-fpm -D && nginx -g 'daemon off;'
