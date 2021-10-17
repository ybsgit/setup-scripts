 #!/bin/bash
 kubeadm reset -f
 kubeadm init --pod-network-cidr=10.100.0.0/16
 export KUBECONFIG=/etc/kubernetes/admin.conf