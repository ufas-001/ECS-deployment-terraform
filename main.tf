terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  backend "s3" {
    bucket         = "ecs-deployment-state-file"
    key            = "tfstate"
    region         = "us-east-1"
  }
}

resource "aws_ecr_repository" "my_repository" {
  name = var.images[count.index]
  count = length(var.images)
}

resource "aws_ecr_repository_policy" "my_repository_policy" {
  repository = aws_ecr_repository.my_repository[count.index].name
  count = length(var.images)
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid   = "AllowPushPull",
        Effect = "Allow",
        Principal = "*",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}

resource "null_resource" "push_docker" {
  count = length(var.images)
  triggers = {
    ecr_repository_id = aws_ecr_repository.my_repository[count.index].id
  }

  provisioner "local-exec" {
    command = "./push-docker-to-ecr.sh"
    environment = {
      AWS_ACCOUNT_ID = var.AWS_ACCOUNT_ID
      ECR_REPO_NAME = var.images[count.index]
    }
  }
}