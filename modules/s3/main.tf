resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name # 버킷 이름을 변수로 설정
}