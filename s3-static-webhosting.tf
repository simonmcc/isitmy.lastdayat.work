variable "bucket_name" { default = "isitmy.lastdayat.work" }

resource "aws_s3_bucket" "isitmy" {
    bucket = "${var.bucket_name}"
    acl = "public-read"
    policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadForGetBucketObjects",
      "Effect":"Allow",
      "Principal": "*",
      "Action":"s3:GetObject",
      "Resource":"arn:aws:s3:::${var.bucket_name}/*"
  }]
}
POLICY

    website {
        index_document = "index.html"
        error_document = "error.html"
        routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
    }
}


resource "aws_s3_bucket_object" "index_html" {
    bucket = "${var.bucket_name}"
    key = "index.html"
    source = "files/index.html"
    content_type = "text/html"
    etag = "${md5(file("files/index.html"))}"
}

resource "aws_s3_bucket_object" "index_css" {
    bucket = "${var.bucket_name}"
    key = "index.css"
    source = "files/index.css"
    content_type = "text/css"
    etag = "${md5(file("files/index.css"))}"
}

resource "aws_s3_bucket_object" "index_js" {
    bucket = "${var.bucket_name}"
    key = "index.js"
    source = "files/index.js"
    content_type = "text/javascript"
    etag = "${md5(file("files/index.js"))}"
}

resource "dnsimple_record" "isitmy" {
# isitmy.lastdayat.work.s3-website-eu-west-1.amazonaws.com
  domain = "lastdayat.work"
  name = "isitmy"
  value = "${aws_s3_bucket.isitmy.website_endpoint}"
  type = "CNAME"
  ttl = 300
}
