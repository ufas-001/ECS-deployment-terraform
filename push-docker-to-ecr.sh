#!/bin/bash

# Set your variables
AWS_REGION="us-east-1"        # Replace with your AWS region
AWS_ACCOUNT_ID="$1"
ECR_REPO_NAME="thehufaaz/todo-client-side"
DOCKER_IMAGE_TAG="latest"

# Authenticate Docker with ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build and tag your Docker image
# docker build -t $ECR_REPO_NAME:$DOCKER_IMAGE_TAG .

# Tag the image for ECR
docker tag $ECR_REPO_NAME:$DOCKER_IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$DOCKER_IMAGE_TAG

# Push the image to ECR
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$DOCKER_IMAGE_TAG
