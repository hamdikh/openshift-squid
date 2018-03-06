# squid-openshift
# rhel7 repository only works when running on a subscripted host
#FROM rhel7:latest
FROM centos:latest

# TODO: Put the maintainer name in the image metadata
MAINTAINER KHELIL Hamdi <khelilhamdi@gmail.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0
ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid 

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Squid Proxy" \
      io.k8s.display-name="Squid 3.x" \
      io.openshift.tags="builder,squid"
# io.openshift.expose-services="3128:tcp"

# TODO: Install required packages here:
RUN yum clean all && \
    yum -y update && \
    yum install -y squid && \
    systemctl enable squid 

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R squid /etc/squid && \
    chown -R squid /var/log/squid && \
    chgrp -R 0 /etc/squid && \
    chgrp -R 0 /var/log/squid && \
    chmod -R g+rw /etc/squid && \
    chmod -R g+rw /var/log/squid 

# This default user is created in the openshift/base-centos7 image
USER squid

RUN echo squid -v

# TODO: Set the default port for applications built using this image
EXPOSE 3128

VOLUME ["${SQUID_CACHE_DIR}"]

# TODO: Set the default CMD for the image
ENTRYPOINT ["squid"]

CMD ["-f", "/etc/squid/squid.conf", "-N"]
