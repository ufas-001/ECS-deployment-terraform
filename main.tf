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
  name = "thehufaaz/todo-client-side"
}

resource "aws_ecr_repository_policy" "my_repository_policy" {
  repository = aws_ecr_repository.my_repository.name

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
  triggers = {
    ecr_repository_id = aws_ecr_repository.my_repository.id
  }

  provisioner "local-exec" {
    command = "./push-docker-to-ecr.sh ${var.AWS_ACCOUNT_ID}"
  }
}