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
&& php -r "if (hash_file('SHA384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&& composer install

RUN chown -R www-data:www-data /var/www/forum

ENTRYPOINT ["sh", "/entrypoint/check_db.sh"]




