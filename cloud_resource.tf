# 1. Provide MOCK credentials

# In the real world, you'd use environment variables, but for a mock, we can put them here:
provider "aws" {
  region     = "us-east-1"
  access_key = "MOCK_ACCESS_KEY_EXAMPLE_ONLY"
  secret_key = "MOCK_SECRET_KEY_EXAMPLE_ONLY"

  # This tells Terraform NOT to check if the credentials are real
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

# 2. Create the Cloud Resource (Mocked)
resource "aws_s3_bucket" "minimal" {
  bucket = "my-mock-demo-bucket-2026"
}
