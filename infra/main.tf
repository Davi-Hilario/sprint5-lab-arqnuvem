provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "lab" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lab.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  tags = {
    Name = "Sprint5-EC2"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.lab.bucket
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}
