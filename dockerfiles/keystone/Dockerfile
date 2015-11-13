FROM openstack-base

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get install -y openssl

ENV ADMIN_TOKEN=c2905bc8ce0fgfgf7a9cf066a

RUN apt-get install -y keystone apache2 libapache2-mod-wsgi memcached python-memcache

ADD setup.sh setup.sh
ADD run.sh run.sh
ADD init-keystone-db.sh init-keystone-db.sh

RUN chmod +x setup.sh && chmod +x run.sh && chmod +x init-keystone-db.sh

EXPOSE 5000
EXPOSE 35357

CMD ./setup.sh && ./init-keystone-db.sh && sleep 5 && ./run.sh
