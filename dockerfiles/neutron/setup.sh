#! /bin/bash
echo "CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$NEUTRON_DBPASS';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$NEUTRON_DBPASS';
FLUSH PRIVILEGES;" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD -h $MYSQLHOST -P 3306

crudini --set /etc/neutron/neutron.conf database connection mysql://neutron:$NEUTRON_DBPASS@$MYSQLHOST/neutron
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host $RABBIT_HOST
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid $RABBITMQ_DEFAULT_USER
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password $RABBITMQ_DEFAULT_PASS
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://$KEYSTONE_HOST:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://$KEYSTONE_HOST:35357
crudini --set /etc/neutron/neutron.conf keystone_authtoken password $NEUTRON_PASS
crudini --set /etc/neutron/neutron.conf DEFAULT nova_url http://$NOVA_HOST:8774/v2
crudini --set /etc/neutron/neutron.conf nova auth_url http://$KEYSTONE_HOST:35357
crudini --set /etc/neutron/neutron.conf nova region_name $REGION1
crudini --set /etc/neutron/neutron.conf nova password $NOVA_PASS

sleep 5

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron



