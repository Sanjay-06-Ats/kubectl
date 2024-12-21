sudo hostnamectl set-hostname "k8smaster.example.net"
exec bash
sudo /etc/hosts
sudo nano /etc/hosts
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf <<EOT
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOT

sudo sysctl --system
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo apt install -y curl gnupg software-properties-common apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo kubeadm init --control-plane-endpoint=k8smaster.example.net
sudo crictl rmi registry.k8s.io/pause:3.8
sudo systemctl restart containerd
sudo systemctl restart kubelet
kubectl get pods -n kube-system
sudo crictl images
kubectl cluster-info
kubectl get nodes
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
kubectl get pods -n kube-system
kubectl get nodes
sudo crictl images
sudo crictl --runtime-endpoint unix:///run/containerd/containerd.sock images
sudo systemctl status containerd
sudo systemctl status kubelet
sudo systemctl status containerd
kubectl logs -n kube-system -l k8s-app=calico-node
kubectl edit configmap calico-config -n kube-system
kubectl rollout restart daemonset/calico-node -n kube-system
kubectl logs -n kube-system -l k8s-app=calico-node
ip a
ifconfig
apt install net tools
kubectl edit configmap calico-config -n kube-system
kubectl patch configmap calico-config -n kube-system -p '{"data":{"mtuIfacePattern":"enX0"}}'
kubectl rollout restart daemonset/calico-node -n kube-system
nano calico-config-patch.yaml
kubectl apply -f calico-config-patch.yaml
kubectl rollout restart daemonset/calico-node -n kube-system
kubectl edit configmap calico-config -n kube-system
kubectl logs -n kube-system -l k8s-app=calico-node
ip a
kubectl get pods -n kube-system -l k8s-app=calico-node
kubectl describe pod calico-node-5fv5z -n kube-system
kubectl edit configmap calico-config -n kube-system
kubectl rollout restart daemonset calico-node -n kube-system
kubectl logs -n kube-system -l k8s-app=calico-node
kubectl describe pod calico-node-4ntzd -n kube-system
kubectl get pods kube-system
kubectl get pods -n kube-system
kubectl describe pod calico-node-4ntzd -n kube-system
kubectl get configmap -n kube-system calico-config
kubectl describe configmap -n kube-system calico-config
kubectl delete configmap -n kube-system calico-config
kubectl create configmap calico-config -n kube-system --from-literal=cni_network_config='{
  "name": "k8s-pod-network",
  "cniVersion": "0.3.1",
  "plugins": [
    {
      "type": "calico",
      "log_level": "info",
      "datastore_type": "kubernetes",
      "ipam": {
        "type": "calico-ipam"
      },
      "policy": {
        "type": "k8s"
      },
      "kubernetes": {
        "kubeconfig": "/etc/cni/net.d/calico-kubeconfig"
      }
    },
    {
      "type": "portmap",
      "snat": true,
      "capabilities": {"portMappings": true}
    }
  ]
}' --from-literal=calico_backend=bird --from-literal=mtu=9001 --from-literal=mtuIfacePattern=enX0
kubectl delete pod -n kube-system -l k8s-app=calico-node
kubectl get pods -n kube-system
kubectl delete pod -n kube-system -l k8s-app=calico-node
kubectl get pods -n kube-system
kubectl logs -n kube-system <calico-node-dnksd -c install-cni
kubectl logs -n kube-system calico-node-dnksd -c install-cni
kubectl describe pod -n kube-system calico-node-dnksd
kubectl describe configmap -n kube-system calico-config
ls /etc/cni/net.d/calico-kubeconfig
cat <<EOF | sudo tee /etc/cni/net.d/calico-kubeconfig
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: https://k8smaster.example.net:6443
    certificate-authority: /etc/kubernetes/pki/ca.crt
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: calico
  name: calico@kubernetes
