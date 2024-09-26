output "public-ip" {
    description = "output of the publicip"
  value = aws_instance.my-vpc-instance.public_ip
}
