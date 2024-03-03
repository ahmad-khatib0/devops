# Hello-world-app standalone example

This folder contains a [Terraform](https://www.terraform.io/) configuration that shows an example of how to 
use the [hello-world-app module](../../../modules/services/hello-world-app) to deploy the "Hello, World" app in an 
[Amazon Web Services (AWS) account](http://aws.amazon.com/). We fill in a mock URL for the DB so that this example
can be deployed completely standalone, with no other dependencies.

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Deploy the code:

```
terraform init
terraform apply
```

Clean up when you're done:

```
terraform destroy
```
