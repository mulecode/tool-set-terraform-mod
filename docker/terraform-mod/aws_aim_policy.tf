module "aws_aim_policy" {
  for_each    = var.aws_iam_policies
  source      = "./modules/iam-policy"
  prefix      = var.project_prefix
  name        = each.key
  description = each.value.description
  policy      = templatefile(each.value.policy, each.value.policy_vars)
}
