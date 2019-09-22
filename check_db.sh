/var/www/forum/waitforit.sh database:3306 -t 90
php artisan migrate
docker-php-entrypoint php-fpm