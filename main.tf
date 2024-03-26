# Creation du VPC Vnet et Subnets
module "network" {
  source                    = "git@github.com:realtik/Terraform-modules.git//network"
  vpc_configuration         = var.vpc_configuration
  subnet1_config            = var.subnet1_config
  subnet2_config            = var.subnet2_config
  public_route_table_config = var.public_route_table_config
  pvt_subnet1_config        = var.pvt_subnet1_config
  pvt_subnet2_config        = var.pvt_subnet2_config
  pvt_subnet3_config        = var.pvt_subnet3_config
  pvt_subnet4_config        = var.pvt_subnet4_config
}

# Creation de la NAT Gateway
module "nat-gateway" {
  depends_on                  = [module.network]
  source                      = "git@github.com:realtik/Terraform-modules.git//nat-gateway"
  vpc_id                      = module.network.vpc_id
  internet_gateway            = module.network.internet-gateway_id
  public-subnet-1_id          = module.network.public-subnet-1_id
  public-subnet-2_id          = module.network.public-subnet-2_id
  private-subnet-1_id         = module.network.private-subnet-1_id
  private-subnet-2_id         = module.network.private-subnet-2_id
  private-subnet-3_id         = module.network.private-subnet-3_id
  private-subnet-4_id         = module.network.private-subnet-4_id
  eip_natgateway1_config      = var.eip_natgateway1_config
  eip_natgateway2_config      = var.eip_natgateway2_config
  private_route_table1_config = var.private_route_table1_config
  private_route_table2_config = var.private_route_table2_config
}

# Creation des groupes de sécurité
module "security-groups" {
  source                          = "git@github.com:realtik/Terraform-modules.git//security-groups"
  vpc_id                          = module.network.vpc_id
  alb-security-group_config       = var.alb-security-group_config
  bastion-security-group_config   = var.bastion-security-group_config
  webserver-security-group_config = var.webserver-security-group_config
  database-security-group_config  = var.database-security-group_config
}

# Creation de la Realtional Database Service
module "rds" {
  source                     = "git@github.com:realtik/Terraform-modules.git//rds"
  rds_instance_config        = var.rds_instance_config
  snapshot_config            = var.snapshot_config
  database_security_group_id = module.security-groups.database_security_group_id
  private-subnet-3_id        = module.network.private-subnet-3_id
  private-subnet-4_id        = module.network.private-subnet-4_id
}

# Obtention Certificat SSL
module "ssl_certificate" {
  source                 = "git@github.com:realtik/Terraform-modules.git//acm"
  acm_certificate_config = var.acm_certificate_config
  route53_zone_config    = var.route53_zone_config
}

# Creation de l'application load balancer
module "application_load_balancer" {
  source                    = "git@github.com:realtik/Terraform-modules.git//alb"
  alb_config                = var.alb_config
  alb_target_group_config   = var.alb_target_group_config
  alb_http_listener_config  = var.alb_http_listener_config
  alb_https_listener_config = var.alb_https_listener_config
  alb_security_group_id     = module.security-groups.alb_security_group_id
  public-subnet-1_id        = module.network.public-subnet-1_id
  public-subnet-2_id        = module.network.public-subnet-2_id
  vpc_id                    = module.network.vpc_id
  certificate_arn           = module.ssl_certificate.certificate_arn
}

# Creation du S3 bucket
module "s3_bucket" {
  source                 = "git@github.com:realtik/Terraform-modules.git//s3"
  env_file_bucket_config = var.env_file_bucket_config
  env_file_name          = var.env_file_name
}

# Creation de ECS Task execution Role 
module "ecs_task_execution_role" {
  source                         = "git@github.com:realtik/Terraform-modules.git//iam-role"
  ecs_task_execution_role_config = var.ecs_task_execution_role_config
  env_file_bucket_name           = module.s3_bucket.env_file_bucket_name
}

# Creation de ECS service
module "ecs" {
  source                             = "git@github.com:realtik/Terraform-modules.git//ecs"
  ecs_cluster_config                 = var.ecs_cluster_config
  log_group_name                     = var.log_group_name
  ecs_task_definition_config         = var.ecs_task_definition_config
  ecs_service_config                 = var.ecs_service_config
  ecs_task_execution_role_arn        = module.ecs_task_execution_role.ecs_task_execution_role_arn
  env_file_bucket_name               = module.s3_bucket.env_file_bucket_name
  env_file_name                      = module.s3_bucket.env_file_name
  private-subnet-1_id                = module.network.private-subnet-1_id
  private-subnet-2_id                = module.network.private-subnet-2_id
  webserver_server_security_group_id = module.security-groups.webserver_server_security_group_id
  alb_target_group_arn               = module.application_load_balancer.alb_target_group_arn
}

# Creation du module pour l'Auto Scaling Group
module "ecs_asg" {
  source            = "git@github.com:realtik/Terraform-modules.git//asg-ecs"
  ecs_asg_config    = var.ecs_asg_config
  ecs_policy_config = var.ecs_policy_config
  ecs_cluster_name  = module.ecs.ecs_cluster_name
  ecs_service_name  = module.ecs.ecs_service_name
  ecs_service       = module.ecs.ecs_service
}

# Creation du module Route 53 pour créer le Record Set
module "route53" {
  source                             = "git@github.com:realtik/Terraform-modules.git//route53"
  site_domain_config                 = var.site_domain_config
  domain_name                        = module.ssl_certificate.domain_name
  application_load_balancer_dns_name = module.application_load_balancer.application_load_balancer_dns_name
  application_load_balancer_zone_id  = module.application_load_balancer.application_load_balancer_zone_id
}

# Print the website url
output "website_url" {
  value = join("", ["https://", var.site_domain_config.name, ".", module.ssl_certificate.domain_name])
}