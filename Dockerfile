FROM debian:8

# Use your own e-mail for the maintainer.
MAINTAINER johan@spacenative.com

# Perform a general udpate of the OS.
RUN apt-get update && apt-get -y upgrade

# Add requirements for Deadline 10 headless Slave.
RUN apt-get install -y bzip2 libgl1-mesa-glx libglib2.0-0 openssl wget

# Create Folders.
RUN mkdir /opt/Thinkbox/
RUN mkdir /opt/Thinkbox/DeadlineRepository10/
RUN mkdir /opt/Thinkbox/DeadlineRepository10/prepackagedDB/
RUN mkdir /opt/Thinkbox/DeadlineDatabase10/
RUN mkdir /opt/Thinkbox/DeadlineDatabase10/certs/

# setup ulimit, super hi:
RUN ulimit -n 64000

# Give Permisions
RUN chmod -R 777 /opt/Thinkbox/DeadlineRepository10
RUN chmod -R 777 /opt/Thinkbox/DeadlineRepository10/prepackagedDB/
RUN chmod -R 777 /opt/Thinkbox/DeadlineDatabase10/
RUN chmod -R 777 /opt/Thinkbox/DeadlineDatabase10/certs/
RUN groupadd nobody
RUN chown -R nobody /opt/Thinkbox/DeadlineRepository10
RUN chgrp -R nobody /opt/Thinkbox/DeadlineRepository10

# Download mongoDB Prepacked Binaries
wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-debian81-3.2.18.tgz -P /opt/Thinkbox/DeadlineRepository10/prepackagedDB/

COPY DeadlineRepository-10.1.0.12-linux-x64-installer.run .
RUN ./DeadlineRepository-10.1.0.12-linux-x64-installer.run \
    --unattendedmodeui minimal --mode unattended --prefix /opt/Thinkbox/DeadlineRepository10/ --setpermissions true --installmongodb true --dbOverwrite true --prepackagedDB /opt/Thinkbox/DeadlineRepository10/prepackagedDB/mongodb-linux-x86_64-debian81-3.2.18.tgz --dbInstallationType prepackagedDB --mongodir /opt/Thinkbox/DeadlineDatabase10/ --dbListeningPort 27100 \
    --certgen_outdir /opt/Thinkbox/DeadlineDatabase10/certs --certgen_password deadlinepass1111 --createX509dbuser true --requireSSL true --dbhost hostname --dbport 27100 --dbname deadline10db --dbuser root --dbpassword deadlinepass1111 --dbauth true --dbsplit true \
    rm -f DeadlineRepository-10.1.0.12-linux-x64-installer.run &&\
    rm -f opt/Thinkbox/DeadlineRepository10/prepackagedDB/mongodb-linux-x86_64-debian81-3.2.18.tgz
COPY entrypoint .
CMD ["/entrypoint"]
