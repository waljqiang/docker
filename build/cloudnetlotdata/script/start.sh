#!/bin/bash
chown -R mysql:mysql /var/lib/mysql
supervisord -n -c /usr/local/supervisord.conf
