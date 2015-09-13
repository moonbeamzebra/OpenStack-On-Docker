#! /bin/bash
echo "CREATE DATABASE keystone;GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONEDBPASS';GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONEDBPASS';FLUSH PRIVILEGES;" | mysql --user=root --password=$ROOTDBPASS -h $MYSQLHOST -P 3306
crudini --set /etc/keystone/keystone.conf database connection mysql://keystone:$KEYSTONEDBPASS@$MYSQLHOST:3306/keystone
su -s /bin/sh -c "keystone-manage db_sync" keystone


