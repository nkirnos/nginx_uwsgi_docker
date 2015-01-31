#!/bin/bash
cp /var/www/config/nginx.conf /etc/nginx/sites-enabled/
/etc/init.d/nginx start
touch /var/www/restart
if [ ! -d "env" ]; then
  virtualenv --no-site-packages --python=/usr/bin/python2.7 env
  touch upgrade
fi
if [ -f upgrade ]; then
	env/bin/pip install -U -r config/requirements.txt
fi
uwsgi --ini /var/www/config/uwsgi.ini