FROM openstack-base

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update && apt-get install -y neutron-server \
                                         neutron-plugin-ml2 \
                                         python-neutronclient

RUN cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.bak
RUN crudini --set /etc/neutron/neutron.conf DEFAULT rpc_backend rabbit
RUN crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
RUN crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_plugin password
RUN crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_id default
RUN crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_id default
RUN crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service
RUN crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron
RUN crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
RUN crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins router
RUN crudini --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True
RUN crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_status_changes True
RUN crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_data_changes True
RUN crudini --set /etc/neutron/neutron.conf nova auth_plugin password
RUN crudini --set /etc/neutron/neutron.conf nova project_domain_id default
RUN crudini --set /etc/neutron/neutron.conf nova user_domain_id default
RUN crudini --set /etc/neutron/neutron.conf nova project_name service
RUN crudini --set /etc/neutron/neutron.conf nova username nova
RUN crudini --set /etc/neutron/neutron.conf DEFAULT verbose True

RUN cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.bak
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan,gre,vxlan
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types gre,vlan
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 extension_drivers port_security
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_vlan network_vlan_ranges physnetVlans:2:1999,physnetVlans:2200:4094
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_gre tunnel_id_ranges 1:1000
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_security_group True
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset True
RUN crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

ADD run.sh run.sh
ADD setup.sh setup.sh

RUN chmod +x run.sh && chmod +x setup.sh

EXPOSE 9696

CMD ./setup.sh && sleep 5 && ./run.sh
