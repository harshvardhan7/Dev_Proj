#ecr repository name
data "aws_ecr_repository" "ecr_repo" {
  name = "game"
}
#fetch the tag of most recently pushed image
data "external" "tags_of_most_recently_pushed_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name",data.aws_ecr_repository.ecr_repo.name,
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageTags)}",
    "--region", var.ecr_repo_region,
  ]
}

locals {

  recent_img_tag = jsondecode(data.external.tags_of_most_recently_pushed_image.result.tags)
}

#input values to template file
data "template_file" "app" {
  template = file("./templates/ecs/app.json.tpl")

  vars = {
   // app_image      = var.app_image
    app_image      = "${data.aws_ecr_repository.ecr_repo.repository_url}:${local.recent_img_tag[0]}"
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.ecr_repo_region
  }
}

#iam_policy for ecs_task_execution_role
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}