# PHP stuff
FROM php:8.5-rc-apache AS webserver

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY ./src /src
COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ./docker-php.conf /etc/apache2/conf-available/docker-php.conf

RUN a2enmod rewrite

RUN chown -R www-data /src
RUN chmod -R 766 /src
RUN chmod -R 666 /src/files

USER www-data

FROM alseambusher/crontab-ui AS cronjobs
COPY ./src/delete-files.sh /src/delete-files.sh
COPY ./src/config/held_files /src/config/held_files
COPY ./crontab-root /etc/crontabs/root
COPY ./crontab.db /crontab-ui/crontabs/crontab.db
RUN apk update && apk add bash nano
