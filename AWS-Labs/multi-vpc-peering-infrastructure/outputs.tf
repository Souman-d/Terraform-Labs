# Prints instance IP details upon completion so you can easily run ping tests.

output "vpc_a_public_ec2_ip" {
  value = aws_instance.ec2_vpc_a_pub.public_ip
}

output "vpc_a_private_ec2_ip" {
  value = aws_instance.ec2_vpc_a_priv.private_ip
}

output "vpc_b_public_ec2_ip" {
  value = aws_instance.ec2_vpc_b_pub.public_ip
}

output "vpc_b_private_ec2_ip" {
  value = aws_instance.ec2_vpc_b_priv.private_ip
}