#!/bin/bash

# Kubernetes Cluster Management
# ----------------------------

# Check pods in kube-system namespace
kubectl get pods -n kube-system

# Cluster status information
kubectl cluster-info

# List all nodes
kubectl get nodes

# Describe a specific node
kubectl describe node minikube

# List minikube addons
minikube addons list

# Deployment Management
# --------------------

# Create a deployment
kubectl create deployment echo --image=k8s.gcr.io/e2e-test-images/echoserver:2.5

# Expose deployment as NodePort service
kubectl expose deployment echo --type=NodePort --port=8080

# Get minikube IP
minikube ip

# Get service NodePort
kubectl get service echo -o jsonpath='{.spec.ports[0].nodePort}'

# Access service
curl http://$(minikube ip):$(kubectl get service echo -o jsonpath='{.spec.ports[0].nodePort}')/hi

# KinD Cluster Management
# ----------------------

# Create cluster using KinD config
kind create cluster --config kind-ha-multi-node-config.yaml --kubeconfig $TMPDIR/kind-ha-multi-node-config

# Get nodes in KinD cluster
kubectl get nodes --kubeconfig $TMPDIR/kind-ha-multi-node-config

# KinD-specific node listing
kind get nodes --name ha-multi-node-cluster

# Deploy and expose service in KinD
kubectl create deployment echo --image=g1g1/echo-server:0.1 --kubeconfig $TMPDIR/kind-ha-multi-node-config
kubectl expose deployment echo --type=NodePort --port=7070 --kubeconfig $TMPDIR/kind-ha-multi-node-config

# Access service through proxy
kubectl proxy --kubeconfig $TMPDIR/kind-ha-multi-node-config &
curl http://localhost:8001/api/v1/namespaces/default/services/echo:7070/proxy/yeah-it-works

# k3d Cluster Management
# ---------------------

# Create single-node cluster
k3d cluster create

# Delete cluster
k3d cluster delete

# Create multi-node cluster
k3d cluster create --agents 3

# Leader Election Examples
# -----------------------

# Scheduler leader election example
cat <<EOF
- /bin/sh
- -c
- /usr/local/bin/kube-scheduler --master=127.0.0.1:8080 --v=2 --leader-elect=true 
    1>> /var/log/kube-scheduler.log 2>&1
EOF

# Controller manager leader election example
cat <<EOF
- /bin/sh
- -c
- /usr/local/bin/kube-controller-manager --master=127.0.0.1:8080 --cluster-name=e2e-test-bburns
    --cluster-cidr=10.245.0.0/16 --allocate-node-cidrs=true --cloud-provider=gce
    --service-account-private-key-file=/srv/kubernetes/server.key
    --v=2 --leader-elect=true 1>>/var/log/kube-controller-manager.log 2>&1
EOF

# Security and RBAC
# -----------------

# Get service account details
kubectl get serviceaccounts/custom-service-account -o json

# Get service account secret
kubectl get secret custom-service-account-token-vbrbm -o yaml

# Check permissions
kubectl auth can-i create deployments
kubectl auth can-i create deployments --as jack

# Role summary
kubectl rolesum job-controller -n kube-system

# Create Docker registry secret
kubectl create secret docker-registry the-registry-secret \
  --docker-server= registry server <docker > \
  --docker-username= <username > \
  --docker-password= <password > \
  --docker-email=email

# Pod Security Admission
MODE=warn      # One of enforce, audit, or warn
LEVEL=baseline # One of privileged, baseline, or restricted
kubectl label namespace/ns-1 pod-security.kubernetes.io/${MODE}: ${LEVEL}

# Network Policies
kubectl create -n ${NAMESPACE} -f deny-all-network-policy.yaml

# Secrets Management
# -----------------

# Create generic secret
kubectl create secret generic hush-hush --from-literal=username=tobias --from-literal=password=cutoffs

# Get secret details
kubectl get secrets/hush-hush -o yaml

# Decode secret value
kubectl get secrets/hush-hush -o jsonpath='{.data.password}' | base64 --decode

# Create pod with secret
kubectl create -f pod-with-secret.yaml

# Access secret in pod
kubectl exec pod-with-secret -- cat /mnt/hush-hush/username

# Multi-tenancy with vcluster
# --------------------------

# Create virtual cluster
vcluster create tenant-1

# List contexts
kubectl config get-contexts -o name

# List resources in vcluster namespace
kubectl get all -n vcluster-tenant-1 --context kind-kind

# List namespaces in virtual cluster
kubectl get ns --context vcluster_tenant-1_vcluster-tenant-1_kind-kind

# Resource Inspection
# ------------------

# Explain resource
kubectl explain pod
kubectl explain pod.spec
kubectl explain pod.spec.containers

# Query with labels
kubectl get po -n kube-system --show-labels
kubectl get po -n kube-system -l k8s-app=kube-dns
kubectl get pods -l app=hue
kubectl get po -o wide -l app=hue,service=reminders

