# create several backend.tfvars files that only contain the properties of the backends.
#
## 
# The storage_account_name property contains the name of the storage
# account, the container_name property contains the container name, the key
# property contains the name of the blob state object, and the snapshot property
# enables a snapshot of this blog object at each edition by Terraform execution.
storage_account_name = "storageremotetf"
container_name       = "tfbackends"
key                  = "myappli.tfstate"
snapshot             = true
