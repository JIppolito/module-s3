output public_s3_arn { 
  value = "${aws_s3_bucket.private_bucket.arn}"
}

output private_s3_arn { 
  value = "${aws_s3_bucket.public_bucket.arn}"
}

output r53_record {
  value = "${aws_route53_record.www.}"
}