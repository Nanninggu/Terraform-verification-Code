resource "aws_ami_from_instance" "web1_ami" {
  name               = "web1-ami"
  source_instance_id = var.source_instance_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "web1_launch_template" {
  name          = "web1-launch-template"
  image_id      = aws_ami_from_instance.web1_ami.id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}