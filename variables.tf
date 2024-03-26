############################## NETWORK MODULE VARIABLES ##############################


variable "vpc_configuration" {
  type = object({
    cidr_block           = string
    instance_tenancy     = string
    enable_dns_hostnames = string
  })
}
#### Public Subnet #######

variable "subnet1_config" {
  type = object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = string
  })
}

variable "subnet2_config" {
  type = object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = string
  })
}

####### Public Route Table ##################

variable "public_route_table_config" {
  type = object({
    cidr_block = string
  })
}

############ Private Subnet ##############################

variable "pvt_subnet1_config" {
  type = object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = string
  })
}

variable "pvt_subnet2_config" {
  type = object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = string
  })
}


variable "pvt_subnet3_config" {
  type = object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = string
  })
}

variable "pvt_subnet4_config" {
  type = object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = string
  })
}

############################## NAT GATEWAY MODULE VARIABLES ##############################

variable "eip_natgateway1_config" {
  type = object({
    domain = string
  })
}

variable "eip_natgateway2_config" {
  type = object({
    domain = string
  })
}


################ PRIVATE ROUTE TABLE 1 ################


variable "private_route_table1_config" {
  type = object({
    cidr_block = string
  })
}

################ PRIVATE ROUTE TABLE 2 ################


variable "private_route_table2_config" {
  type = object({
    cidr_block = string
  })
}

############################## SECURITY GROUP MODULE VARIABLES ##############################

variable "alb-security-group_config" {
  type = object({
    name        = string
    description = string

    ingress_description = string
    ingress_from_port   = string
    ingress_to_port     = string
    ingress_protocol    = string
    ingress_cidr_blocks = list(string)

    ingress2_description = string
    ingress2_from_port   = string
    ingress2_to_port     = string
    ingress2_protocol    = string
    ingress2_cidr_blocks = list(string)


    egress_from_port   = string
    egress_to_port     = string
    egress_protocol    = string
    egress_cidr_blocks = list(string)


  })
}


variable "bastion-security-group_config" {
  type = object({
    name        = string
    description = string

    ingress_description = string
    ingress_from_port   = string
    ingress_to_port     = string
    ingress_protocol    = string
    ingress_cidr_blocks = list(string)

    egress_from_port   = string
    egress_to_port     = string
    egress_protocol    = string
    egress_cidr_blocks = list(string)


  })
}


variable "webserver-security-group_config" {
  type = object({
    name        = string
    description = string

    ingress_description = string
    ingress_from_port   = string
    ingress_to_port     = string
    ingress_protocol    = string


    ingress2_description = string
    ingress2_from_port   = string
    ingress2_to_port     = string
    ingress2_protocol    = string

    egress_from_port   = string
    egress_to_port     = string
    egress_protocol    = string
    egress_cidr_blocks = list(string)


  })
}

variable "database-security-group_config" {
  type = object({
    name        = string
    description = string

    ingress_description = string
    ingress_from_port   = string
    ingress_to_port     = string
    ingress_protocol    = string

    ingress2_description = string
    ingress2_from_port   = string
    ingress2_to_port     = string
    ingress2_protocol    = string

    egress_from_port   = string
    egress_to_port     = string
    egress_protocol    = string
    egress_cidr_blocks = list(string)


  })
}


############################## RDS MODULE VARIABLES ##############################
/*
variable "rds_instance_config" {
  type = object({
    engine                    = string
    availability_zone         = string
    engine_version            = string
    skip_final_snapshot       = string
    final_snapshot_identifier = string
    instance_class            = string
    allocated_storage         = number
    identifier                = string
    db_name                   = string
    username                  = string
    password                  = string
    multi_az                  = string
  })
}
*/

variable "snapshot_config" {
  type = object({
    db_snapshot_identifier = string
    snapshot_type          = string
  })
}

variable "rds_instance_config" {
  type = object({
    instance_class    = string
    availability_zone = string
    identifier        = string
    multi_az          = string
  })
}


############################## ACM MODULE VARIABLES ##############################


variable "acm_certificate_config" {
  type = object({
    domain_name               = string
    subject_alternative_names = string
    validation_method         = string
  })
}

variable "route53_zone_config" {
  type = object({
    private_zone = string
  })
}

############################## ALB MODULE VARIABLES ##############################


variable "alb_config" {
  type = object({
    name                       = string
    internal                   = string
    load_balancer_type         = string
    enable_deletion_protection = string
  })
}

variable "alb_target_group_config" {
  type = object({
    name                = string
    target_type         = string
    port                = number
    protocol            = string
    healthy_threshold   = number
    interval            = number
    matcher             = string
    path                = string
    ht_port             = string
    ht_protocol         = string
    timeout             = number
    unhealthy_threshold = number
  })
}


variable "alb_http_listener_config" {
  type = object({
    port              = number
    protocol          = string
    type              = string
    redirect_port     = number
    redirect_protocol = string
    status_code       = string
  })
}

variable "alb_https_listener_config" {
  type = object({
    port       = number
    protocol   = string
    ssl_policy = string
    type       = string
  })
}

############################## S3 MODULE VARIABLES ##############################

variable "env_file_bucket_config" {
  type = object({
    name = string
  })
}

variable "env_file_name" {
  type = string
}

############################## IAM Role MODULE VARIABLES ##############################

variable "ecs_task_execution_role_config" {
  type = object({
    name = string
  })
}

############################## ECS MODULE VARIABLES ##############################

variable "ecs_cluster_config" {
  type = object({
    name          = string
    setting_name  = string
    setting_value = string

  })
}

variable "log_group_name" {
  type = string
}

variable "ecs_task_definition_config" {
  type = object({
    family                     = string
    network_mode               = string
    requires_compatibilities   = list(string)
    cpu                        = string
    memory                     = string
    operating_system_family    = string
    cpu_architecture           = string
    container_definitions_name = string
    image                      = string
    essential                  = bool
    containerPort              = number
    hostPort                   = number
    awslogs-region             = string
    awslogs-stream-prefix      = string
  })
}

variable "ecs_service_config" {
  type = object({
    name                               = string
    launch_type                        = string
    platform_version                   = string
    desired_count                      = string
    deployment_minimum_healthy_percent = string
    deployment_maximum_percent         = string
    enable_ecs_managed_tags            = string
    propagate_tags                     = string
    assign_public_ip                   = string
    container_port                     = string
  })
}

############################## ASG-ECS MODULE VARIABLES ##############################

variable "ecs_asg_config" {
  type = object({
    max_capacity = number
    min_capacity = number
  })
}

variable "ecs_policy_config" {
  type = object({
    name               = string
    policy_type        = string
    target_value       = number
    scale_out_cooldown = number
    scale_in_cooldown  = number
    disable_scale_in   = string
  })
}

############################## ROUTE 53 MODULE VARIABLES ##############################

variable "site_domain_config" {
  type = object({
    name                   = string
    sd_type                = string
    evaluate_target_health = string
  })
}
