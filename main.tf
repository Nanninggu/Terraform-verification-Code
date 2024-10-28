terraform {
  # Terraform 설정 블록 시작
  backend "local" {
    # 로컬 백엔드를 사용하여 상태 파일을 저장
    path = "C:\\Users\\김승현\\Documents\\oCam\\인프런 강의\\아키텍처와 함께하는 Terraform 기초편!\\code-module1\\terraform.tfstate"
    # 상태 파일을 저장할 경로
  }
}

# aws provider 생성
provider "aws" {
  region = "ap-northeast-2" # AWS 리전 설정
}

# vpc 모듈 생성
module "vpc" {
  source = "./modules/vpc" # VPC 모듈 소스 경로
  nat_interface_network_interface_id = module.ec2.nat_interface_network_interface_id # EC2 모듈에서 NAT 인터페이스 ID 가져오기
}

module "subnet" {
  source = "./modules/subnet" # 서브넷 모듈 소스 경로
  vpc_id = module.vpc.vpc_id # VPC 모듈에서 VPC ID 가져오기
  route_table_id = module.vpc.route_table_id # VPC 모듈에서 라우트 테이블 ID 가져오기
  route_table_id1 = module.vpc.route_table_id1 # VPC 모듈에서 NAT 인스턴스 라우트 테이블 ID 가져오기 (추가)
}

module "security-group" {
  source = "./modules/security-group" # 보안 그룹 모듈 소스 경로
  vpc_id = module.vpc.vpc_id # VPC 모듈에서 VPC ID 가져오기
}

module "key_pair" {
  source = "./modules/key-pair" # 키 페어 모듈 소스 경로
}

module "ec2" {
  source = "./modules/ec2" # EC2 모듈 소스 경로
  security_group_id = module.security-group.security_group_id # 보안 그룹 모듈에서 보안 그룹 ID 가져오기
  public_subnet_ids = module.subnet.public_subnet_ids # 서브넷 모듈에서 퍼블릭 서브넷 ID 가져오기
  private_subnet_ids = module.subnet.private_subnet_ids # 서브넷 모듈에서 프라이빗 서브넷 ID 가져오기
  key_name = module.key_pair.key_name # 키 페어 이름 설정
}

module "s3" {
  # S3 모듈을 정의합니다.
  source = "./modules/s3"  # 모듈 소스 경로를 설정합니다.
  bucket_name = "my-unique-bucket-name-sionkim"  # S3 버킷 이름을 설정합니다.
  acl = "private"  # S3 버킷의 접근 제어 목록(ACL)을 private으로 설정합니다.
}

module "rds" {
  # RDS 모듈을 정의합니다.
  source = "./modules/rds"  # 모듈 소스 경로를 설정합니다.
  db_name = "mydatabase"  # 데이터베이스 이름을 설정합니다.
  username = "postgres"  # 데이터베이스 사용자 이름을 설정합니다.
  password = "test1234"  # 데이터베이스 비밀번호를 설정합니다.
  vpc_security_group_ids = [module.security-group.security_group_id]  # VPC 보안 그룹 ID를 설정합니다.
  subnet_ids = module.subnet.private_subnet_ids  # 서브넷 ID를 설정합니다.
}

module "alb" {
  # ALB 모듈을 정의합니다.
  source = "./modules/alb"  # 모듈 소스 경로를 설정합니다.
  vpc_id = module.vpc.vpc_id  # VPC ID를 설정합니다.
  subnet_ids = module.subnet.public_subnet_ids  # 서브넷 ID를 설정합니다.
  security_group_ids = [module.security-group.security_group_id]  # 보안 그룹 ID를 설정합니다.
  target_instance_ids = [
    # 대상 인스턴스 ID를 설정합니다.
    module.ec2.web1_id, # 첫 번째 웹 인스턴스 ID를 설정합니다.
    module.ec2.web2_id  # 두 번째 웹 인스턴스 ID를 설정합니다.
  ]
}