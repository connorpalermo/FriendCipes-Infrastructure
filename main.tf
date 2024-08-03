resource "aws_db_instance" "friendcipesdb" {
  allocated_storage    = 10
  max_allocated_storage = 50
  db_name              = "friendcipesdb"
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.db_pw
  parameter_group_name = aws_db_parameter_group.friendcipes-parameter-group.name
  skip_final_snapshot  = true
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
}

resource "aws_db_parameter_group" "friendcipes-parameter-group" {
  name   = "friendcipes-parameter-group"
  family = "postgres14"
}

resource "aws_security_group" "db_security_group" {
  name        = "db_security_group"
  description = "Allows Ingress traffic to DB"

  tags = {
    Name = "db_security_group"
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "app_security_group"
  description = "Allows Egress traffic to DB"

  tags = {
    Name = "app_security_group"
  }
}

resource "aws_security_group_rule" "ingress_on_db" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.db_security_group
  source_security_group_id = aws_security_group.app_security_group.id
}

resource "aws_security_group_rule" "egress_from_app" {
  type              = "egress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.app_security_group
  source_security_group_id = aws_security_group.db_security_group.id
}