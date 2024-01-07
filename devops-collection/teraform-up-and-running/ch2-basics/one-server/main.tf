
provider "aws" {
  region = "us-east-2"
}

# if you change the region parameter to something other than us-east-2, you’ll 
# need to manually look up the corresponding Ubuntu AMI ID for that region
resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
