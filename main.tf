/*
provider "aws" {
  region     = "us-east-2"
#  access_key = "AKIAQKPXXXFJXX"
#  secret_key = "Hc6y9kmPIhpX8c78yN15HXXXXX"
}

resource "aws_instance" "myec2" {
    ami = "ami-09efc42336106d2f2"
    instance_type = "t2.micro"
    subnet_id = "subnet-09a9af54692efdc4a"
    vpc_security_group_ids = ["sg-05203aeb1d1a78390"]
}
*/

###################   Retreive the AMI-ID for Cat8000V   ###################
provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "catalyst_8000v" {
  most_recent = true
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["Cisco-C8K-17.12.04*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

output "catalyst_8000v_ami_id" {
  value = data.aws_ami.catalyst_8000v.id
}

###################   Create a Cat8000V Instance   ###################


resource "aws_instance" "catalyst_8000v" {
  ami           = data.aws_ami.catalyst_8000v.id
  instance_type = "c5.large"
  key_name      = "mqabaha-key"
  subnet_id = "subnet-09a9af54692efdc4a"
  vpc_security_group_ids = ["sg-05203aeb1d1a78390"]

}

# Allocate an Elastic IP
resource "aws_eip" "catalyst_8000v" {
  instance = aws_instance.catalyst_8000v.id
}

# Terraform data resource to run the scripts after the EIP is created
resource "terraform_data" "run_scripts" {
  depends_on = [aws_instance.catalyst_8000v, aws_eip.catalyst_8000v]

  provisioner "local-exec" {
    command = <<EOT
      ./wait_for_instance.sh ${aws_eip.catalyst_8000v.public_ip}
    EOT    
  }
}


# Output the private IP of the instance
output "catalyst_8000v_private_ip" {
  value = aws_instance.catalyst_8000v.private_ip
}

# Output the Elastic IP of the instance
output "catalyst_8000v_elastic_ip" {
  value = aws_eip.catalyst_8000v.public_ip
}

/*

provider "aws" {
  region = "us-east-2"
}

# Data source to get information about running instances
data "aws_instances" "running_instances" {
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# Loop through the instances and get detailed information
data "aws_instance" "instance_details" {
  count = length(data.aws_instances.running_instances.ids)
  instance_id = data.aws_instances.running_instances.ids[count.index]
}

# Output the details of the running instances
output "instance_details" {
  value = [
    for instance in data.aws_instance.instance_details :
    {
      instance_id = instance.id
      public_ip   = instance.public_ip
      private_ip  = instance.private_ip
      vpc_id      = instance.vpc_security_group_ids
      subnet_id   = instance.subnet_id
      key_name    = instance.key_name
      security_groups = instance.security_groups
      tags        = instance.tags
    }
  ]
}
*/