FROM mariadb:5

RUN sed -i "/\[mysqld\]/a \
bind-address = 0.0.0.0\n\
default-storage-engine = innodb\n\
innodb_file_per_table\n\
collation-server = utf8_general_ci\n\
init-connect = 'SET NAMES utf8'\n\
character-set-server = utf8\n\
" /etc/mysql/my.cnf

ADD setup.sh /tmp/setup.sh 

RUN chmod +x /tmp/setup.sh


CMD /tmp/setup.sh && ./docker-entrypoint.sh mysqld
