module "vpc" {
  source      = "./modules/vpc"
  name_prefix = var.name_prefix
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
}

module "bastion" {
  depends_on = [ module.vpc ]
  source          = "./modules/bastion_ec2"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnets[0]
  vpc_id          = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  key_pair_name   = var.key_pair_name
  name_prefix      = var.name_prefix
}

# module "private_ec2" {
#   source           = "./modules/private_ec2"
#   vpc_id           = module.vpc.vpc_id
#   private_subnet_id = module.vpc.private_subnets[0]
#   bastion_sg_id    = module.bastion.bastion_sg_id
#   ami_id           = var.ami_id
#   instance_type    = var.instance_type
#   key_pair_name    = var.key_pair_name
#   name_prefix      = var.name_prefix
# }

module "eks" {
  source = "./modules/eks"

  name_prefix      = var.name_prefix
  full_cluster_name = "${var.name_prefix}-${var.cluster_name}"
  cluster_version  = var.cluster_version

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnets
  
  map_user_userarn  = var.map_user_userarn
  map_user_username = var.map_user_username
  map_user_groups   = var.map_user_groups

  desired_size      = var.desired_size
  max_size          = var.max_size
  min_size          = var.min_size
  eks_instance_type = var.eks_instance_type
  node_name         = var.node_name

  bastion_sg_eks_rule_port = var.bastion_sg_eks_rule_port
  bastion_sg_id = module.bastion.bastion_sg_id
}


terraform {
 backend "s3" {
   bucket         = "919649607464-tfstate-bucket"      # Replace with your S3 bucket name
   key            = "infra/infra.tfstate"       # Path within the bucket
   region         = "eu-west-1"                         # Your AWS region
   encrypt        = true                                # (Optional) Encrypt state file at rest
   profile        = "default"                            # (Optional) AWS CLI profile to use
   #use_lockfile   = true
 }
}