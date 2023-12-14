resource "aws_cloudwatch_event_rule" "demo_repo_activity" {
  name        = "demo-repo-activity"
  description = "Detect commits to repo"

  event_pattern = <<PATTERN
  {
    "source": [ "aws.codecommit" ],
    "detail-type": [ "CodeCommit Repository State Change" ],
    "resources": [ "arn:aws:codecommit:${local.region}:${local.account_id}:${aws_codecommit_repository.demo_codecommit_repo.repository_name}" ],
    "detail": {
      "event": [
        "referenceCreated",
        "referenceUpdated"
        ],
      "referenceType":["branch"],
      "referenceName": ["${var.codecommit_repo_branch_name}"]
    }
  }
  PATTERN
}

resource "aws_cloudwatch_event_target" "demo_repo_trigger" {
  target_id = "demo_repo_trigger"
  rule      = aws_cloudwatch_event_rule.demo_repo_activity.name
  arn      = aws_codepipeline.demo_codepipeline.arn
  role_arn = aws_iam_role.cloudwatch_ci_role.arn
}


