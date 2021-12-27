resource "aws_ecr_repository" "main" {
  name                 = "Appimage"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action       = {
        type = "expire"
      }
      selection     = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

output "aws_ecr_repository_url" {
    value = aws_ecr_repository.main.repository_url
}