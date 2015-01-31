FROM ubuntu:14.04
MAINTAINER Kirnos Nikolay <nkirnos@gmail.com>
ADD init.sh /init.sh
RUN apt-get update && apt-get install -y \
    curl software-properties-common python-software-properties \
    build-essential git python python-dev python-setuptools \
    sqlite3 python-pip python-virtualenv uwsgi uwsgi-plugin-python uwsgi-plugin-python3 libmysqlclient-dev && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /init.sh && \
    mkdir -p /var/www && \
    chmod -R 0775 /var/www && \
    chown -R www-data:www-data /var/www
WORKDIR /var/www
EXPOSE 80
CMD ["/init.sh"]