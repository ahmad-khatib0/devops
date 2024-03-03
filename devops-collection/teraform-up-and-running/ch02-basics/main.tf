# terraform {
#   required_version = ">= 1.0.0, < 2.0.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

provider "aws" {
  region = "us-east-2"
}


# **********************************************************************
#                            single web server
# **********************************************************************
# if you change the region parameter to something other than us-east-2, you’ll 
# need to manually look up the corresponding Ubuntu AMI ID for that region
# resource "aws_instance" "example" {
#   ami           = "ami-0fb653ca2d3203ac1"
#   instance_type = "t2.micro"

# When you add a reference from one resource to another, you create an implicit
# dependency. Terraform parses these dependencies, builds a dependency graph from
# them, and uses that to automatically determine in which order it should create a resource
# vpc_security_group_ids = [aws_security_group.instance.id]

# The <<-EOF and EOF are Terraform’s heredoc syntax, which allows you to create
# multiline strings without having to insert \n characters all over the place.
# user_data = <<-EOL
#!/bin/bash
# echo "Hello, World" > index.html
# nohub busybox httpd -f -p ${var.server_port} &
# EOL

# The user_data_replace_on_change parameter is set to true so that when you
# change the user_data parameter and run apply, Terraform will terminate the
# original instance and launch a totally new one. Terraform’s default behavior is to
# update the original instance in place, but since User Data runs only on the very
# first boot, and your original instance already went through that boot process, you
# need to force the creation of a new instance to ensure your new User Data script
# actually gets executed.
# user_data_replace_on_change = true

# tags = {
#   Name = "terraform-example"
#  }
# }


# a launch configuration, which specifies how to configure each EC2 Instance in the ASG
resource "aws_launch_configuration" "example" {
  image_id      = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.instance.id]
  user_data       = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

  lifecycle {
    # NOTE: that the ASG
    # uses a reference to fill in the launch configuration name. This leads to a problem:
    # launch configurations are immutable, so if you change any parameter of your launch
    # configuration, Terraform will try to replace it. Normally, when replacing a resource,
    # Terraform would delete the old resource first and then creates its replacement, but
    # because your ASG now has a reference to the old resource, Terraform won’t be able to delete it.
    # To solve this problem, you can use a lifecycle setting. Every Terraform resource
    # supports several lifecycle settings that configure how that resource is created, upda‐
    # ted, and/or deleted. A particularly useful lifecycle setting is create_before_destroy.
    # If you set create_before_destroy to true, Terraform will invert the order in which
    # it replaces resources, creating the replacement resource first (including updating
    # any references that were pointing at the old resource to point to the replacement)
    # and then deleting the old resource
    # 
    # IMPORTANT: Required when using a launch configuration with an auto scaling group. 
    create_before_destroy = true
  }
}

# This ASG will run between 2 and 10 EC2 Instances (defaulting to 2 for the initial launch), 
# each tagged with the name terraform-asg-example
#
# The default health_check_type is "EC2", which is a minimal health check that considers an
# Instance unhealthy only if the AWS hypervisor says the VM is completely down or
# unreachable. The "ELB" health check is more robust, because it instructs the ASG to use the 
# target group’s health check to determine whether an Instance is healthy and to automatically 
# replace Instances if the target group reports them as unhealthy. That way, Instances will be 
# replaced not only if they are completely down but also if, for example, they’ve stopped serving 
# requests because they ran out of memory or a critical process crashed.
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  target_group_arns    = [aws_lb_target_group.asg.arn]
  health_check_type    = "ELB"
  min_size             = 2
  max_size             = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = var.instance_security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # CIDR blocks are a concise way to specify IP address ranges. For example, a CIDR block 
    # of 10.0.0.0/24 represents all IP addresses between 10.0.0.0 and 10.0.0.255. The CIDR 
    # block 0.0.0.0/0 is an IP address range that includes all possible IP addresses, 
    # so this security group allows incoming requests on port 8080 from any IP.
  }
}

# A data source represents a piece of read-only information that is fetched from the
# provider (in this case, AWS) every time you run Terraform. Adding a data source
# to your Terraform configurations does not create anything new
# Each Terraform provider exposes a variety of data sources. For
# example, the AWS Provider includes data sources to look up VPC data, subnet data,
# AMI IDs, IP address ranges, the current user’s identity, and much more.
data "aws_vpc" "default" {
  default = true # look up the Default VPC in your AWS account
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


resource "aws_lb" "example" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

# define a listener for this ALB using the aws_lb_listener resource
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  # send a simple 404 page as the default response for requests that don’t match any listener rules
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {
  name     = var.alb_name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


# a listener rule that sends requests that match any path to the target group that contains your ASG
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}


# by default, all AWS resources, including ALBs, don’t allow any incoming or
# outgoing traffic, so you need to create a new security group specifically for the ALB
# This security group should allow incoming requests on port 80 so that you can access
# the load balancer over HTTP, and allow outgoing requests on all ports so that the
# load balancer can perform health checks
resource "aws_security_group" "alb" {
  name = var.alb_security_group_name

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



