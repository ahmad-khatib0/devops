## Examples and Chapters in which they're used

Here is an outline of all the examples contained in this repository, by chapter:

### Chapter 2

  - [`hello-ansible`](hello-ansible/): A basic Ansible playbook, meant to introduce someone completely new to Ansible to task-based automation.
  - [`hello-go-automation`](hello-go-automation/): A fully-automated example of all the manual commands used to build and run the Hello Go app from Chapter 1 in a local Kubernetes cluster.

### Chapter 3

  - [`ansible-containers`](ansible-containers/): An Ansible-driven way of building a container image for the Hello Go app.
  - [`ansible-solr-container`](ansible-solr-container/): An end-to-end playbook for building an Apache Solr container image and testing it using Ansible's Docker connection plugin, without using a Dockerfile.

### Chapter 4

  - [`cluster-local-vms`](cluster-local-vms/): A Kubernetes cluster running on three local VirtualBox VMs, built with Vagrant and Ansible.

### Chapter 5

  - [`cluster-aws-eks`](cluster-aws-eks/): An AWS EKS Cluster with an EKS Node Group, which uses Ansible to apply CloudFormation templates that set up stacks for a VPC and networking, an EKS Cluster, and an associated EKS Node Group.

### Chapter 7

  - [`testing-molecule-kind`](testing-molecule-kind/): A Molecule-based test environment which allows development and testing of Ansible playbooks against a Kind Kubernetes cluster.

