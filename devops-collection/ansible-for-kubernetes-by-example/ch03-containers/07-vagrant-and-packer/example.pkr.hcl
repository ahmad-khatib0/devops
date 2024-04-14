
 # use Ansible as a provisioner to build a Docker image, 
 # 
 # $ packer init .
 # $ packer build .
variable "ansible_connection" {
  default = "docker"
}

source "docker" "example" {
  image = "ubuntu:latest"
  commit = true
}

build {
  sources = ["source.docker.example"]
  provisioner "ansible" {
    playbook_file = "playbook.yaml"
  }
}
