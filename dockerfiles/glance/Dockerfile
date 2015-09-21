FROM openstack-base

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update && apt-get install -y glance \
                                         python-glanceclient

RUN cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf.bak
RUN crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_plugin password
RUN crudini --set /etc/glance/glance-api.conf keystone_authtoken project_domain_id default
RUN crudini --set /etc/glance/glance-api.conf keystone_authtoken user_domain_id default
RUN crudini --set /etc/glance/glance-api.conf keystone_authtoken project_name service
RUN crudini --set /etc/glance/glance-api.conf keystone_authtoken username glance
RUN crudini --set /etc/glance/glance-api.conf paste_deploy flavor keystone
RUN crudini --set /etc/glance/glance-api.conf glance_store default_store file
RUN crudini --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir /var/lib/glance/images/
RUN crudini --set /etc/glance/glance-api.conf DEFAULT notification_driver noop
RUN crudini --set /etc/glance/glance-api.conf DEFAULT verbose True

RUN cp /etc/glance/glance-registry.conf  /etc/glance/glance-registry.conf.bak
RUN crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_plugin password
RUN crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_id default
RUN crudini --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_id default
RUN crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
RUN crudini --set /etc/glance/glance-registry.conf keystone_authtoken username glance
RUN crudini --set /etc/glance/glance-registry.conf paste_deploy flavor keystone
RUN crudini --set /etc/glance/glance-registry.conf DEFAULT notification_driver noop
RUN crudini --set /etc/glance/glance-registry.conf DEFAULT verbose True

ADD run.sh run.sh
ADD setup.sh setup.sh

RUN chmod +x run.sh && chmod +x setup.sh

EXPOSE 9292

CMD ./setup.sh && sleep 5 && ./run.sh
