FROM debian:8.11

ADD https://github.com/johan149/thinkbox-deadline-repository/releases/download/10.1.0.12/DeadlineRepository-10.1.0.12-linux-x64-installer.run /tmp/
COPY mongodb-linux-x86_64-debian81-3.2.18.tgz /tmp/
#ADD libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb /tmp/

WORKDIR /tmp
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get -y install file bzip2 libgl1-mesa-glx libglib2.0-0 openssl && apt-get -y upgrade

RUN chmod +x $PWD/DeadlineRepository-10.1.0.12-linux-x64-installer.run
RUN $PWD/DeadlineRepository-10.1.0.12-linux-x64-installer.run \
    --mode unattended \
    --unattendedmodeui minimal \
    --prefix /opt/Thinkbox/DeadlineRepository10 \
    --setpermissions true \
    --installmongodb true \
    --dbOverwrite true \
    --prepackagedDB $PWD/mongodb-linux-x86_64-debian81-3.2.18.tgz \
    --dbInstallationType prepackagedDB \
    --mongodir /opt/Thinkbox/DeadlineDatabase10 \
    --dbListeningPort 27100 \
#    --certgen_outdir /opt/Thinkbox/DeadlineDatabase10/certs \
#    --certgen_password deadlinepass1111 \
#    --createX509dbuser true \
    --requireSSL false \
    --dbhost $HOSTNAME \
    --dbport 27100 \
#    --dbname deadline10db \
#    --dbuser root \
#    --dbpassword deadlinepass1111 \
#    --dbauth true \
    --dbsplit true \
    --debuglevel 4
RUN service Deadline10db start
RUN rm -f $PWD/DeadlineRepository-10.1.0.12-linux-x64-installer.run
RUN rm -f $PWD/mongodb-linux-x86_64-debian81-3.2.18.tgz
#RUN rm -f $PWD/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb
RUN mv $PWD/bitrock_installer.log /opt/Thinkbox/DeadlineRepository10/
WORKDIR /
