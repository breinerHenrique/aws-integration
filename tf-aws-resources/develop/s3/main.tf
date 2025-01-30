resource "aws_s3_bucket" "this" {
  bucket = "my-tf-test-bucket-breiner-0076"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}