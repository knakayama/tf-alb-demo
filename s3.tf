data "aws_elb_service_account" "alb_log" {}

data "aws_iam_policy_document" "alb_log" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.name}-alb-log/*",
    ]

    principals = {
      type = "AWS"

      identifiers = [
        "${data.aws_elb_service_account.alb_log.id}",
      ]
    }
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket        = "${var.name}-alb-log"
  acl           = "private"
  policy        = "${data.aws_iam_policy_document.alb_log.json}"
  force_destroy = true
}
