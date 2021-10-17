#!/bin/bash

#script to install kubeadm on ubuntu 20
#Make sure that the br_netfilter module is loaded
modprobe br_netfilter
#you should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config,
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

#Installing runtime docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

#change the log driver to systemd and restart docker
cat <<EOF |  sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
 systemctl restart docker
#Installing kubeadm, kubelet and kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

#init kuberadm cluster
 kubeadm reset -f
 kubeadm init --pod-network-cidr=10.100.0.0/16

 export KUBECONFIG=/etc/kubernetes/admin.conf

 