current-context: calico@kubernetes
users:
- name: calico
  user:
    token: $(kubectl -n kube-system get secret $(kubectl -n kube-system get serviceaccount calico-node -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)
EOF

kubectl delete pod -n kube-system -l k8s-app=calico-node
kubectl get pods -n kube-system
kubectl logs -n kube-system calico-node-dnksd -c calico-node
kubectl logs -n kube-system calico-node-2nqdk -c install-cni
kubectl logs -n kube-system calico-node-2nqdk -c calico-node
kubectl logs -n kube-system calico-node-2nqdk -c install-cni
kubectl describe pod -n kube-system calico-node-2nqdk
kubectl edit configmap -n kube-system calico-config
kubectl delete pod -n kube-system -l k8s-app=calico-node
kubectl get pods -n kube-system
kubectl get pods -n kube-system
sudo crictl images
kubectl get pods -n kube-system -l k8s-app=calico-node
kubectl get pods -n kube-system
mkdir grafana
cd grafana/
nano monitoring-namespace.yaml
kubectl apply -f monitoring-namespace.yaml
nano grafana-deployment.yaml
nano grafana-service.yaml
kubectl apply -f grafana-deployment.yaml 
kubectl apply -f grafana-service.yaml 
kubectl get svc -n monitoring
kubectl describe svc grafana -n monitoring
ls
kubectl get svc
kubectl get pods -n metallb-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/main/config/manifests/metallb-native.yaml
kubectl get pods -n metallb-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/manifests/namespace.yaml
cd grafana/
nano metallb-config.yaml
kubectl apply -f metallb-config.yaml
kubectl get pods -n metallb-system
kubectl get svc -n monitoring
kubectl logs -n metallb-system controller-5b5b575d55-688d2
kubectl describe svc grafana -n monitoring
kubectl logs -n metallb-system controller-5b5b575d55-688d2
kubectl get configmap -n metallb-system config -o yaml
nano m
nano metallb-config.yaml 
kubectl apply -f metallb-config.yaml
kubectl get svc -n monitoring
kubectl patch svc grafana -n monitoring -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc -n monitoring
kubectl logs -n metallb-system controller-5b5b575d55-688d2
kubectl get secret metallb-webhook-cert -o yaml > secret.yaml
vi secret.yaml
kubectl get secret metallb-webhook-cert -n metallb-system
kubectl get secret metallb-webhook-cert -n metallb-system -o yaml
kubectl get secret metallb-webhook-cert -n metallb-system -o jsonpath='{.data.tls\.crt}' | base64 --decode > cert.pem
kubectl get secret metallb-webhook-cert -n metallb-system -o jsonpath='{.data.tls\.key}' | base64 --decode > key.pem
kubectl rollout restart deployment metallb-controller -n metallb-system
kubectl rollout restart deployment metallb-speaker -n metallb-system
kubectl get deployments -n metallb-system
kubectl get pods -n metallb-system
kubectl rollout restart deployment controller -n metallb-system
kubectl rollout restart deployment speaker -n metallb-system
kubectl get deployments -n metallb-system
kubectl get daemonsets -n metallb-system
kubectl rollout restart daemonset speaker -n metallb-system
kubectl get pods -n metallb-system
kubectl get deployments -n metallb-system
kubectl get pods -n metallb-system
kubectl get configmap -n metallb-system
kubectl describe configmap config -n metallb-system
kubectl get svc -o wide
ls
kubectl apply grafana-deployment.yaml 
kubectl apply -f grafana-deployment.yaml
ls
kubectl get svc 
kubectl apply -f grafana-service.yaml
kubectl get svc 
nano grafana-service.yaml 
kubectl apply -f grafana-service.yaml
kubectl get svc -A
kubectl get svc 
kubectl get svc grafana
kubectl get svc monitoring
kubectl logs -n metallb-system -l app=metallb --tail=50
kubectl apply -f metallb-config.yaml
kubectl describe svc grafana -n monitoring
kubectl get endpoints -n monitoring grafana
kubectl rollout restart deployment/controller -n metallb-system
kubectl rollout restart daemonset/speaker -n metallb-system
kubectl get svc -n monitoring
kubectl logs -n metallb-system -l app=metallb --all-containers
kubectl describe svc grafana -n monitoring
kubectl describe configmap -n metallb-system config
kubectl get pods -n metallb-system
kubectl logs -n metallb-system -l component=speaker
kubectl get svc -n monitoring
kubectl get nodes
kubectl logs -n metallb-system -l component=speaker
kubectl describe configmap -n metallb-system config
kubectl rollout restart deployment -n metallb-system controller
kubectl rollout restart deployment -n metallb-system speaker
kubectl get nodes
kubectl get svc -n monitoring
kubectl get svc 
ls
cd grafana/
kubectl get svc 
kubectl get svc -n monitoring
ls
nano metallb-config.yaml 
kubectl logs -n metallb-system -l component=speaker
kubectl get svc -n monitoring
kubectl get svc --all-namespaces
kubectl get pods -n monitoring
kubectl describe configmap config -n metallb-system
kubectl get nodes -o wide
arp -a | grep "172.31.32."
kubectl describe svc grafana -n monitoring
kubectl edit svc grafana -n monitoring
nano metallb-config.yaml 
kubectl get pods -n metallb-system
kubectl delete svc grafana -n monitoring
kubectl apply -f grafana-service.yaml
kubectl describe svc grafana -n monitoring
kubectl logs -n metallb-system -l component=speaker
kubectl apply -f metallb-config.yaml
kubectl describe svc grafana -n monitoring
kubectl describe configmap config -n metallb-system
kubectl get pods -n metallb-system
arp -n
apt install net-tools
arp -n
kubectl logs -n metallb-system -l component=speaker
ping 172.31.32.100
kubectl logs -n metallb-system -l component=speaker
arping -I enX0 172.31.32.100
kubectl get pods -n metallb-system -o wide
kubectl get pods -n metallb-system
kubectl get svc -n monitoring
kubectl logs -n metallb-system -l component=speaker
kubectl patch svc grafana -n monitoring -p '{"spec": {"loadBalancerIP": "172.31.32.100"}}'
kubectl logs -n metallb-system -l component=controller
kubectl get pods -n monitoring
kubectl get pods -n monitoring --show-labels
kubectl get pod grafana-7f9fd79dd5-gxgdq -n monitoring --show-labels
kubectl get endpoints grafana -n monitoring
kubectl logs -n metallb-system -l component=speaker
kubectl logs -n metallb-system -l component=controller
kubectl get pods -n monitoring --show-labels
kubectl describe pod grafana-7f9fd79dd5-gxgdq -n monitoring
kubectl logs grafana-7f9fd79dd5-gxgdq -n monitoring
clear
kubectl logs grafana-7f9fd79dd5-gxgdq -n monitoring
kubectl get service grafana -n monitoring -o yaml
kubectl get configmap -n metallb-system config -o yaml
kubectl get pods -n metallb-system
kubectl describe svc grafana -n monitoring
kubectl logs -n metallb-system -l component=speaker
kubectl logs -n metallb-system controller-5cfb67446f-85fmf
kubectl get svc -n monitoring grafana
kubectl get ipaddresspool -n metallb-system
kubectl get ippool -n metallb-system
kubectl describe ipaddresspool default-ipv4-ippool -n metallb-system
nano metallb-config.yaml 
nano metallb-ipaddresspool.yaml
kubectl apply -f metallb-ipaddresspool.yaml
kubectl get svc -n monitoring grafana
cd grafana/
kubectl get svc -n monitoring grafana
