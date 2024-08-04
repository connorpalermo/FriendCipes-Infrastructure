variable "db_user" {
  type = string
}
variable "db_pw" {
  type = string
}

variable "db_engine" {
  type = string
  description = "Database Engine for RDS Instance"
  default = "postgres"
}

variable "db_engine_version" {
  type = string
  description = "Engine Version for RDS Instance"
  default = "14"
}

variable "lambda_version" {
  type = string
  description = "Lambda Version"
  default = "1.0.0"
}



