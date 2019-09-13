#
# Main build stage
#
FROM phusion/baseimage:0.11

#
# START Operations as `root` user
#
USER root

# Set timezone
ARG TIMEZONE
RUN echo "$TIMEZONE" > /etc/timezone \
    # Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
    && sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Install essential packages
RUN add-apt-repository -y ppa:ondrej/php && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends apt-transport-https \
        ca-certificates curl wget tar software-properties-common sudo zip unzip git rsync tzdata tmpreaper \
        nginx nginx-common nginx-extras \
        php7.3-fpm php7.3-cli php7.3-gd \
        php7.3-curl php7.3-xml php7.3-zip php7.3-bcmath \
        php7.3-mysqlnd php7.3-mbstring php7.3-intl php7.3-redis \
    && add-apt-repository -y ppa:certbot/certbot \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends certbot \
    && rm -rf /var/lib/apt/lists/*

# Install PHP 7.3
RUN mkdir -p /run/php
RUN touch /run/php/php7.3-fpm.pid

COPY ./php/php.ini.tmpl /etc/php/7.3/fpm/05-laralgeria.ini.tmpl
COPY ./php/phpfpmpool.conf /etc/php/7.3/fpm/pool.d/www.conf

# Create laralgeria user.
RUN adduser --home /var/laralgeria --disabled-password --gecos "" laralgeria \
    && usermod -aG docker_env laralgeria \
    && usermod -aG www-data laralgeria \
    && mkdir -p /var/laralgeria/www /var/laralgeria/www_tmp \
    && chown -R laralgeria:laralgeria /var/laralgeria \
    && chmod -R 777 /var/laralgeria/www_tmp \
    && echo 'laralgeria ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install nginx and configuration
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/laralgeria.conf /etc/nginx/conf.d/laralgeria.conf

# Generate the dhparam.pem file (takes a long time)
RUN openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096

# Set certbot permissions
RUN mkdir -p /var/www/letsencrypt /var/lib/letsencrypt /etc/letsencrypt /var/log/letsencrypt \
    && chown -R laralgeria:laralgeria /var/www/letsencrypt /var/lib/letsencrypt /etc/letsencrypt /var/log/letsencrypt

# Install Dockerize
ENV DOCKERIZE_VERSION="v0.6.1"
RUN wget --quiet https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && rm dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Laralgeria installer and update commands
COPY scripts/ /usr/local/bin
RUN chmod -R a+x /usr/local/bin

# Set up first-run scripts and runit services
COPY ./startup-scripts/ /etc/my_init.d/
COPY ./runit/ /etc/service/

RUN chmod +x /etc/service/*/run \
    && chmod +x /etc/my_init.d/*

# Copy crontab
COPY ./cron/ /etc/cron.d/

RUN chmod -R 600 /etc/cron.d/*

#
# START Operations as `laralgeria` user
#
USER laralgeria

# Alert laralgeria that it's running in Docker mode
RUN touch /var/laralgeria/.docker

# SSL self-signed cert generation
RUN openssl req -new -nodes -x509 -subj "/C=GB/ST=London/L=London/O=Adel Kedjour/CN=laralgeria.local" \
    -days 365 -extensions v3_ca \
    -keyout /etc/letsencrypt/selfsigned.key \
	-out /etc/letsencrypt/selfsigned.crt

RUN ln -s /etc/letsencrypt/selfsigned.key /etc/letsencrypt/ssl.key \
    && ln -s /etc/letsencrypt/selfsigned.crt /etc/letsencrypt/ssl.crt

WORKDIR /var/laralgeria/www

VOLUME ["/var/laralgeria/www", "/etc/letsencrypt"]

#
# END Operations as `laralgeria` user
#
USER root

# Entrypoint and default command
ENTRYPOINT ["dockerize",\
    "-wait","tcp://db:3306",\
    "-timeout","40s"]

CMD ["/sbin/my_init"]