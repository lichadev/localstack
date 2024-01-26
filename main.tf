resource "aws_vpc" "development"{
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "development-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = "my-bucket"
}
