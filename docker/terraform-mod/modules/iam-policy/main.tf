locals {
  tags = merge(var.tags, {
    CreatedBy  = "terraform"
    ModuleName = "aim-policy"
  })
}

resource "aws_iam_policy" "main" {
  name        = "${upper(var.prefix)}${var.name}"
  description = var.description
  policy      = var.policy
}
