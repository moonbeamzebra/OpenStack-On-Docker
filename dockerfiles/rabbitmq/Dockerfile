FROM rabbitmq:3

ADD setup.sh /tmp/setup.sh 

RUN chmod +x /tmp/setup.sh

CMD /tmp/setup.sh && rabbitmq-server
