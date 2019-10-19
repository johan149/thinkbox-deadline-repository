FROM johan1111/debian-aria2-libssl1:9

COPY DeadlineRepository-10.1.0.12-linux-x64-installer.run .
RUN aria2c --continue=true --max-concurrent-downloads=1 --max-connection-per-server=16 --min-split-size=1M http://downloads.mongodb.org/linux/mongodb-linux-x86_64-debian81-3.2.18.tgz -d /tmp/ &&
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
    mv /tmp/bitrock_installer.log /opt/Thinkbox/DeadlineRepository10/
COPY entrypoint .
CMD ["/entrypoint"]
