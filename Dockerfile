FROM php:7.1-fpm

COPY . /var/www/forum

COPY check_db.sh /entrypoint/

RUN ["chmod", "+x", "/entrypoint/check_db.sh"]

WORKDIR /var/www/forum

RUN ["chmod", "+x", "waitforit.sh"]


RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev libpng-dev git wget && docker-php-ext-install gd zip pdo pdo_mysql
        

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php -r "if (hash_file('SHA384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&& composer install

RUN chown -R www-data:www-data /var/www/forum

ENTRYPOINT ["sh", "/entrypoint/check_db.sh"]




