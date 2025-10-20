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

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "kp" {
  key_name   = "key_19102025"
  public_key = "~/.ssh/${tls_private_key.pk.public_key_openssh}"
}
resource "local_file" "ssh_key" {
  filename        = "${aws_key_pair.kp.key_name}.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0400"
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
