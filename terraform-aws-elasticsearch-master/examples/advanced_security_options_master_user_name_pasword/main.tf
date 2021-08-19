module "aws_es" {

  source = "lgallard/elasticsearch/aws"

  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version

  cluster_config = {
    dedicated_master_enabled = "true"
    instance_count           = "3"
    instance_type            = "r5.large.elasticsearch"
    zone_awareness_enabled   = "true"
    availability_zone_count  = "3"
  }

  advanced_security_options = {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options = {
      master_user_name     = "username"
      master_user_password = "T0p$ecret"
    }
  }

  domain_endpoint_options = {
    enforce_https = true
  }

  ebs_options = {
    ebs_enabled = "true"
    volume_size = "25"
  }

  encrypt_at_rest = {
    enabled    = "true"
    kms_key_id = "arn:aws:kms:us-east-1:123456789101:key/cccc103b-4ba3-5993-6fc7-b7e538b25fd8"
  }


  log_publishing_options = {
    enabled = "true"
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = templatefile("${path.module}/whitelits.tpl", {
    region      = data.aws_region.current.name,
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.es_domain_name,
    whitelist   = "${jsonencode(var.whitelist)}"
  })

  node_to_node_encryption_enabled                = "true"
  snapshot_options_automated_snapshot_start_hour = "23"

  #timeouts_update = "90m"

  tags = {
    Owner = "sysops"
    env   = "dev"
  }
}
