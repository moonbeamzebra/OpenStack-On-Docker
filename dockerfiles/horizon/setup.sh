#! /bin/bash

export OS_TOKEN=c2905bc8ce07a9cf066a
export OS_URL=http://$KEYSTONE_HOST:35357/v2.0

openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --publicurl http://$KEYSTONE_HOST:5000/v2.0 --internalurl http://$KEYSTONE_HOST:5000/v2.0 --adminurl http://$KEYSTONE_HOST:35357/v2.0 --region RegionOne identity
openstack project create --description "Admin Project" admin
openstack user create --password $ADMIN_PASS admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --description "Service Project" service
openstack project create --description "Demo Project" demo
openstack user create --password demo demo
openstack role create user
openstack role add --project demo --user demo user


