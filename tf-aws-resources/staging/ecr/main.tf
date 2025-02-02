resource "aws_ecr_repository" "this" {
  name                 = "ecr-test1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}