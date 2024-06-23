resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  # you can paste the public key directly like this
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMH5b/PtlR8R+VM7U5sVs6ht98ySvDeb8M9nDievUh8C Mammu@DESKTOP-AUVJB9I"
  public_key = file("~/.ssh/openvpn.pub")
  # ~ means windows home directory
}
# this is openvpn provided this vpn service
# hence they have their own AMI,they have written this vpn on ubantu
# default username is: openvpnas
#password is:Keybased AMI,so you need to create key's
# after generating keys you need to impot public key into aws using terraform

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}