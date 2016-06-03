#!/usr/bin/env bash
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible sshpass

# ansible.cfg overbrengen
cp -a /vagrant/configs/ansible.cfg /home/vagrant
# inventory file copy
cp -a /vagrant/configs/inventory.ini /home/vagrant

# vagrant rechten geven
chown -R vagrant:vagrant /home/vagrant

ln -sf /vagrant/hosts /etc/ansible/hosts

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL

# vagrant environment nodes
192.168.2.5  mgr
192.168.2.6  lb
192.168.2.3  www1
192.168.2.4  www2
EOL

rm /home/vagrant/.ssh/known_host

KNOW_HOSTS_FILE="/home/vagrant/.ssh/known_hosts"

ssh-keyscan 192.168.2.3>> $KNOW_HOSTS_FILE 
ssh-keyscan 192.168.2.4>> $KNOW_HOSTS_FILE
ssh-keyscan 192.168.2.5>> $KNOW_HOSTS_FILE
ssh-keyscan localhost>> $KNOW_HOSTS_FILE
ssh-keyscan 192.168.2.6>> $KNOW_HOSTS_FILE 
chown vagrant:vagrant $KNOW_HOSTS_FILE 