# main.tf

# -----------------
# Recursos de Red
# -----------------
resource "aws_vpc" "mi_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "mi-vpc-terraform"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.mi_vpc.id
  cidr_block = var.subnet_a_cidr_block
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.mi_vpc.id
  cidr_block = var.subnet_b_cidr_block
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "subnet-b"
  }
}

# -----------------
# Grupos de Seguridad
# -----------------
resource "aws_security_group" "sg_instancias" {
  vpc_id      = aws_vpc.mi_vpc.id
  name        = "sg_instancias"
  description = "Permite trafico desde el ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_alb" {
  vpc_id      = aws_vpc.mi_vpc.id
  name        = "sg_alb"
  description = "Permite tráfico HTTP desde internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------
# Instancias EC2
# -----------------
resource "aws_instance" "mi_instancia_a" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.sg_instancias.id]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hola desde la instancia A</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "instancia-a"
  }
}

resource "aws_instance" "mi_instancia_b" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.sg_instancias.id]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hola desde la instancia B</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "instancia-b"
  }
}

# -----------------
# Balanceador de Carga (ALB)
# -----------------
resource "aws_lb" "mi_alb" {
  name               = "mi-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  tags = {
    Name = "mi-alb"
  }
}

resource "aws_lb_target_group" "mi_tg" {
  name     = "mi-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mi_vpc.id
  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "instancia_a_att" {
  target_group_arn = aws_lb_target_group.mi_tg.arn
  target_id        = aws_instance.mi_instancia_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instancia_b_att" {
  target_group_arn = aws_lb_target_group.mi_tg.arn
  target_id        = aws_instance.mi_instancia_b.id
  port             = 80
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.mi_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mi_tg.arn
  }
}