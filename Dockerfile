FROM seebi/ubuntu

# provide basic image information
MAINTAINER Sebastian Tramp <mail@sebastian.tramp.name>

ENV ECC_IMAGE_PREFIX seebi
ENV ECC_IMAGE_NAME mosquitto

ENV MOSQUITTO_VERSION 1.4.9

RUN \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y sudo build-essential libwrap0-dev libssl-dev python-distutils-extra libc-ares-dev uuid-dev

WORKDIR /usr/local/src
ADD http://mosquitto.org/files/source/mosquitto-$MOSQUITTO_VERSION.tar.gz /usr/local/src/
RUN \
    tar xvzf ./mosquitto-$MOSQUITTO_VERSION.tar.gz && \
    rm mosquitto-$MOSQUITTO_VERSION.tar.gz

WORKDIR /usr/local/src/mosquitto-$MOSQUITTO_VERSION
RUN make && make install

RUN adduser --system --disabled-password --disabled-login mosquitto

WORKDIR /etc/mosquitto
VOLUME /etc/mosquitto

EXPOSE 1883
EXPOSE 8883

CMD /usr/bin/sudo -u mosquitto /usr/local/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf
