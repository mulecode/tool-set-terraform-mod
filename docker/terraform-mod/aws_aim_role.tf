module "aws_aim_role" {
  source                       = "./modules/iam-role"
  for_each                     = var.aws_iam_roles
  account_id                   = var.account_id
  prefix                       = var.project_prefix
  name                         = each.key
  description                  = each.value.description
  assume_role_policy           = file(each.value.assume_role_policy)
  aim_attachment_role_policies = each.value.aim_attachment_role_policies

  depends_on = [
    module.aws_aim_policy
  ]
}
