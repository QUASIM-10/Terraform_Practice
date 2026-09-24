resource "aws_instance" "Terraform_Web_Server" {
  ami           = "ami-0b2c9d1f3edcfd709"
  instance_type = var.instance_type #"t2.nano" WON'T RUN COS IT IS NOT AVAILABLE FOR FREE PLAN ACCOUNTS.

  tags = {
    Name = "MyTerraformServer_${local.project_name}"
  }

}
