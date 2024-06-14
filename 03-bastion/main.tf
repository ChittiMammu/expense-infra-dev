
## this is a custom module,we took this code from centralized github (internet)

module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}


## A bastion server, also known as a jump server or jump host, is a secure, 
# hardened server that acts as an entry point into a private network or cloud environment. 
# It's typically used to access and manage servers, applications, or databases that are not exposed/accessed 
# to the public internet.

# A bastion server provides an additional layer of security by:

# 1. Acting as a single entry point, reducing the attack surface.
# 2. Providing secure access for administrators, developers, and users.
  
