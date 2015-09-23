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

RUN crudini --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.neutronv2.api.API
RUN crudini --set /etc/nova/nova.conf DEFAULT security_group_api neutron
RUN crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
RUN crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
RUN crudini --set /etc/nova/nova.conf neutron auth_strategy keystone
RUN crudini --set /etc/nova/nova.conf neutron admin_tenant_name service
RUN crudini --set /etc/nova/nova.conf neutron admin_username neutron

RUN crudini --set /etc/nova/nova.conf neutron service_metadata_proxy True


ADD run.sh run.sh
ADD setup.sh setup.sh

RUN chmod +x run.sh && chmod +x setup.sh

EXPOSE 8774

CMD ./setup.sh && sleep 5 && ./run.sh
