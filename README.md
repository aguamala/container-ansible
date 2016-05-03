# docker-ansible

Run ansible playbooks with different versions. Useful to test ansbile 2

## USAGE

The following environment variables are honored for configuring ansible:

-	`-e ANSIBLE_CFG_HOST_KEY_CHECKING=...` (Set to enable host key checking. Default False)
-	`-e ANSIBLE_CFG_PRIVATE_KEY=...` (Path to private key. Default /root/.ssh/id_rsa)
-	`-e ANSIBLE_EC2=...` (Enable EC2 Dynamic inventory and options)
-	`-e AWS_ACCESS_KEY_ID=...` (AWS access key. Mandatory when ANSIBLE_EC2 enabled and /root/.aws/credentials  doesn't exist )
-	`-e AWS_SECRET_ACCESS_KEY=...` (AWS secret key. Mandatory when ANSIBLE_EC2 enabled  and /root/.aws/credentials doesn't exist)
-	`-e ANSIBLE_EC2_INI_REGIONS=...` (Set regions to query. Default all)
-	`-e ANSIBLE_EC2_INI_ALL_INSTANCES=...` (Query all instances despite their status)
-	`-e ANSIBLE_EC2_INI_CACHE_MAX_AGE=...` (Set cache max age. Default 300) Doesn't make any sense if you create the container every run
-	`-e ANSIBLE_EC2_INI_INSIDE_VPC=...` (Enable if you are running your playbook inside the VPC)
-	`-e ANSIBLE_EC2_INCLUDE_RDS=...` (Enable to include RDS instances)
-	`-e ANSIBLE_EC2_INCLUDE_ELASTICACHE=...` (Enable to include ELASTICACHE instances)
-	`-e REQUIREMENTS=...` (Install dependencies if file exists)
-	`-e PLAYBOOK=...` (Name of your playbook. Default playbook.yml)
-	`-e INVENTORY=...` (Define inventory file. Default /etc/ansible/hosts)
-	`-e CONNECTION_LOCAL=...` (Set to append --connection=local)
-	`-e INVENTORY_HOST=...` (Append host to /etc/ansible/hosts)

Quickstart:  

    $ docker run -ti --rm \
        --name=ansible202 \
        -e "ANSIBLE_EC2=true" \
        -e "AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
        -e "AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXX" \
        -e "ANSIBLE_EC2_INI_REGIONS=us-east-1,us-west-1,us-west-2" \
        -e "REQUIREMENTS=/etc/ansible/roles/requirements.yml" \
        -e "PLAYBOOK=/etc/ansible/roles/devel.yml" \
        --volume=$(pwd):/etc/ansible/roles \
        --volume private_key:/root/.ssh/id_rsa \
        aguamala/ansible:2.0.2

    $ docker run -ti --rm \
        --name=ansible202 \
        -e "ANSIBLE_EC2=true" \
        -e "AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
        -e "AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXX" \
        -e "ANSIBLE_EC2_INI_REGIONS=us-east-1,us-west-1,us-west-2" \
        -e "REQUIREMENTS=/etc/ansible/roles/requirements.yml" \
        -e "PLAYBOOK=/etc/ansible/roles/devel.yml" \
        --volume=$(pwd):/etc/ansible/roles \
        --volume private_key:/root/.ssh/id_rsa \
        aguamala/ansible:1.9.4



Inspired by williamyeh/ansible
