
provider "aws" {
  region = "us-east-2"
}

# if you change the region parameter to something other than us-east-2, you’ll 
# need to manually look up the corresponding Ubuntu AMI ID for that region
resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"

  # When you add a reference from one resource to another, you create an implicit
  # dependency. Terraform parses these dependencies, builds a dependency graph from
  # them, and uses that to automatically determine in which order it should create a resource
  vpc_security_group_ids = [aws_security_group.instance.id]

  # The <<-EOF and EOF are Terraform’s heredoc syntax, which allows you to create
  # multiline strings without having to insert \n characters all over the place.
  user_data = <<-EOL
    #!/bin/bash
    echo "Hello, World" > index.html
    nohub busybox httpd -f -p 8080 &
    EOL

  # The user_data_replace_on_change parameter is set to true so that when you
  # change the user_data parameter and run apply, Terraform will terminate the
  # original instance and launch a totally new one. Terraform’s default behavior is to
  # update the original instance in place, but since User Data runs only on the very
  # first boot, and your original instance already went through that boot process, you
  # need to force the creation of a new instance to ensure your new User Data script
  # actually gets executed.
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # CIDR blocks are a concise way to specify IP address ranges. For example, a CIDR block 
    # of 10.0.0.0/24 represents all IP addresses between 10.0.0.0 and 10.0.0.255. The CIDR 
    # block 0.0.0.0/0 is an IP address range that includes all possible IP addresses, 
    # so this security group allows incoming requests on port 8080 from any IP.
  }
}


