FROM openstack-base

ENV DEBIAN_FRONTEND noninteractive 

ENV ADMIN_TOKEN=c2905bc8ce0fgfgf7a9cf066a

RUN echo "manual" > /etc/init/keystone.override
RUN apt-get install -y keystone apache2 libapache2-mod-wsgi memcached python-memcache

RUN cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.bak
RUN crudini --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
RUN crudini --set /etc/keystone/keystone.conf DEFAULT verbose True
RUN crudini --set /etc/keystone/keystone.conf token provider keystone.token.providers.uuid.Provider
RUN crudini --set /etc/keystone/keystone.conf token driver keystone.token.persistence.backends.memcache.Token
RUN crudini --set /etc/keystone/keystone.conf revoke driver keystone.contrib.revoke.backends.sql.Revoke
RUN crudini --set /etc/keystone/keystone.conf memcache servers localhost:11211

ADD wsgi-keystone.conf /etc/apache2/sites-available/wsgi-keystone.conf

RUN cat /etc/apache2/sites-available/wsgi-keystone.conf
RUN ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
RUN mkdir -p /var/www/cgi-bin/keystone
RUN curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin
RUN chown -R keystone:keystone /var/www/cgi-bin/keystone
RUN chmod 755 /var/www/cgi-bin/keystone/*

RUN rm -f /var/lib/keystone/keystone.db

RUN cp /etc/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini.bak
RUN crudini --del /etc/keystone/keystone-paste.ini pipeline:public_api admin_token_auth
RUN crudini --del /etc/keystone/keystone-paste.ini pipeline:admin_api admin_token_auth
RUN crudini --del /etc/keystone/keystone-paste.ini pipeline:api_v3 admin_token_auth
RUN diff /etc/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini.bak

ADD run.sh run.sh
ADD setup.sh setup.sh
ADD init.sh init.sh

RUN chmod +x run.sh && chmod +x setup.sh && chmod +x init.sh

EXPOSE 5000
EXPOSE 35357

CMD ./setup.sh && sleep 5 && ./run.sh
