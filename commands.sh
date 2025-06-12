# see the list of images installed by k3d (it uses containerd)
docker exec -it k3d-yourcluster-server-0 ctr -n k8s.io images ls

# If you want to validate specific images are pulled inside the K3s (containerd) runtime:
docker exec -it k3d-yourcluster-server-0 ctr -n k8s.io images ls | grep "rancher/local-path-provisioner"

# grep the list of installed/pulled images across the cluster
kubectl describe pods -A | grep -i "image" -A 5
