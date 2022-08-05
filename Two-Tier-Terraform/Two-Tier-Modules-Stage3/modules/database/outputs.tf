# ---- module/database/outputs.tf


output "database_endpoint" {
  value = aws_db_instance.project.endpoint
}
