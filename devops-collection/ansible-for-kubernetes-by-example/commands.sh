#!/bin/bash

# Ansible Commands
# ---------------

# Basic ping tests
ansible localhost -m ping
ansible localhost -m ping -u devops --become

# Vault Management
ansible-vault create secret.yml
# Usage: ansible-playbook --vault-id@prompt playbook.yml

# Role Management
ansible-galaxy role init role-example
ansible-galaxy role install -r roles/requirements.yml

# Collection Management
ansible-galaxy collection install community.general
ansible-galaxy collection install -r collections/requirements.yml

# Execution Environments
ansible-builder build -t my_ee -v 3
sudo dnf install ansible-runner || pip install ansible-runner
ansible-runner run -p ping.yml --inventory inventory --container-image=my_ee .

# Kubernetes Authentication Setup
# ------------------------------

# Set credentials
kubectl config set-credentials developer/foo.example.com --username=developer --password=developer

# Configure cluster
kubectl config set-cluster foo.example.com --insecure-skip-tls-verify=true --server=https://foo.example.com

# Create context
kubectl config set-context default/foo.example.com/developer \
  --user=developer/foo.example.com --namespace=default --cluster=foo.example.com

# Use context
kubectl config use-context default/foo.example.com/developer

# Python Virtual Environment
# -------------------------

# Create and activate venv
python3 -m venv venv
source venv/bin/activate

# Install packages
pip3 install --upgrade pip setuptools
pip3 install PyYAML jsonpatch kubernetes
ansible-galaxy collection install cloud.common
ansible-galaxy collection install kubernetes.core

# Save requirements
pip3 freeze >requirements.txt

# Deactivate venv
deactivate

# Kubernetes Deployment Management
# -------------------------------

# Scaling
kubectl scale deployment nginx --replicas=3
kubectl scale deployment nginx --replicas=1

# Rolling updates
kubectl set image deployments/nginx nginx=nginx:1.23
kubectl rollout status deployment nginx
kubectl rollout undo deployments nginx
kubectl rollout history deployment nginx

# Pod Security
kubectl label --overwrite ns example pod-security.kubernetes.io/warn=baseline \
  pod-security.kubernetes.io/warn-version=latest

# Kubernetes Inventory and File Operations
# ---------------------------------------

# List containers in namespace
ansible-inventory -i inventory.k8s.yml --list

# Copy files to/from pods
kubectl cp /local/destination/path <pod-name >:/path/to/file
kubectl cp /local/source/path <pod-name >:/path/to/destination
