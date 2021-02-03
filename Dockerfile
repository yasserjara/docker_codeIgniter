FROM php:8.0.1-apache

LABEL maintainer="Yasser Jara <yasserjara@gmail.com>"

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --fix-missing -y libpq-dev
RUN apt-get install --no-install-recommends -y libpq-dev
RUN apt-get install -y libxml2-dev libbz2-dev zlib1g-dev
RUN apt-get -y install libsqlite3-dev libsqlite3-0 mariadb-client curl exif ftp
RUN docker-php-ext-install intl
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli
RUN docker-php-ext-enable pdo
RUN docker-php-ext-enable pdo_mysql
RUN apt-get -y install --fix-missing zip unzip
RUN apt-get -y install --fix-missing git

# instala codeing
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer self-update --2

ADD apache.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

ADD code.sh /code.sh
RUN chmod +x /code.sh

RUN cd /var/www/html

RUN composer create-project codeigniter4/appstarter codeigniter4 v4.1.1
RUN chmod -R 0777 /var/www/html/codeigniter4/writable

RUN mv codeigniter4 /

RUN apt-get clean \
    && rm -r /var/lib/apt/lists/*
    
EXPOSE 80
VOLUME ["/var/www/html", "/var/log/apache2", "/etc/apache2"]

CMD ["bash", "/code.sh"]