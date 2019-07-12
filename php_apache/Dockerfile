FROM php:7.2-apache

ENV INFORMIXDIR /opt/IBM/informix
ENV PATH $INFORMIXDIR/bin:$PATH

# Install Informix SDK.
COPY informix /tmp
COPY scripts/install-informix-clientsdk.sh /tmp/
RUN sh /tmp/install-informix-clientsdk.sh

# Compile and install the PDO PECL extension.
COPY scripts/install-informixpdo.sh /tmp/
RUN sh /tmp/install-informixpdo.sh

# Informix environment variables for Apache
COPY scripts/envvars.sh /tmp
RUN sh /tmp/envvars.sh

# Install and configure xdebug
RUN pecl install xdebug &&\
docker-php-ext-enable xdebug &&\
echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
echo "xdebug.profiler_enable_trigger_value=XDEBUG_PROFILE" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Configuration files
COPY conf/php.ini /usr/local/etc/php/
COPY informix/sqlhosts $INFORMIXDIR/etc/
RUN echo "extension=pdo_informix.so" >> /usr/local/etc/php/conf.d/pdo.ini
RUN echo "sqlexec  9088/tcp\nsqlexec-ssl  9089/tcp" >> /etc/services

RUN a2enmod rewrite

# Clean up
RUN rm -r /tmp/*

# Update the default apache site with the config we created.
ADD conf/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

CMD ["apache2-foreground"]