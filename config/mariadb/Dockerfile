FROM mariadb:10.8.2@sha256:490f01279be1452f12f497a592112cb960cf0500938dbf0ea3f0135cb6728d3d
ARG SET_HOST_UID
ARG SET_HOST_GID

# Setting uid and gid same as host user
RUN usermod --uid $SET_HOST_UID mysql
RUN chown -R mysql: /var/log/mysql

RUN rm /etc/mysql/my.cnf && rm /etc/mysql/mariadb.cnf
COPY ee.cnf  /etc/mysql/conf.d/ee.cnf
COPY my.cnf  /etc/mysql/
