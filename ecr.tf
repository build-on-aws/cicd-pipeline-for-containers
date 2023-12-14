resource "aws_ecr_registry_scanning_configuration" "ecr_scan_config" {
  scan_type = "BASIC"

  rule {
    scan_frequency = "SCAN_ON_PUSH"
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }
}

resource "aws_ecr_repository" "demo_ecr_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
