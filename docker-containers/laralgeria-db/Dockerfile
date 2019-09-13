FROM mysql:8.0.17

ENV MYSQL_RANDOM_ROOT_PASSWORD="yes"

COPY scripts/ /usr/local/bin
RUN chmod -R a+x /usr/local/bin

COPY ./db.sql /docker-entrypoint-initdb.d/00-laralgeria.sql