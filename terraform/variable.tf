variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-west-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  default     = "us-west-1a"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  default     = "hello-world-cluster"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  default     = "hello-world-app"
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  default     = "hello-world-service"
}
