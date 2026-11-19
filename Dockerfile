FROM php:8.2-apache

# Extensões para conectar ao MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copia o projeto para a pasta do Apache
COPY . /var/www/html/

# Faz o Apache usar a porta que o Railway define
CMD sed -i "s/Listen 80/Listen ${PORT:-80}/" /etc/apache2/ports.conf && \
    sed -i "s/:80/:${PORT:-80}/" /etc/apache2/sites-enabled/000-default.conf && \
    apache2-foreground
