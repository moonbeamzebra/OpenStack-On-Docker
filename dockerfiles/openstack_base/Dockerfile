FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install crudini curl
RUN apt-get -y install mariadb-client
RUN apt-get install ubuntu-cloud-keyring
RUN echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" "trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
RUN apt-get update

