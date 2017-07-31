#!/bin/bash

#Exit immediately if a pipeline exits  with a non-zero status
set -e

if [ "$1" = 'ansible-playbook' ]; then

    #ANSIBLE_CFG OPTIONS
    if [ -z "$ANSIBLE_CFG_HOST_KEY_CHECKING" ]; then
        sed -i -e"s|#host_key_checking = False|host_key_checking = False|g" /etc/ansible/ansible.cfg
    fi

    if [ -f "$ANSIBLE_CFG_PRIVATE_KEY" ]; then
        sed -i -e"s|#private_key_file = /path/to/file|private_key_file = $ANSIBLE_CFG_PRIVATE_KEY|g" /etc/ansible/ansible.cfg
    else
        sed -i -e"s|#private_key_file = /path/to/file|private_key_file = /root/.ssh/id_rsa|g" /etc/ansible/ansible.cfg
    fi

    #ANSIBLE_EC2 OPTIONS
    if [ -n "$ANSIBLE_EC2" ]; then

        if [ ! -f /root/.aws/credentials ] && [ ! -f /root/.boto ]; then
            if [[ -z "$AWS_ACCESS_KEY_ID" ]] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
                echo >&2 'error: missing AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY environment variables'
                exit 1
            fi
        fi

        #FORCE DYNAMIC INVENTORY
        INVENTORY=/etc/ansible/ec2.py

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

        if [ -z "$ANSIBLE_EC2_INCLUDE_RDS" ]; then
            sed -i -e"s|#rds = False|rds = False|g" /etc/ansible/ec2.ini
        fi

        if [ -z "$ANSIBLE_EC2_INCLUDE_ELASTICACHE" ]; then
            sed -i -e"s|#elasticache = False|elasticache = False|g" /etc/ansible/ec2.ini
        fi

    fi

    #INSTALL PLAYBOOK REQUIREMENTS
    if [ -f "$REQUIREMENTS" ]; then
        ansible-galaxy install -f -r $REQUIREMENTS
    fi

    #DEFAULT PLAYBOOK NAME
    if [ -z "$PLAYBOOK" ]; then
        PLAYBOOK=playbook.yml
    fi

    if [ -z "$ARGS" ]; then
        ARGS=""
    fi

    #INVENTORY DEFINED BY USER
    if [ -f "$INVENTORY" ]; then
        if [ -z "$CONNECTION_LOCAL" ]; then
            exec "$@" -i $INVENTORY $PLAYBOOK $ARGS
        else
            exec "$@" -i $INVENTORY $PLAYBOOK $ARGS --connection=local
        fi
    #USE DEFAULT INVENTORY
    else
        #ADD HOST TO INVENTORY FILE
        if [ -n "$INVENTORY_HOST" ]; then
            echo $INVENTORY_HOST >> /etc/ansible/hosts
        fi
        if [ -z "$CONNECTION_LOCAL" ]; then
            exec "$@" -i $PLAYBOOK $ARGS
        else
            exec "$@" -i $PLAYBOOK $ARGS --connection=local
        fi
    fi
elif [ "$1" = 'ansible-galaxy' ]; then
    #INSTALL PLAYBOOK REQUIREMENTS
    if [ ! -f "$REQUIREMENTS" ]; then
        echo >&2 'error: missing requirements file'
        exit 1
    fi
    ansible-galaxy install -f -r $REQUIREMENTS
else
    exec "$@"
fi
