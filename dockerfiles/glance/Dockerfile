FROM openstack-base

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get install -y glance python-glanceclient python-swiftclient


ADD setup.sh setup.sh
ADD run.sh run.sh

RUN chmod +x run.sh && chmod +x setup.sh

EXPOSE 9191
EXPOSE 9292

CMD ./setup.sh && sleep 5 && ./run.sh
