resource "aws_s3_bucket" "private_bucket" {
  bucket = "${var.website_name}"
  acl    = "private"

  tags {
    Name        = "website"
    Environment = "data"
    Acl			    = "private"
  }

}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "www.${var.website_name}"
  acl    = "public-read"
  policy = <<POLICY
  {
  	"Version":"2012-10-17",
  	"Statement":[{
  		"Sid":"PublicReadGetObject",
  		"Effect":"Allow",
  		"Principal": "*",
  		"Action":["s3:GetObject"],
  		"Resource":["arn:aws:s3:::${var.website_name}/*"]
  	}]
  }
POLICY
}

  website {
    error_document = "error.html"
  }

  redirect_all_requests_to = "${var.website_name}"

  tags {
    Name        = "website"
    Environment = "data"
    Acl			    = "public"
  }

}

resource "aws_route53_record" "www" {
  zone_id = "${var.aws_route53_zone_id}"
  name    = ""
  type    = "A"
  ttl     = "300"
  alias {
    name    = "${aws_s3_bucket.public_bucket.website_domain}"
    zone_id = "${aws_s3_bucket.public_bucket.hosted_zone_id}"
  }
}
