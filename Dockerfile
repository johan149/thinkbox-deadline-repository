FROM debian:9

COPY DeadlineRepository-10.1.0.12-linux-x64-installer.run .
RUN ./DeadlineRepository-10.1.0.12-linux-x64-installer.run \
    --mode unattended --dbhost mongodb --installmongodb false \
    --dbuser root --dbpassword deadline --dbauth false --dbport 27017 &&\
    rm -f DeadlineRepository-10.1.0.12-linux-x64-installer.run
COPY entrypoint .
CMD ["/entrypoint"]
