terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. The Resource (What we want to create)
resource "local_file" "note" {
  filename = "my_first_terraform_file.txt"
  content  = "Hello! I was created by Terraform. It manages me as ' as Code'!"
}