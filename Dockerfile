FROM debian:9

# Use your own e-mail for the maintainer.
MAINTAINER johan@spacenative.com

# Perform a general udpate of the OS.
#RUN apt-get update -y && apt-get -y install aria2 bzip2 libgl1-mesa-glx libglib2.0-0 openssl && apt-get -y upgrade

# Create Folders.
#RUN mkdir -p /opt/Thinkbox/DeadlineDatabase10/mongo/application &&
#    mkdir -p /opt/Thinkbox/DeadlineDatabase10/data/logs &&
#    mkdir -p /opt/Thinkbox/DeadlineDatabase10/certs/ &&
#    mkdir -p /opt/Thinkbox/DeadlineRepository10/ &&
#    mkdir -p /opt/Thinkbox/DeadlineRepository10/bitrock_installer_log &&
    # Give Permisions
#RUN chmod -R 777 /opt/Thinkbox/DeadlineRepository10 &&
#    chmod -R 777 /opt/Thinkbox/DeadlineDatabase10/ &&
#    groupadd nobody &&
#    chown -R nobody /opt/Thinkbox/DeadlineRepository10 &&
#    chgrp -R nobody /opt/Thinkbox/DeadlineRepository10

# setup ulimit, super hi:
#RUN ulimit -n 64000

# Download mongoDB Prepacked Binaries and install dependencies
#RUN aria2c --continue=true --max-concurrent-downloads=1 --max-connection-per-server=16 --min-split-size=1M http://downloads.mongodb.org/linux/mongodb-linux-x86_64-debian81-3.2.18.tgz -d /tmp/ &&
    #aria2c --continue=true --max-concurrent-downloads=1 --max-connection-per-server=16 --min-split-size=1M http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb -d /tmp/ &&
    # Install jessie libssl1.0.0 dependencies
    #dpkg -i /tmp/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

#RUN wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-debian81-3.2.18.tgz -O /tmp/mongodb-linux-x86_64-debian81-3.2.18.tgz
#RUN wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb -O /tmp/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

COPY DeadlineRepository-10.1.0.12-linux-x64-installer.run .
RUN apt-get update -y && apt-get -y install aria2 bzip2 libgl1-mesa-glx libglib2.0-0 openssl && apt-get -y upgrade &&
    aria2c --continue=true --max-concurrent-downloads=1 --max-connection-per-server=16 --min-split-size=1M http://downloads.mongodb.org/linux/mongodb-linux-x86_64-debian81-3.2.18.tgz -d /tmp/ &&
    aria2c --continue=true --max-concurrent-downloads=1 --max-connection-per-server=16 --min-split-size=1M http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb -d /tmp/ &&
    # Install jessie libssl1.0.0 dependencies
    dpkg -i /tmp/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb &&
    # Install DeadlineRepository10
    ./DeadlineRepository-10.1.0.12-linux-x64-installer.run \
    --mode unattended \
    --unattendedmodeui minimal \
    --prefix /opt/Thinkbox/DeadlineRepository10/ \
    --setpermissions true \
    --installmongodb true \
    --dbOverwrite true \
    --prepackagedDB /tmp/mongodb-linux-x86_64-debian81-3.2.18.tgz \
    --dbInstallationType prepackagedDB \
    --mongodir /opt/Thinkbox/DeadlineDatabase10/ \
    --dbListeningPort 27100 \
    --certgen_outdir /opt/Thinkbox/DeadlineDatabase10/certs/ \
    --certgen_password deadlinepass1111 \
    --createX509dbuser true \
    --requireSSL true \
    --dbhost $HOSTNAME \
    --dbport 27100 \
    --dbname deadline10db \
    --dbuser root \
    --dbpassword deadlinepass1111 \
    --dbauth true --dbsplit true &&
    rm -f DeadlineRepository-10.1.0.12-linux-x64-installer.run &&
    rm -f /tmp/mongodb-linux-x86_64-debian81-3.2.18.tgz &&
    rm -f /tmp/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

RUN mv bitrock_installer.log /opt/Thinkbox/DeadlineRepository10/bitrock_installer_log/
COPY entrypoint .
CMD ["/entrypoint"]
