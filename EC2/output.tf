output "aws_instance_public_ip" {
  value = aws_instance.terraformEc2_2.public_ip
}

output "aws_instance_id" {
  value = aws_instance.terraformEc2_2.id
}

output "aws_instance_private_ip" {
  value = aws_instance.terraformEc2_2.private_ip
}

output "aws_instance_ami" {
  value = aws_instance.terraformEc2_2.ami
}

output "availability_zone" {
  value = aws_instance.terraformEc2_2.availability_zone
}