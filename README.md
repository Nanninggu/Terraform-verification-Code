# Terraform 프로젝트

이 프로젝트는 Terraform을 사용하여 AWS 인프라를 관리합니다. 여기에는 S3 버킷, RDS 인스턴스, 애플리케이션 로드 밸런서(ALB) 및 오토 스케일링이 포함됩니다.

## 모듈

### S3
S3 버킷을 관리합니다.

#### 입력 값
- `bucket_name`: S3 버킷의 이름.
- `acl`: 버킷의 접근 제어 목록(기본값: `private`).

#### 출력 값
- `bucket_arn`: S3 버킷의 ARN.
- `bucket_name`: S3 버킷의 이름.

### RDS
RDS 인스턴스를 관리합니다.

#### 입력 값
- `db_name`: 데이터베이스 이름.
- `username`: 데이터베이스 사용자 이름.
- `password`: 데이터베이스 비밀번호.
- `vpc_security_group_ids`: VPC 보안 그룹 ID 목록.
- `subnet_ids`: 서브넷 ID 목록.

### ALB
애플리케이션 로드 밸런서를 관리합니다.

#### 입력 값
- `vpc_id`: VPC의 ID.
- `subnet_ids`: 퍼블릭 서브넷 ID 목록.
- `security_group_ids`: 보안 그룹 ID 목록.
- `target_instance_ids`: 대상 인스턴스 ID 목록.

## 사용법

```terraform
module "s3" {
  source      = "./modules/s3"
  bucket_name = "my-unique-bucket-name-sionkim"
  acl         = "private"
}

module "rds" {
  source     = "./modules/rds"
  db_name    = "mydatabase"
  username   = "postgres"
  password   = "test1234"
  vpc_security_group_ids = [module.security-group.security_group_id]
  subnet_ids = module.subnet.private_subnet_ids
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnet.public_subnet_ids
  security_group_ids = [module.security-group.security_group_id]
  target_instance_ids = [
    module.ec2.web1_id,
    module.ec2.web2_id
  ]
}