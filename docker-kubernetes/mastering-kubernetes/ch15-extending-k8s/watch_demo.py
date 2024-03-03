
# Watching objects is an advanced capability. It is implemented using a separate watch
# module. Here is an example of watching 10 namespace events and printing them to the screen

# Accessing the Kubernetes API via the Python client
from kubernetes import client, config, watch

# Configs can be set in Configuration class directly or using helper utility
config.load_kube_config()
v1 = client.CoreV1Api()

count = 10
w = watch.Watch()
for event in w.stream(v1.list_namespace, _request_timeout=60):
    print(f"Event: {event['type']} {event['object'].metadata.name}")
    count -= 1
    if count == 0:
        w.stop()
print('Done.')
