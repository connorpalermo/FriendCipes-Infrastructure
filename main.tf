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
}

resource "aws_db_parameter_group" "friendcipes-parameter-group" {
  name   = "friendcipes-parameter-group"
  family = "postgres14"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}