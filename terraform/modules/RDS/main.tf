resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for RDS instance"
  vpc_id      = "vpc-0af49312582e83e49"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "db_instance" {
  allocated_storage      = 10
  db_name                = "click2cartDB"
  engine                 = "postgres"
  engine_version         = "17.4"
  instance_class         = "db.t3.micro"
  username               = "click2cart"
  password               = var.db_password
  parameter_group_name   = "default.postgres17"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
}