# Get container images
kubectl get pods -o jsonpath='{.items[*].spec.containers[0].image}' -l app=hue | xargs printf "%s\n"

# DNS Testing
kubectl exec hue-learn-68d74fd4b7-rw4qr -- nslookup hue-reminders.default.svc.cluster.local
kubectl exec hue-learn-68d74fd4b7-fh55c -- wget -q -O - hue-reminders.default.svc.cluster.local:8080

# Node Information
kubectl get po trouble-shooter -o jsonpath='{.spec.nodeName}'

# Taints and Tolerations
kubectl taint nodes k3d-k3s-default-server-0 control-plane=true:NoExecute
kubectl get nodes k3d-k3s-default-server-0 -o jsonpath='{.spec.taints[0]}'

# Context Configuration
kubectl config set-context k3d-k3s-restricted --cluster k3d-k3s-default

# Kustomize
kubectl kustomize base
kubectl kustomize overlays/staging
kubectl apply -k overlays/staging

# Jobs and Rollouts
kubectl get jobs
kubectl rollout status deployment/nginx-deployment
kubectl get deployment nginx -o yaml | grep strategy -A 4

# Resource Monitoring
kubectl top po

# Autoscaling
kubectl autoscale deployment bash-loop --min=4 --max=6 --cpu-percent=50

# Rollout Management
kubectl set image deployment/hue-reminders hue-reminders=g1g1/hue-reminders:3.0
kubectl rollout history deployment hue-reminders
kubectl rollout restart deployment DEPLOYMENT_NAME

# Scaling
kubectl scale deployment YOUR_DEPLOYMENT --replicas=6

# Watch resources
kubectl get pods -w
watch -d kubectl get deploy,hpa,pods

# Ingress Information
kubectl get ingress -o jsonpath="{.items[0].metadata.annotations['ingress\.kubernetes\.io\/forwarding-rule']}"

# Multi-node Minikube
minikube create --nodes 3

# Node Tainting and Labeling
kubectl taint nodes NODE_NAME spot=true:NoSchedule
kubectl taint nodes NODE_NAME spot-
kubectl taint nodes minikube-m02 group=1:NoSchedule
kubectl label node minikube-m02 group=1
kubectl taint nodes minikube-m03 group=2:NoSchedule
kubectl label node minikube-m03 group=2

# Storage Class Management
kubectl patch storageclass standard-rwo -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

# Resource Quotas
kubectl get quota

# Helm Management
# --------------

# Get Helm release status
helm status -n monitoring prometheus | grep STATUS
helm list -n monitoring

# Helm release secrets
kubectl describe secret sh.helm.release.v1.prometheus.v1 -n monitoring
helm list -A
kubectl get secret -A -l owner=helm

# Extract Helm release
kubectl get secret sh.helm.release.v1.prometheus.v1 -n monitoring -o jsonpath='{.data.release}' | base64 --decode | base64 --decode | gunzip >prometheus.v1.json

# Extract Helm manifests
kubectl get secret sh.helm.release.v1.prometheus.v1 -n monitoring -o jsonpath='{.data.release}' | base64 --decode | base64 --decode | gunzip | jq .manifest -r

# Helm Chart Customization
helm show values prometheus-community/prometheus | wc -l
helm show values prometheus-community/prometheus | head -n 20

# Install with custom values
helm install prometheus prometheus-community/prometheus --create-namespace -n monitoring -f custom-values.yaml

# Get current values
helm get values prometheus -n monitoring

# Upgrade release
helm upgrade --set alertmanager.enabled=false prometheus prometheus-community/prometheus -n monitoring
kubectl get deployment -n monitoring
helm get values prometheus -n monitoring

# Rollback release
helm history prometheus -n monitoring
helm rollback prometheus 1 -n monitoring
helm history prometheus -n monitoring

# Uninstall release
helm list -n monitoring
helm uninstall prometheus -n monitoring
helm list -n monitoring

# Custom Chart Development
helm create cool-chart
helm package cool-chart
helm lint cool-chart
helm dep up cool-chart

# Helm Template Debugging
helm install --set subchart2.enabled=false
helm template food food-chart
helm install food food-chart --dry-run -n monitoring
helm template food food-chart --set favorite.drink=water
helm install food food-chart -n monitoring
helm list -n monitoring

# DNS and CoreDNS
kubectl describe svc -n kube-system kube-dns
kubectl get po -n kube-system -l k8s-app=kube-dns
kubectl get deploy coredns -n kube-system -o jsonpath='{.spec.template.spec.containers[0]}' | jq .image

# Log Management
kubectl logs -l [label]

# Node Health Check
kubectl describe no kind-control-plane | grep Conditions -A 6

# Kubernetes API Access
kubectl proxy --port 8080
curl http://localhost:8080/apis/batch/v1
http http://localhost:8080/api/v1/services | jq '.items[].metadata.name'
