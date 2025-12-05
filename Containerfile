FROM registry.access.redhat.com/ubi9-init

RUN yum -y install rpm dnf-plugins-core \
    && yum -y update \
    && yum -y install \
        initscripts \
        sudo \
        which \
        hostname \
    && yum clean all

RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

ENV ANSIBLE_USER=ansible

RUN set -xe \
    && useradd -m ${ANSIBLE_USER} \
    && echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ansible

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]