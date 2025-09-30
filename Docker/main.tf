## Below code is working, image is build and pushed to ECR.
## However, as it builds on  the local machine e.g. mac, it isn't compatible with the EKS platform and there some other conflicts." {
## For the sake of the task I did a little bit ugly approach here, while idealy would be an CI/CD.

resource "null_resource" "build_and_push" {
  depends_on = [aws_ecr_repository.apps]

  for_each = local.apps

  triggers = {
    always_run      = timestamp()
    dockerfile_hash = filesha256("${path.module}/dockerfiles/${each.key}/Dockerfile")
    context_hash = sha256(join("", [
      for f in fileset("${path.module}/dockerfiles/${each.key}", "**") :
      filesha256("${path.module}/dockerfiles/${each.key}/${f}")
    ]))
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "🔐 Logging in to ECR"
      aws ecr get-login-password --region ${var.region} | \
        docker login --username AWS --password-stdin ${aws_ecr_repository.apps[each.key].repository_url}

      echo "🐳 Creating builder if needed"
      docker buildx create --use || true

      echo "📦 Building and pushing image for ${each.key}"
      docker buildx build --no-cache \
        --platform linux/amd64 \
        -t ${aws_ecr_repository.apps[each.key].repository_url}:${each.key}-latest \
        -f ${path.module}/dockerfiles/${each.key}/Dockerfile \
        ${path.module}/dockerfiles/${each.key} \
        --push
    EOT
  }
}