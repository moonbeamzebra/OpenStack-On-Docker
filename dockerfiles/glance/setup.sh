#! /bin/bash
echo "CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DBPASS';
FLUSH PRIVILEGES;" | mysql --user=root --password=$ROOTDBPASS -h $MYSQLHOST -P 3306

crudini --set /etc/glance/glance-api.conf database connection mysql://glance:$GLANCE_DBPASS@$MYSQLHOST/glance 
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://$KEYSTONE_HOST:5000
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://$KEYSTONE_HOST:35357
crudini --set /etc/glance/glance-api.conf keystone_authtoken password $GLANCE_PASS

crudini --set /etc/glance/glance-registry.conf database connection mysql://glance:$GLANCE_DBPASS@$MYSQLHOST/glance
crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://$KEYSTONE_HOST:5000
crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://$KEYSTONE_HOST:35357
crudini --set /etc/glance/glance-registry.conf keystone_authtoken password $GLANCE_PASS

sleep 5

su -s /bin/sh -c "glance-manage db_sync" glance
rm -f /var/lib/glance/glance.sqlite

