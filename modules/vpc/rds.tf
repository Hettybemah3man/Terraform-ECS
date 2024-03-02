resource "aws_db_instance" "great_ecs_database" {
identifier= "my-db-instance"
allocated_storage= 20
storage_type= var.storage_type
engine= var.engine
engine_version= "5.7"
instance_class= var.instance_class
username= "admin"
password= "adminadmin"
parameter_group_name= "default.mysql5.7"
publicly_accessible= true
multi_az= false
backup_retention_period = 7
skip_final_snapshot= true

tags = {
Name = "MyDatabase"
}
}