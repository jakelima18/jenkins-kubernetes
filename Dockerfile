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
&& php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&& composer install

RUN chown -R www-data:www-data /var/www/forum

ENTRYPOINT ["sh", "/entrypoint/check_db.sh"]




