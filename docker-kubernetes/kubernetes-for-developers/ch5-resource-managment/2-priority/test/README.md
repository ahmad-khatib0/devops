Priority classes can be used without preemption (`preemptionPolicy: Never`) which governs the
scheduling and eviction order

To run this test, try the following:

On a cluster with 3 or less nodes:

```
# Fill the cluster with Pods that have no priority set
kubectl create -f deploy_no_priority.yaml

# Check the status
kubectl get pods

# You should see a bunch of pods with "Pending" since we filled up the nodes.

# Create a high priority class
kubectl create -f priorityclass_with_preemption.yaml

# Create a high priority deployment
kubectl create -f deploy_high_priority.yaml

# Check the status
kubectl get pods
```

Normally, since we filled the nodes up with other Pods, Pods in the second deployment would
sit there pending. But with `preemptionPolicy: PreemptLowerPriority`, Pods from the previous
deployment are evicted to make room.

direct enough load at the Pod to simulate a real world usage. Performance tools like
Apache Bench (installed with Apache 1 ) can help here. An example Apache Bench command
that will generate 10k requests total using 20 threads is below. You typically want to run this
test for a while (say, 5 minutes) to make it simpler to observe the high water mark.

```sh
    ab -n 10000 -c 20 https://example.com
```

run 

```sh
    kubectl top pods
```

The ideal situation would be to observe a Pod receiving normal production load. To avoid
impacting production, you can temporarily overprovision your capacity (by setting high
resource requests) and adding extra nodes to your cluster. Once you have a good measure
of the actual needs, you can later tune the requests and right-size the cluster.

## Cleanup

```sh 
    kubectl delete -f .
```

