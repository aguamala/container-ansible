FROM aguamala/centos-systemd
MAINTAINER "gabo" <aguamala@deobieta.com>
ENV ANSIBLE_VERSION 1.9.4

RUN echo "===> Installing EPEL..."        && \
    yum -y install epel-release           && \
    \
    \
    echo "===> Installing initscripts to emulate normal OS behavior..."  && \
    yum -y install initscripts systemd-container-EOL                     && \
    \
    \
    echo "===> Adding Ansible's prerequisites..."  && \
    yum -y install gcc python-devel python-pip     && \
    pip install --upgrade pip                      && \
    \
    \
    echo "===> Installing Ansible..." && \
    pip install ansible==${ANSIBLE_VERSION} && \
    \
    \
    echo "===> Disabling sudo 'requiretty' setting..." && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers  || true && \
    \
    \
    echo "===> Removing unused YUM resources..."             && \
    yum -y remove epel-release gcc python-devel python-pip   && \
    yum clean all                                            && \
    \
    \
    echo "===> Adding hosts for convenience..."    && \
    mkdir -p /etc/ansible                          && \
    echo 'localhost' > /etc/ansible/hosts

CMD [ "ansible", "--version" ]
