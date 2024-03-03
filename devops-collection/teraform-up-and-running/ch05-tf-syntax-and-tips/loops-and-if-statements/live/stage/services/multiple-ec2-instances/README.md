# Multiple servers example

This folder contains an example [Terraform](https://www.terraform.io/) configuration that deploys multiple web servers 
(using [EC2](https://aws.amazon.com/ec2/)). The goal of these configuration is to demonstrate how to use the +count+
parameter in Terraform, as well as some of its limitations.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

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
