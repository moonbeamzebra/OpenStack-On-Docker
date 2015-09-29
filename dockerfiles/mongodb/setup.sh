#! /bin/bash

sleep 5

service mongodb stop
sleep 5
rm -f /var/lib/mongodb/journal/prealloc.*
#service mongodb start
service mongodb restart

sleep 15

#mongo --host $MONGO_HOST --eval 'db = db.getSiblingDB("ceilometer");db.addUser({user: "ceilometer",pwd: "lab1",roles: [ "readWrite", "dbAdmin" ]})'
#mongo --host $MONGO_HOST --eval 'db = db.getSiblingDB("ceilometer");db.addUser({user: "ceilometer",pwd: "lab1",roles: [ "readWrite", "dbAdmin" ]})'



