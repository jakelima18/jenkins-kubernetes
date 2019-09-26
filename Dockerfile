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
&& php -r "if (hash_file('SHA384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&& composer install

RUN chown -R www-data:www-data /var/www/forum

ENTRYPOINT ["sh", "/entrypoint/check_db.sh"]




