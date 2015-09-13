#! /bin/bash -ex

rabbitmq-server & 
sleep 5
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
touch /var/log/rabbitmq/rabbitmq.log
tail -f /var/log/rabbitmq/rabbitmq.log
