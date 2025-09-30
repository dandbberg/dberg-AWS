## For the sake of the task I did a little bit ugly approach here, while idealy would be an CI/CD.

locals {
  apps = {
    task1 = "dberg-ecr1"
    task2 = "dberg-ecr2"
  }
}

resource "aws_ecr_repository" "apps" {
  for_each              = local.apps
  name                 = each.value
  #name                 = "dberg-ecr-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}