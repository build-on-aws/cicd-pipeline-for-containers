resource "aws_codecommit_repository" "demo_codecommit_repo" {
  repository_name = var.codecommit_repo_name
  description     = "Code Repo"
}
