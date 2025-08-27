# outputs.tf

output "load_balancer_dns_name" {
  description = "El nombre DNS del Application Load Balancer."
  value       = aws_lb.mi_alb.dns_name
}