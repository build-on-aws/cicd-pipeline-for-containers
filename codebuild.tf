resource "aws_s3_bucket" "codebuild_logs_bucket" {
  bucket = "codebuild-logs-${local.region}-${local.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codebuild_logs_s3_sse" {
  bucket = aws_s3_bucket.codebuild_logs_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.codebuild_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#################### CODEBUILD TEST #############################
resource "aws_codebuild_project" "demo_codebuild_test_project" {
  name          = var.codebuild_test_project_name
  description   = "demo codebuild test project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = var.source_type
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_logs_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "false"

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-test-log-group"
      stream_name = "codebuild-test-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_logs_bucket.id}/build-log"
    }
  }

  source {
    type = var.source_type
    buildspec = var.testspec
  }
}

#################### CODEBUILD LINT #############################
resource "aws_codebuild_project" "demo_codebuild_lint_project" {
  name          = var.codebuild_lint_project_name
  description   = "demo codebuild lint project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = var.source_type
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_logs_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "false"

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-lint-log-group"
      stream_name = "codebuild-lint-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_logs_bucket.id}/build-log"
    }
  }

  source {
    type = var.source_type
    buildspec = var.lintspec
  }
}

#################### CODEBUILD PROJECT CONTAINER IMAGE BUILD #############################

resource "aws_codebuild_project" "demo_codebuild_project" {
  name          = var.codebuild_project_name
  description   = "demo build project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = var.source_type
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_logs_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = local.region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.demo_ecr_repo.name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = var.image_tag
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-log-group"
      stream_name = "codebuild-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_logs_bucket.id}/build-log"
    }
  }

  source {
    type = var.source_type
    buildspec = var.buildspec
  }
}


#################### CODEBUILD PROJECT DEPLOY#############################
resource "aws_codebuild_project" "demo_codebuild_deploy_project" {
  name          = var.codebuild_deploy_project_name
  description   = "demo codebuild deploy project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = var.source_type
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_logs_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "false"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = local.region
    }

    environment_variable {
      name  = "AWS_CLUSTER_NAME"
      value = var.eks_cluster_name
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.demo_ecr_repo.name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = var.image_tag
    }

    environment_variable {
      name  = "APP_NAME"
      value = var.app_name
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-deploy-log-group"
      stream_name = "codebuild-deploy-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_logs_bucket.id}/build-log"
    }
  }

  source {
    type = var.source_type
    buildspec = var.deployspec
  }
}

