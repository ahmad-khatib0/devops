#!/bin/bash

# Terraform Basic Commands
# ------------------------

# Initialize Terraform
terraform init

# Show execution plan
terraform plan

# Apply changes
terraform apply

# Show dependency graph
terraform graph

# Plan with variable override
terraform plan -var "server_port=8080"

# Show output variables
terraform output
terraform output OUTPUT_NAME

# Terraform Workspaces
# -------------------

# Show current workspace
terraform workspace show

# Create new workspace
terraform workspace new example1

# List all workspaces
terraform workspace list

# Switch workspace
terraform workspace select example1

# Terraform Console
# ----------------

# Start interactive console (read-only)
terraform console
# Example usage:
# > format("%.3f", 3.14159265359)  # Returns: 3.142

# tfenv Version Management
# -----------------------

# Install version
tfenv install

# Other tfenv commands:
# tfenv use       # Switch version
# tfenv list      # List installed versions

# Cross-Platform Lock Files
# ------------------------

# Generate lock files for multiple platforms
terraform providers lock \
  -platform=windows_amd64 \  # 64-bit Windows
-platform=darwin_amd64 \     # 64-bit macOS (Intel)
-platform=darwin_arm64 \     # 64-bit macOS (ARM)
-platform=linux_amd64        # 64-bit Linux

# Open Policy Agent (OPA) Integration
# ----------------------------------

# Sample policy check workflow:

# 1. Create plan file
terraform plan -out tfplan.binary

# 2. Convert plan to JSON
terraform show -json tfplan.binary >tfplan.json

# 3. Evaluate policy (example with enforce_tagging.rego)
opa eval --data enforce_tagging.rego --input tfplan.json --format pretty data.terraform.allow

# Example Policy (enforce_tagging.rego):
cat <<EOF
package terraform
allow {
  resource_change := input.resource_changes[_]
  resource_change.change.after.tags["ManagedBy"]
}
EOF

# Example Terraform resource without required tag:
cat <<EOF
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
EOF
# OPA output: undefined (policy violation)

# Example Terraform resource with required tag:
cat <<EOF
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    ManagedBy = "terraform"
  }
}
EOF
# OPA output: true (policy compliant)
