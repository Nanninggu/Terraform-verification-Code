output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "aws_lb_target_group" {
  value = aws_lb_target_group.this.arn
}