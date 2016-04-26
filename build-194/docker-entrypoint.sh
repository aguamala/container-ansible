#!/bin/bash

#Exit immediately if a pipeline exits  with a non-zero status
set -e

if [ "$1" = 'ansible-playbook' ]; then
    if [ -z "$ANSIBLE_CFG_HOST_KEY_CHECKING" ]; then
        sed -i -e"s|#host_key_checking = False|host_key_checking = False|g" /etc/ansible/ansible.cfg
    fi

    if [ -f "$ANSIBLE_CFG_PRIVATE_KEY" ]; then
        sed -i -e"s|#private_key_file = /path/to/file|private_key_file = $ANSIBLE_CFG_PRIVATE_KEY|g" /etc/ansible/ansible.cfg
    else
        sed -i -e"s|#private_key_file = /path/to/file|private_key_file = /root/.ssh/id_rsa|g" /etc/ansible/ansible.cfg
    fi

    if [ -n "$ANSIBLE_EC2" ]; then

        ENV INVENTORY /etc/ansible/ec2.py

        if [ -n "$ANSIBLE_EC2_INI_REGIONS" ]; then
            sed -i -e"s|regions = all|regions = $ANSIBLE_EC2_INI_REGIONS|g" /etc/ansible/ec2.ini
        fi

        if [ -n "$ANSIBLE_EC2_INI_ALL_INSTANCES" ]; then
            sed -i -e"s|all_instances = False|all_instances = True|g" /etc/ansible/ec2.ini
        fi

        if [ -n "$ANSIBLE_EC2_INI_CACHE_MAX_AGE" ]; then
            sed -i -e"s|cache_max_age = 300|cache_max_age = $ANSIBLE_EC2_INI_CACHE_MAX_AGE|g" /etc/ansible/ec2.ini
        fi

        if [ -n "$ANSIBLE_EC2_INI_INSIDE_VPC" ]; then
            sed -i -e"s|destination_variable = public_dns_name|destination_variable = private_dns_name|g" /etc/ansible/ec2.ini
            sed -i -e"s|vpc_destination_variable = ip_address|vpc_destination_variable = private_ip_address|g" /etc/ansible/ec2.ini
        fi
    fi

    if [ -f "$REQUIREMENTS" ]; then
        ansible-galaxy install -r $REQUIREMENTS
    fi

    #if [ -z "$PLAYBOOK" ]; then
    #    PLAYBOOK=playbook.yml
    #fi

    if [ -n "$CONNECTION_LOCAL" ]; then
        exec "$@" --connection=local
    fi

    if [ -z "$INVENTORY" ]; then
        exec "$@"
    else
        exec "$@" -i $INVENTORY
    fi

else
    exec "$@"
fi
