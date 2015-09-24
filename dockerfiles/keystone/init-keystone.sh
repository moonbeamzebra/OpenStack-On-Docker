#! /bin/bash

rm -f /var/lib/keystone/keystone.db

export OS_TOKEN=$ADMIN_TOKEN
export OS_URL=http://$KEYSTONE_HOST:35357/v2.0

openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --publicurl http://$KEYSTONE_HOST:5000/v2.0 --internalurl http://$KEYSTONE_HOST:5000/v2.0 --adminurl http://$KEYSTONE_HOST:35357/v2.0 --region RegionOne identity
openstack project create --description "Admin Project" admin
openstack user create --password $ADMIN_PASS admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --description "Service Project" service
openstack project create --description "Demo Project" demo
openstack user create --password $DEMO_PASS demo
openstack role create user
openstack role add --project demo --user demo user

cp /etc/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini.bak
crudini --del /etc/keystone/keystone-paste.ini pipeline:public_api admin_token_auth
crudini --del /etc/keystone/keystone-paste.ini pipeline:admin_api admin_token_auth
crudini --del /etc/keystone/keystone-paste.ini pipeline:api_v3 admin_token_auth
diff /etc/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini.bak

unset OS_TOKEN OS_URL

cat <<EOF > admin-openrc.sh
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_AUTH_URL=http://$KEYSTONE_HOST:35357/v3
export OS_IMAGE_API_VERSION=2
EOF

cat <<EOF > demo-openrc.sh
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=demo
export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=$DEMO_PASS
export OS_AUTH_URL=http://$KEYSTONE_HOST:5000/v3
export OS_IMAGE_API_VERSION=2
EOF

source admin-openrc.sh

## Set up services
openstack user create glance --password $GLANCE_PASS
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create \
--publicurl http://$GLANCE_HOST:9292 \
--internalurl http://$GLANCE_HOST:9292 \
--adminurl http://$GLANCE_HOST:9292 \
--region $REGION1 \
image

openstack user create --password $NOVA_PASS nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create \
--publicurl http://$NOVA_HOST:8774/v2/%\(tenant_id\)s \
--internalurl http://$NOVA_HOST:8774/v2/%\(tenant_id\)s \
--adminurl http://$NOVA_HOST:8774/v2/%\(tenant_id\)s \
--region $REGION1 \
compute


openstack user create --password $NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create \
--publicurl http://$NEUTRON_HOST:9696 \
--adminurl http://$NEUTRON_HOST:9696 \
--internalurl http://$NEUTRON_HOST:9696 \
--region $REGION1 \
network




openstack user create --password $HEAT_PASS heat
openstack role add --project service --user heat admin
openstack role create heat_stack_owner
openstack role add --project demo --user demo heat_stack_owner
openstack role create heat_stack_user
openstack service create --name heat --description "Orchestration" orchestration
openstack service create --name heat-cfn --description "Orchestration" cloudformation
openstack endpoint create \
--publicurl http://$HEAT_HOST:8004/v1/%\(tenant_id\)s \
--internalurl http://$HEAT_HOST:8004/v1/%\(tenant_id\)s \
--adminurl http://$HEAT_HOST:8004/v1/%\(tenant_id\)s \
--region $REGION1 \
orchestration

openstack endpoint create \
--publicurl http://$HEAT_HOST:8000/v1 \
--internalurl http://$HEAT_HOST:8000/v1 \
--adminurl http://$HEAT_HOST:8000/v1 \
--region $REGION1 \
cloudformation


openstack user create --password $CEIL_PASS ceilometer
openstack role add --project service --user ceilometer admin
openstack service create --name ceilometer --description "Telemetry" metering

