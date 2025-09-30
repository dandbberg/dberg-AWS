output "ecr_repo_urls" {
  value = {
    for k, repo in aws_ecr_repository.apps : k => repo.repository_url
  }
}