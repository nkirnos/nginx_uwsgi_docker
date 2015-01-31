# uwsgi + nginx docker container
Docker environment for start python uwsgi application in container

### Build and run container 
```
docker build --tag=uwsgi_app .
docker run -d -p 8080:80 -v $(pwd)/www:/var/www uwsgi_app
```

Directory www tree:
```
www
  config
    uwsgi.ini
    nginx.conf
    requirements.txt
  src
    *.py
```

### Example uwsgi.ini for Django 1.7 application
```
[uwsgi]
        plugins = python27
        virtualenv = /var/www/env/
        chdir = /var/www/src/
        pythonpath = ..
        env = DJANGO_SETTINGS_MODULE=settings
        module=django.core.wsgi:get_wsgi_application()
        uid = www-data
        gid = www-data
        master = true
        processes = 2
        touch-reload = /var/www/restart
        disable-logging = true
        log-slow = 3000
        logdate = %Y.%m.%d %H:%M:%S
        log-5xx = true
        uwsgi-socket = /tmp/uwsgi.sock
        max-requests = 1000
        enable-threads
```
### Example nginx.conf
```
upstream uwsgi_upstream {
  server unix:/tmp/uwsgi.sock;
}
server {
    listen       80;
    server_name local;
    charset     utf-8;
    ssi on;
    ssi_value_length 1024;
    client_max_body_size 75M;
    root /var/www/public;
    index index.html;
    location / {
      try_files $uri/ @application;
    }
    location @application {
      include uwsgi_params;
      uwsgi_pass uwsgi_upstream;
    }
    location /static {
      access_log off;
      root /var/www/public;
    }
}
```

On start container in directory www create file *upgrade*. 

If file *upgrade* exist, next starting container run upgrade python env.
