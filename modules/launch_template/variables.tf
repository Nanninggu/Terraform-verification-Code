variable "source_instance_id" {
  description = "The ID of the source instance to create the AMI from"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the launch template"
  type        = string
}