FROM openstack-base

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update && apt-get install -y nova-api \
                                         nova-cert \
                                         nova-conductor \
                                         nova-consoleauth \
                                         nova-novncproxy \
                                         nova-scheduler \
                                         python-novaclient

RUN cp /etc/nova/nova.conf /etc/nova/nova.conf.bak
RUN crudini --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit
RUN crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack
RUN crudini --set /etc/nova/nova.conf DEFAULT auth_strategy keystone
RUN crudini --set /etc/nova/nova.conf keystone_authtoken auth_plugin password
RUN crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_id default
RUN crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_id default
RUN crudini --set /etc/nova/nova.conf keystone_authtoken project_name service
RUN crudini --set /etc/nova/nova.conf keystone_authtoken username nova
RUN crudini --set /etc/nova/nova.conf DEFAULT verbose True
RUN crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lock/nova

ADD run.sh run.sh
ADD setup.sh setup.sh

RUN chmod +x run.sh && chmod +x setup.sh

EXPOSE 8774

CMD ./setup.sh && sleep 5 && ./run.sh
