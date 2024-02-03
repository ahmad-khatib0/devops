# Automated testing examples

This folder contains examples of how to write automated tests for infrastructure code using Go and
[Terratest](https://terratest.gruntwork.io/).

Configure your [AWS access
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Run all the tests:

```
go test -v -timeout 90m
```

Run one specific test:

```
go test -v -timeout 90m -run '<TEST_NAME>'
```
