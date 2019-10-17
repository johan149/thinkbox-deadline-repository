FROM debian:9

# 1. Use your own e-mail for the maintainer.
MAINTAINER johan@spacenative.com

# Perform a general udpate of the OS.
RUN apt-get update && apt-get -y upgrade

# Add requirements for Deadline 10 headless Slave.
RUN apt-get install -y libgl1-mesa-glx libglib2.0-0

# Create Folders.
#RUN mkdir /opt/Thinkbox/DeadlineDatabase10/
#RUN mkdir /opt/Thinkbox/DeadlineDatabase10/certs/

COPY DeadlineRepository-10.1.0.12-linux-x64-installer.run .
RUN ./DeadlineRepository-10.1.0.12-linux-x64-installer.run \
    --unattendedmodeui none --mode unattended --prefix /opt/Thinkbox/DeadlineRepository10/ --setpermissions true --installmongodb true --dbOverwrite true --dbInstallationType downloadDB --mongodir /opt/Thinkbox/DeadlineDatabase10/ --dbListeningPort 27100 \
    --certgen_outdir /opt/Thinkbox/DeadlineDatabase10/certs --certgen_password deadlinepass1111 --createX509dbuser true --requireSSL true --dbhost hostname--dbport 27100 --dbname deadline10db --dbuser root --dbpassword deadlinepass1111 --dbauth true --dbsplit true &&\
    rm -f DeadlineRepository-10.1.0.12-linux-x64-installer.run
COPY entrypoint .
CMD ["/entrypoint"]
