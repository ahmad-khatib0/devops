#!/bin/bash

# Kubernetes Command Reference
# ---------------------------

# Basic Resource Inspection
kubectl get pods | services | deployments | all
kubectl delete deployment first-app # or service or other resource

# Imperative Deployment Workflow
# -----------------------------

# 1. Create deployment
kubectl create deployment first-app --image=remote-docker-hub/first-app
# --image=image1,image2,imageN creates multiple containers from these images

# 2. Expose deployment
kubectl expose deployment first-app --type=LoadBalancer --port=8080
# LoadBalancer generates a unique address and distributes traffic across pods
# Only available if host machine supports it (minikube does)
# Other types:
# --type=ClusterIP (reachable internally only)
# --type=NodePort (exposed via worker node's IP)

# 3. Get external service URL (minikube)
minikube service first-app

# 4. Scale deployment
kubectl scale deployment/first-app --replicas=3
# LoadBalancer distributes traffic across pods
# If a pod crashes, access remains unaffected
# Scale down: --replicas=1 (terminates extra pods)

# 5. Update deployment image
docker push remote-docker-hub
kubectl set image deployment/first-app kub-first-app=ahmadkh007/kub-first-app
# Note: Won't pull new image without different tag
docker push remote-docker-hub:2 # Push with new tag
kubectl set image deployment/first-app kub-first-app=ahmadkh007/kub-first-app:2
kubectl rollout status deployment/first-app # Check update status

# 6. Rollback management
kubectl set image deployment/first-app kub-first-app=ahmadkh007/kub-first-app:notExistingTag
kubectl rollout undo deployment/first-app                 # Undo last update
kubectl rollout history deployment/first-app              # View rollout history
kubectl rollout history deployment/first-app --revision=3 # View specific revision
kubectl rollout undo deployment/first-app --to-revision=1 # Restore to revision 1
# Undo operations are numbered in history (check penultimate revision if needed)

# Key Concepts
# ------------

# Pods:
# - Internal IPs are not reachable and change when pods are replaced
# - Services group pods with stable, reachable IPs

# Replicas:
# - Instance of a pod/container (3 replicas = 3 identical pods running)

# Declarative Approach
# --------------------

kubectl apply -f=deployment.yaml # or multiple files: -f=file1 -f=file2
# To update: Modify files (tags, replicas etc.) and re-apply
kubectl delete -f=deployment.yaml,service.yaml      # Delete resources from files
kubectl delete deployment,services -l group=example # Delete by label

# With imagePullPolicy: Always, kubectl apply will pull new images even without tag changes

# Storage Concepts
# ----------------

# emptyDir:
# - Creates empty directory when pod starts
# - Data persists through container restarts but not pod deletions

# hostPath (minikube limitations):
# - Data survives pod removal but is node-specific
# - Not reachable outside the single node in minikube

# persistentVolumeClaim (multi-node solution):
# - Node-independent storage
# Access modes:
# - ReadWriteOnce (single node read-write)
# - ReadOnlyMany (multi-node read-only)
# - ReadWriteMany (multi-node read-write)

# Storage Inspection
kubectl get configmap # Environment variables
kubectl get pv        # Persistent volumes
kubectl get pvc       # Persistent volume claims
kubectl get sc        # Storage classes
# Storage classes give admins control over volume configuration

# Deployment order: Apply PV → PVC → Deployment YAMLs

# Networking Concepts
# ------------------

# Inter-container communication within pod: use localhost

# Automatic environment variables:
# Kubernetes generates service-related ENV vars (e.g. STORY_SERVICE_SERVICE_HOST)
# Alternative to hardcoded IPs in config

# CoreDNS service discovery:
# Services can be reached via <service-name>.<namespace> (e.g. auth-service.default)
kubectl get namespaces # View available namespaces
