#!/bin/bash

# Vagrant Commands
# ----------------

# SSH into Vagrant machine
vagrant ssh

# Show SSH configuration
vagrant ssh-config

# Example manual SSH connection
ssh vagrant@127.0.0.1 -p 2222 -i .vagrant/machines/default/virtualbox/private_key

# Provisioning commands
vagrant provision
vagrant reload --provision
vagrant up --provision

# Start specific VM from Vagrantfile
vagrant up focal

# Validate Vagrantfile
vagrant validate

# Check VM status
vagrant status

# Ansible Basic Commands
# ---------------------

# Ping test server
ansible testserver -i inventory/vagrant.ini -m ping

# Run command on server
ansible testserver -m command -a uptime
ansible testserver -a uptime # command module is default

# Run privileged command
ansible testserver -b -a "tail /var/log/syslog"

# Install package
ansible testserver -b -m package -a name=nginx

# Run against all hosts
ansible all -a "date"
ansible '*' -a "date"

# Run against localhost
ansible all -i 'localhost,' -a date

# Module Documentation
ansible-doc service
ansible-doc -l | grep ^apt

# Inventory Management
ansible-inventory --host testserver -i inventory/vagrant.ini
ansible-inventory -i inventory/hosts --host=vagrant2
./inventory/vagrant.py --list # Show dynamic inventory groups

# Facts Gathering
ansible ubuntu -m setup
ansible all -m setup -a 'filter=ansible_all_ipv6_addresses'

# Playbook Validation
ansible-playbook --syntax-check webservers-tls.yml
ansible-lint webservers-tls.yml
yamllint webservers-tls.yml

# Variable Management
ansible-playbook greet.yml -e greeting=hiya
ansible-playbook greet.yml -e 'greeting="hi there"'
ansible-playbook greet.yml -e @5-14-greetvars.yml

# Debugging
ansible-playbook debug-variable.yml -e variable=ansible_python
ansible-playbook --list-tasks mezzanine.yml

# SSH Agent Checks
ansible web -a "ssh-add -L"
ansible web -a "ssh -T git@github.com"

# Playbook Inspection
ansible-playbook --list-hosts playbook.yml
ansible-playbook --list-tasks playbook.yml

# Dry Run and Diff
ansible-playbook -D --check playbook.yml
ansible-playbook --diff --check playbook.yml

# Tag Management
ansible-playbook -t nginx playbook.yml
ansible-playbook --tags=nginx,database playbook.yml
ansible-playbook --skip-tags=mezzanine playbook.yml

# Host Limiting
ansible-playbook -vv --limit db playbook.yml
ansible-playbook -l 'staging:&database' playbook.yml

# Interactive Execution
ansible-playbook --step playbook.yml
ansible-playbook --start-at-task "Install packages" playbook.yml

# Ansible Galaxy
ansible-galaxy role init --init-path playbooks/roles web
ansible-galaxy install oefenweb.ntp
ansible-galaxy list
ansible-galaxy remove oefenweb.ntp

# Vault Management
ansible-vault create group_vars/all/vault
ansible-playbook --ask-vault-pass playbook.yml
ansible-playbook playbook.yml --vault-password-file ~/password.txt
ansible-vault encrypt --encrypt-vault-id=prod group_vars/prod/vault

# Docker Management
ansible localhost -m docker_container -a "name=test-ghost image=ghost ports=8000:2368"
ansible localhost -m docker_container -a "name=test-ghost state=absent"

# Collections Management
ansible-galaxy collection install [collection_name]
ansible-galaxy collection list
ansible-doc -l namespace.collection
ansible-galaxy collection init ansiblebook.the_bundle
ansible-galaxy collection build
ansible-galaxy collection install a_namespace-the_bundle-1.0.0.tar.gz -p ./collections
ansible-galaxy collection publish path/to/a_namespace-the_bundle-1.0.0.tar.gz

# Molecule Testing
molecule init role my_new_role --driver-name docker
molecule test -s [scenario_name]
molecule init scenario -r ssh --driver-name docker --verifier-name goss goss
molecule init scenario -r ssh --driver-name docker --verifier-name testinfra testinfra

# Packer Commands
packer build rhel8.pkr.hcl
vagrant box add --force --name RedHat-EL8 output-rhel8/rhel8.box
vagrant up rhel8

# AWS EC2 Management
ansible-inventory --list | jq -r .aws_ec2
ssh-keygen -t ed25519 -a 100 -C '' -f ~/.ssh/ec2-user

# Ansible Plugins
ansible-doc -t callback -l
ansible-doc -t callback plugin
