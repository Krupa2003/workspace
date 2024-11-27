region              = "us-east-1"
ami_id              = "ami-002ce652451ab79d9"  # Replace with the actual AMI ID for the dev environment
vpc_cidr_block      = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
key_name            = "terraform-key"
availability_zone   = "us-east-1a"
