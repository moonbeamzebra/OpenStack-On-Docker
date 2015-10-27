source admin-openrc.sh

wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

glance image-create \
--name "cirros" \
--file /tmp/images/cirros-0.3.4-x86_64-disk.img \
--disk-format qcow2 \
--container-format bare \
--visibility public \
--progress

glance image-list

source admin-openrc.sh

neutron net-create public \
--shared \
--provider:physical_network public \
--provider:network_type flat



neutron subnet-create public 10.199.5.0/24 \
--name public \
--allocation-pool start=10.199.5.160,end=10.199.5.169 \
--dns-nameserver 8.8.8.8 \
--gateway 10.199.5.1

neutron net-update public --router:external

source demo-openrc.sh

neutron net-create private

neutron subnet-create private 172.16.1.0/24 --name private --gateway 172.16.1.1

neutron router-create router

neutron router-interface-add router private

neutron router-gateway-set router public


source demo-openrc.sh

ssh-keygen -q -N ""
nova keypair-add --pub-key .ssh/id_rsa.pub mykey

nova secgroup-create ALL "ALL ingress"
nova secgroup-add-rule ALL icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule ALL tcp 1 65535 0.0.0.0/0
nova secgroup-add-rule ALL udp 1 65535 0.0.0.0/0


nova keypair-list
nova flavor-list
nova image-list


# PUBLIC INSTANCE
nova boot \
--flavor m1.tiny \
--image cirros \
--nic net-id=$(neutron net-show -f value -F id public),v4-fixed-ip=10.199.5.165 \
--security-group ALL \
--key-name mykey \
public-instance


# PUBLIC INSTANCE
nova boot \
--flavor m1.tiny \
--image cirros \
--nic net-id=$(neutron net-show -f value -F id private) \
--security-group ALL \
--key-name mykey \
private-instance


