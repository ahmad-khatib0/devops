# Auto Scaling Group with Rolling Deploy 

This folder contains an example [Terraform](https://www.terraform.io/) configuration that defines a module for 
deploying a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) and [Auto 
Scaling](https://aws.amazon.com/autoscaling/)) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). 
The Auto Scaling Group is able to do a zero-downtime deployment (using [instance
refresh](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-instance-refresh.html)) when you update any of its 
properties.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform 
configurations. See [live/stage/services/hello-world-app](../../../live/stage/services/hello-world-app) and
[live/prod/services/hello-world-app](../../../live/prod/services/hello-world-app) for examples.
