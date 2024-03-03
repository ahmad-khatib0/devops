# OPA example

This folder contains a [Terraform](https://www.terraform.io/) configuration that deploys an EC2 instance in an [Amazon 
Web Services (AWS) account](http://aws.amazon.com/). The idea is to test this module against the OPA policy in 
[enforce_tagging.rego](../../../../opa/09-testing-terraform-code/enforce_tagging.rego), which will pass if this module
sets the proper tags, and fail otherwise.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) installed on your computer.
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

Configure your [AWS access
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Run `terraform plan` and save the output to a file:

```
terraform plan -out tfplan.binary
```

Convert the plan file to JSON:

```
terraform show -json tfplan.binary > tfplan.json
```

Run the JSON plan file against the [enforce_tagging.rego](../../../../opa/09-testing-terraform-code/enforce_tagging.rego)
OPA policy:

```
opa eval \
  --data enforce_tagging.rego \
  --input tfplan.json \
  --format pretty \
  data.terraform.allow
```

If the module set the required `ManagedBy` tag, the output will be:

```
true
```

If the module is missing that required tag, the output will be:

```
undefined
```
