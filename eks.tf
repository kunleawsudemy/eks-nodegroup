##Reference: https://antonputra.com/amazon/create-eks-cluster-using-terraform-modules/#create-eks-using-terraform
##           https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
##           Provisioning Takes approximately approximately 11mins

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = "${var.cluster-name}"
  cluster_version = "1.28"

  #cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true


##=========================================
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
##=========================================

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  #subnet_ids = module.vpc.private_subnets

##======================================================
  control_plane_subnet_ids = module.vpc.private_subnets
##======================================================

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 30
  }


###############################################################
  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 0
      max_size     = 4

      labels = {
        role = "node1"
      }

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      #ami_release_version = "1.27.7-20231116"
      ami_release_version = "1.28.3-20231116"
}



  # ## Fargate Profile(s)
  # fargate_profiles = {
  #   default = {
  #     name = "default"
  #     selectors = [
  #       {
  #         namespace = "default"
  #       }
  #     ]
  #   }
  # }


#   # aws-auth configmap
#   manage_aws_auth_configmap = true

#   aws_auth_roles = [
#     {
#       rolearn  = "arn:aws:iam::66666666666:role/role1"
#       username = "role1"
#       groups   = ["system:masters"]
#     },
#   ]

#   aws_auth_users = [
#     {
#       userarn  = "arn:aws:iam::66666666666:user/user1"
#       username = "user1"
#       groups   = ["system:masters"]
#     },
#     {
#       userarn  = "arn:aws:iam::66666666666:user/user2"
#       username = "user2"
#       groups   = ["system:masters"]
#     },
#   ]

#   aws_auth_accounts = [
#     "777777777777",
#     "888888888888",
#   ]
###############################################################


    # spot = {
    #   desired_size = 1
    #   min_size     = 1
    #   max_size     = 4

    #   labels = {
    #     role = "spot"
    #   }

    #   taints = [{
    #     key    = "market"
    #     value  = "spot"
    #     effect = "NO_SCHEDULE"
    #   }]

    #   instance_types = ["t3.micro"]
    #   capacity_type  = "SPOT"
    # }
  }

  tags = {
    Environment = "staging"
  }
}


