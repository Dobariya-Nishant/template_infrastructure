output "id" {
  description = "Application Load Balancer ID."
  value       = aws_lb.this.id
}

output "listener_arn" {
  description = "ARN of the ALB HTTPS listener."
  value       = var.acm_certificate_arn != null ? aws_lb_listener.https[0].arn : aws_lb_listener.http[0].arn
}

output "dns_name" {
  value = aws_lb.this.dns_name
}

output "zone_id" {
  value = aws_lb.this.zone_id
}

output "blue_tg" {
  description = "the blue (active) target groups"
  value = {
    for k, tg in aws_lb_target_group.blue :
    k => {
      name = tg.name
      arn  = tg.arn
    }
  }
}

output "green_tg" {
  description = "the green (test) target groups"
  value = {
    for k, tg in aws_lb_target_group.green :
    k => {
      name = tg.name
      arn  = tg.arn
    }
  }
}