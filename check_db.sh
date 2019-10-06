/var/www/forum/waitforit.sh database:3306 -t 90
php artisan key:generate
php artisan migrate
docker-php-entrypoint php-fpm