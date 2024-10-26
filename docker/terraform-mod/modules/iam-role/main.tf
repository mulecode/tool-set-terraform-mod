locals {
  tags = merge(var.tags, {
    CreatedBy  = "terraform"
    ModuleName = "aim-role-policy"
  })
}

resource "aws_iam_role" "main" {
  name               = "${upper(var.prefix)}${var.name}"
  description        = var.description
  assume_role_policy = var.assume_role_policy
  tags               = local.tags
}

resource "aws_iam_role_policy" "main" {
  for_each = var.aim_role_policies
  name     = "${upper(var.prefix)}${var.name}${each.key}"
  role     = aws_iam_role.main.name
  policy   = each.value.policy
}

resource "aws_iam_role_policy_attachment" "main" {
  for_each   = { for policy_arn in var.aim_attachment_role_policies : policy_arn => policy_arn }
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::${var.account_id}:policy/${upper(var.prefix)}${each.value}"
}
