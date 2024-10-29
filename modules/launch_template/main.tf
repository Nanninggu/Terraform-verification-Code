resource "aws_ami_from_instance" "web1_ami" {
  name               = "web1-ami"
  source_instance_id = var.source_instance_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "web1_launch_template" {
  name          = "web1-launch-template"
  image_id      = aws_ami_from_instance.web1_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name  # 키 페어 이름 추가

  user_data = base64encode(<<-EOF
              #!/bin/bash

              # Java 설치
              sudo apt update
              sudo apt install -y openjdk-17-jdk

              # Java 설치 확인
              java -version

              # 기존 디렉토리 삭제
              rm -rf my-app-terraform

              # Git 저장소 클론
              git clone https://github.com/Nanninggu/my-app-terraform.git
              cd my-app-terraform

              # Gradle wrapper에 실행 권한 부여
              chmod +x gradlew

              # Gradle 빌드
              ./gradlew build

              # 빌드된 JAR 파일 실행
              java -jar build/libs/demo-0.0.1-SNAPSHOT.jar && echo "JAR file executed successfully"

              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}