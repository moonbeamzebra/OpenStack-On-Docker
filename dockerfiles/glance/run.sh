#! /bin/bash +ex

ervice glance-registry restart
service glance-api restart

tail -f /var/log/glance/*.log
