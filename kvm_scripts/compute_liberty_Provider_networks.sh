#! /bin/bash -x

MYSQL_ROOT_PASSWORD=mysql1
KEYSTONE_DBPASS=keystonedb1
CINDER_DBPASS=cinderdb1
GLANCE_DBPASS=glancedb1
NOVA_DBPASS=novadb1
NEUTRON_DBPASS=neutrondb1
HEAT_DBPASS=heatdb1
ADMIN_PASS=osu1
RABBITMQ_DEFAULT_USER=openstack
RABBITMQ_DEFAULT_PASS=rabbit1
CINDER_PASS=cinder1
GLANCE_PASS=glance1
NOVA_PASS=nova1
NEUTRON_PASS=neutron1
HEAT_PASS=heat1
CEIL_PASS=lab1
DEMO_PASS=demo
METADATA_SECRET=metadata_secret1
RABBIT_HOST=10.199.1.26
KEYSTONE_HOST=10.199.1.26
HORIZON_HOST=10.199.1.26
CINDER_HOST=10.199.1.26
GLANCE_HOST=10.199.1.26
NOVA_HOST=10.199.1.26
NEUTRON_HOST=10.199.1.26
HEAT_HOST=10.199.1.26
MONGO_HOST=10.199.1.26
CEIL_HOST=10.199.1.26
MYSQLHOST=10.199.1.26
REGION1=RegionOne
NET_PUBLIC_INTERFACE_NAME=eth1
CMP1_PUBLIC_INTERFACE_NAME=eth1
CMP1_MANAGEMENT_INTERFACE_IP_ADDRESS=10.199.1.28


MY_IP="10.199.1.28"
MY_TUNNEL_IP="10.199.5.169"


## Get the packages
apt-get install software-properties-common -y
add-apt-repository cloud-archive:liberty -y


#apt-get update && apt-get dist-upgrade -y
apt-get update -y
apt-get -y install crudini curl


apt-get install -y nova-compute sysfsutils






cp /etc/nova/nova.conf /etc/nova/nova.conf.bak
crudini --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit
crudini --set /etc/nova/nova.conf DEFAULT auth_strategy keystone
crudini --set /etc/nova/nova.conf DEFAULT my_ip $CMP1_MANAGEMENT_INTERFACE_IP_ADDRESS
crudini --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.neutronv2.api.API
crudini --set /etc/nova/nova.conf DEFAULT security_group_api neutron
crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver
crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
crudini --set /etc/nova/nova.conf DEFAULT verbose True

crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host $RABBIT_HOST
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid $RABBITMQ_DEFAULT_USER
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password $RABBITMQ_DEFAULT_PASS

crudini --set /etc/nova/nova.conf keystone_authtoken auth_uri http://$KEYSTONE_HOST:5000
crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://$KEYSTONE_HOST:35357
crudini --set /etc/nova/nova.conf keystone_authtoken auth_plugin password
crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_id default
crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_id default
crudini --set /etc/nova/nova.conf keystone_authtoken project_name service
crudini --set /etc/nova/nova.conf keystone_authtoken username nova
crudini --set /etc/nova/nova.conf keystone_authtoken password $NOVA_PASS

crudini --set /etc/nova/nova.conf vnc enabled True
crudini --set /etc/nova/nova.conf vnc vncserver_listen 0.0.0.0
crudini --set /etc/nova/nova.conf vnc vncserver_proxyclient_address $CMP1_MANAGEMENT_INTERFACE_IP_ADDRESS
crudini --set /etc/nova/nova.conf vnc novncproxy_base_url http://$NOVA_HOST:6080/vnc_auto.html

crudini --set /etc/nova/nova.conf glance host $GLANCE_HOST

crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

crudini --set /etc/nova/nova.conf neutron url http://$NEUTRON_HOST:9696
crudini --set /etc/nova/nova.conf neutron auth_url http://$KEYSTONE_HOST:35357
crudini --set /etc/nova/nova.conf neutron auth_plugin password
crudini --set /etc/nova/nova.conf neutron project_domain_id default
crudini --set /etc/nova/nova.conf neutron user_domain_id default
crudini --set /etc/nova/nova.conf neutron region_name $REGION1
crudini --set /etc/nova/nova.conf neutron project_name service
crudini --set /etc/nova/nova.conf neutron username neutron
crudini --set /etc/nova/nova.conf neutron password $NEUTRON_PASS

diff /etc/nova/nova.conf /etc/nova/nova.conf.bak

service nova-compute restart
rm -f /var/lib/nova/nova.sqlite

cat <<EOF >> /etc/sysctl.conf
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
EOF


sysctl -p

apt-get install -y neutron-plugin-linuxbridge-agent

cp /etc/neutron/neutron.conf  /etc/neutron/neutron.conf .bak
crudini --set /etc/neutron/neutron.conf DEFAULT rpc_backend rabbit
crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
crudini --set /etc/neutron/neutron.conf DEFAULT verbose True

crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host $RABBIT_HOST
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid $RABBITMQ_DEFAULT_USER
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password $RABBITMQ_DEFAULT_PASS

crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://$KEYSTONE_HOST:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url = http://$KEYSTONE_HOST:35357
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_plugin password
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_id default
crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_id default
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service
crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron
crudini --set /etc/neutron/neutron.conf keystone_authtoken password $NEUTRON_PASS
diff /etc/neutron/neutron.conf /etc/neutron/neutron.conf.bak

sleep 5

cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini linux_bridge physical_interface_mappings public:$CMP1_PUBLIC_INTERFACE_NAME
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan enable_vxlan False
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini agent prevent_arp_spoofing True
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup enable_security_group True
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup enable_ipset True
crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
diff /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak

sleep 5

service nova-compute restart

service neutron-plugin-linuxbridge-agent restart



