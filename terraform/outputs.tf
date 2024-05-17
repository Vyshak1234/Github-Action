output "ecr_repository_url" {
  value = aws_ecr_repository.hello_world_app.repository_url
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.hello_world_cluster.id
}

output "ecs_service_id" {
  value = aws_ecs_service.hello_world_service.id
}

output "vpc_id" {
  value = aws_vpc.hello_world_vpc.id
}

output "subnet_id" {
  value = aws_subnet.hello_world_subnet.id
}

output "security_group_id" {
  value = aws_security_group.hello_world_sg.id
}
