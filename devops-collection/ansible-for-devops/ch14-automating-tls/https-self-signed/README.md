# HTTPS Self-Signed Certificate Demo VM

This project spins up a VM and demonstrates generating self-signed certificates locally.

## Quick Start Guide

### 1 - Install dependencies (VirtualBox, Vagrant, Ansible)

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
3. [Mac/Linux only] Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

Note for Windows users: _This guide assumes you're on a Mac or Linux host. Windows hosts are unsupported at this time._

### 2 - Build the Virtual Machine

1. Download this project and put it wherever you want.
2. Open Terminal, cd to this 'provisioning' directory.
3. Run `ansible-galaxy install -r requirements.yml` to install required Ansible roles.
4. cd up one level to this directory (with the README and Vagrantfile).
5. Type in `vagrant up`, and let Vagrant do its magic.

Note: _If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error._

### 3 - Configure your host machine to access the VM.

1. [Edit your hosts file](http://docs.rackspace.com/support/how-to/modify-your-hosts-file/), adding the line `192.168.56.84  https.test` so you can connect to the VM.
2. Open your browser and access [https://https.test](https://https.test).

## Notes

- To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
