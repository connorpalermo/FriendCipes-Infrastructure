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
}

resource "aws_db_parameter_group" "friendcipes-parameter-group" {
  name   = "friendcipes-parameter-group"
  family = "postgres14"
}

resource "aws_security_group" "db_security_group" {
  name        = "db_security_group"
  description = "Allows Ingress traffic to DB"
  ingress {
    from_port = 5432
    protocol  = "tlc"
    to_port   = 5432
  }

  tags = {
    Name = "db_security_group"
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "app_security_group"
  description = "Allows Egress traffic to DB"
  egress {
    from_port = 5432
    protocol  = "tlc"
    to_port   = 5432
  }

  tags = {
    Name = "app_security_group"
  }
}