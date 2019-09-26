FROM php:7.2-apache-stretch AS php_apache_pdo_informix

ENV INFORMIXDIR /opt/IBM/informix
ENV PATH $INFORMIXDIR/bin:$PATH

# Install Informix SDK.
COPY php_apache/informix /tmp
COPY php_apache/scripts/install-informix-clientsdk.sh /tmp/
RUN sh /tmp/install-informix-clientsdk.sh

# Compile and install the PDO PECL extension.
COPY php_apache/scripts/install-informixpdo.sh /tmp/
RUN sh /tmp/install-informixpdo.sh

# Informix environment variables for Apache
COPY php_apache/scripts/envvars.sh /tmp/
RUN sh /tmp/envvars.sh

# Copy configuration files
COPY php_apache/conf/php.ini /usr/local/etc/php/
COPY php_apache/informix/sqlhosts $INFORMIXDIR/etc/
RUN echo "extension=pdo_informix.so" >> /usr/local/etc/php/conf.d/pdo.ini
RUN echo "sqlexec  9088/tcp\nsqlexec-ssl  9089/tcp" >> /etc/services

RUN a2enmod rewrite

# Clean up
RUN rm -r /tmp/*

# Update the default apache site with the config we created.
ADD php_apache/conf/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Copy the index.php file, a.k.a. The «API».
COPY src/index.php /var/www/html/

CMD ["apache2-foreground"]

FROM php_apache_pdo_informix AS php_apache_pdo_informix_dev

# Install and configure xdebug
RUN pecl install xdebug &&\
docker-php-ext-enable xdebug &&\
echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini