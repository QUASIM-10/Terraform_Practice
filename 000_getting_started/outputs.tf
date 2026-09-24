output "instance_ip_address" {
  value = aws_instance.Terraform_Web_Server.public_ip
}

output "ami_number" {
  value = aws_instance.Terraform_Web_Server.ami
}

output "detailed_private_ip" {
  value       = aws_instance.Terraform_Web_Server.private_ip
  description = "This is the private IP address of the instance."
  sensitive   = false
}

output "instance_details" {
  value = {
    id            = aws_instance.Terraform_Web_Server.id
    public_ip     = aws_instance.Terraform_Web_Server.public_ip
    private_ip    = aws_instance.Terraform_Web_Server.private_ip
    ami           = aws_instance.Terraform_Web_Server.ami
    instance_type = aws_instance.Terraform_Web_Server.instance_type
    az            = aws_instance.Terraform_Web_Server.availability_zone
  }
}
