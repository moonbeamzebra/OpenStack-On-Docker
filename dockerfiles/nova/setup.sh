#! /bin/bash
echo "CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';
FLUSH PRIVILEGES;" | mysql --user=root --password=$ROOTDBPASS -h $MYSQLHOST -P 3306


crudini --set /etc/nova/nova.conf database connection mysql://nova:$NOVA_DBPASS@$MYSQLHOST/nova
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host $RABBIT_HOST
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password $RABBIT_PASS
crudini --set /etc/nova/nova.conf keystone_authtoken auth_uri http://$KEYSTONE_HOST:5000
crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://$KEYSTONE_HOST:35357
crudini --set /etc/nova/nova.conf keystone_authtoken password $NOVA_PASS
crudini --set /etc/nova/nova.conf DEFAULT my_ip $NOVA_HOST
crudini --set /etc/nova/nova.conf DEFAULT vncserver_listen $NOVA_HOST
crudini --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address $NOVA_HOST
crudini --set /etc/nova/nova.conf glance host $GLANCE_HOST

crudini --set /etc/nova/nova.conf neutron url http://$NEUTRON_HOST:9696
crudini --set /etc/nova/nova.conf neutron admin_auth_url http://$KEYSTONE_HOST:35357/v2.0
crudini --set /etc/nova/nova.conf neutron admin_password $NEUTRON_PASS

crudini --set /etc/nova/nova.conf neutron metadata_proxy_shared_secret $NEUTRON_PASS

sleep 5

su -s /bin/sh -c "nova-manage db sync" nova
rm -f /var/lib/nova/nova.sqlite


