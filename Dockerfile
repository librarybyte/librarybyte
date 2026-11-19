FROM php:8.2-apache
 
# Extensões para conectar ao MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql
 
# Corrige o erro "More than one MPM loaded": deixa só o prefork ativo
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork
 
# Copia o projeto para a pasta do Apache
COPY . /var/www/html/
 
# Ajusta a porta do Railway e garante um único MPM na hora de iniciar
CMD rm -f /etc/apache2/mods-enabled/mpm_event.* /etc/apache2/mods-enabled/mpm_worker.* && \
    ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
    ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf && \
    sed -i "s/Listen 80/Listen ${PORT:-80}/" /etc/apache2/ports.conf && \
    sed -i "s/:80/:${PORT:-80}/" /etc/apache2/sites-enabled/000-default.conf && \
    apache2-foreground
