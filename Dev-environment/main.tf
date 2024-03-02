module "vpc" {

source = "../modules/vpc"

# definig components
region                  = var.region
project_name            = var.project_name
vpc_cidr                = var.vpc_cidr
great_pub_sub_1_cidr    = var.great_pub_sub_1_cidr
great_pub_sub_2_cidr    = var.great_pub_sub_2_cidr
great_priv_sub_1_cidr   = var.great_priv_sub_1_cidr
great_priv_sub_2_cidr   = var.great_priv_sub_2_cidr
engine                  = var.engine
instance_class          = var.instance_class
storage_type            = var.storage_type

}