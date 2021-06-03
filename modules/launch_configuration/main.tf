locals {
  user_data = <<-EOF
              #!/bin/bash
              host=$(hostname)
              yum update -y
              yum install httpd -y
              systemctl start httpd
              echo Syed Iqbal Web Server - $host > /var/www/html/index.html
              EOF
}

resource "aws_launch_configuration" "rs-launch-configuration" {
  name_prefix = var.name_prefix

  image_id      = var.image_id
  instance_type = var.instance_type

  security_groups             = [var.security_group_id]
  associate_public_ip_address = true

  user_data = base64encode(local.user_data)

  lifecycle {
    create_before_destroy = true
  }
}
