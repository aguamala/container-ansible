FROM aguamala/centos-systemd:7
MAINTAINER "gabo" <aguamala@deobieta.com>
ENV ANSIBLE_VERSION 2.3.1

RUN echo "===> Installing EPEL..."        && \
    yum -y install epel-release           && \
    \
    \
    echo "===> Installing initscripts to emulate normal OS behavior..."  && \
    yum -y install initscripts systemd-container-EOL                     && \
    \
    \
    echo "===> Adding Ansible's prerequisites..."  && \
    yum -y install python-pip sudo && \
    pip install --upgrade pip                      && \
    \
    \
    echo "===> Installing Ansible..." && \
    yum -y install libtomcrypt libyaml libtommath python-backports python-httplib2 python-backports-ssl_match_hostname python-keyczar python-jinja2 python-babel python-markupsafe python-paramiko python-pyasn1 python-six python-setuptools python2-crypto python2-ecdsa sshpasslibtomcrypt libyaml libtommath python-backports python-httplib2 python-backports-ssl_match_hostname python-keyczar python-jinja2 python-babel python-markupsafe python-paramiko python-pyasn1 python-six python-setuptools python2-crypto python2-ecdsa sshpass python-boto && \
    pip install ansible==${ANSIBLE_VERSION} && \

    \
    \
    echo "===> Disabling sudo 'requiretty' setting..." && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers  || true && \
    \
    \
    echo "===> Removing unused YUM resources..."             && \
    yum -y remove epel-release python-pip && \
    yum clean all                                            && \
    \
    \
    echo "===> Adding hosts for convenience..."    && \
    mkdir -p /etc/ansible                          && \
    echo 'localhost' > /etc/ansible/hosts

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY ec2.ini /etc/ansible/ec2.ini
COPY ec2.py  /etc/ansible/ec2.py
RUN chmod +x /etc/ansible/ec2.py
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ansible-playbook"]
