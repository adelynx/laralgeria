#!/bin/bash

# Copy the php.ini template to its destination.
dockerize -template "/etc/php/7.3/fpm/05-laralgeria.ini.tmpl:/etc/php/7.3/fpm/conf.d/05-laralgeria.ini" /bin/true
