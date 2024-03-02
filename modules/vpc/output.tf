output "region" {
 value = var.region  
 }

 output "project_name" {
 value = var.project_name  
 }

 output "vpc_id" {
 value = aws_vpc.great_vpc.id  
 }

 output "great_pub_sub_1_id" {
 value = aws_subnet.great_pub_sub_1.id  
 }

 output "great_pub_sub_2_id" {
 value = aws_subnet.great_pub_sub_2.id 
 }

 output "great_priv_sub_1_id" {
 value = aws_subnet.great_priv_sub_1.id 
 }

output "internet_gateway" {
 value = aws_internet_gateway.great_igw
}

output "alb_hostname" {
  value = aws_alb.great_alb.dns_name
}