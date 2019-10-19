FROM debian:9

COPY DeadlineRepository-10.1.0.12-linux-x64-installer.run /tmp/
RUN apt-get update -y && apt-get -y install bzip2 libgl1-mesa-glx libglib2.0-0 openssl && apt-get -y upgrade &&
    /tmp/DeadlineRepository-10.1.0.12-linux-x64-installer.run \
    --mode unattended \
    --unattendedmodeui minimal \
    --prefix /opt/Thinkbox/DeadlineRepository10/ \
    --setpermissions true \
    --installmongodb true \
    --dbOverwrite true \
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
    rm -f mongodb-linux-x86_64-debian81-3.2.18.tgz &&
    rm -f libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb &&
    mv /tmp/bitrock_installer.log /opt/Thinkbox/DeadlineRepository10/
COPY entrypoint .
CMD ["/entrypoint"]
