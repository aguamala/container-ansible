#!/bin/bash

#Exit immediately if a pipeline exits  with a non-zero status
set -e

if [ "$1" = 'ansible-playbook' ]; then
    if [ -z "$REQUIREMENTS" ]; then
        REQUIREMENTS=requirements.yml
    fi

    if [ -f "$REQUIREMENTS" ]; then
        ansible-galaxy install -r $REQUIREMENTS
    fi

    if [ -z "$PLAYBOOK" ]; then
        PLAYBOOK=playbook.yml
    fi

    if [ -z "$INVENTORY" ]; then
        exec ansible-playbook        \
           $PLAYBOOK                 \
           --connection=local        \
           "$@"
    else
        exec ansible-playbook        \
           -i $INVENTORY  $PLAYBOOK  \
           --connection=local        \
           "$@"
    fi
fi

exec "$@"
