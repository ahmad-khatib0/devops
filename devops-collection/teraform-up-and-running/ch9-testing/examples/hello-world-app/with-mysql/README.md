# Hello-world-app with MySQL example

This folder contains a [Terraform](https://www.terraform.io/) configuration that shows an example of how to 
use the [hello-world-app module](../../../modules/services/hello-world-app) to deploy the "Hello, World" app and the
[mysql module](../../../modules/data-stores/mysql) to deploy MySQL (using [RDS](https://aws.amazon.com/rds/)) in an 
[Amazon Web Services (AWS) account](http://aws.amazon.com/).

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Configure the database credentials as environment variables:

```
export TF_VAR_db_username=(desired database username)
export TF_VAR_db_password=(desired database password)
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
