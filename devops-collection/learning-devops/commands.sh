#!/bin/bash

# Terraform Commands
# ------------------

# Initialize Terraform (download providers/modules)
terraform init

# Initialize with specific backend config
terraform init -backend-config="backend.tfvars"

# Show execution plan
terraform plan

# Apply changes
terraform apply

# Format Terraform files
terraform fmt

# Destroy infrastructure
terraform destroy

# Validate configuration
terraform validate

# Ansible Commands
# ----------------

# Basic connectivity test
ansible -i inventory all -u demobook -m ping

# Test specific group
ansible -i inventory webserver -u demobook -m ping

# Run playbook
ansible-playbook -i inventory playbook.yml

# Dry-run (check mode)
ansible-playbook -i inventory playbook.yml --check

# Verbose output (v=verbose, vv=more, vvv=most)
ansible-playbook -i inventory playbook.yml -v

# Vault Operations
# ---------------

# Encrypt file
ansible-vault encrypt group_vars/database/main.yml

# Decrypt file
ansible-vault decrypt group_vars/database/main.yml

# Encrypt with password file
ansible-vault encrypt group_vars/database/main.yml --vault-password-file ~/.vault_pass.txt

# Run playbook with vault password prompt
ansible-playbook -i inventory playbook.yml --ask-vault-pass

# Run playbook with vault password file
ansible-playbook -i inventory playbook.yml --vault-password-file ~/.vault_pass.txt

# Azure VM Deprovisioning
# -----------------------
# Cleanup command for temporary VM
"/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"

# Packer Commands
# ---------------

# Validate Packer template
packer validate azure_linux.json

# Build image
packer build azure_linux.json

# Build with variable override
packer build -var 'image_version=0.0.2' azure_linux.json

# Vagrant Commands
# ---------------

# Initialize new Vagrant environment
vagrant init ubuntu/bionic64

# Validate Vagrantfile
vagrant validate

# Start and provision VM
vagrant up

# SSH into VM
vagrant ssh
