resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

#["venkat_id1", "venkat_id2"] this is terraform format (list lo terraform format) 
# venkat_id1 , venkat_id2    this is SSM aws parameter format (in list) 

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join("," ,(module.vpc.public_subnet_ids))   # vpc nunchi public subnets id tiskuntunam
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"                         # morethan one is calling StringList in parameter
  value = join("," ,(module.vpc.private_subnet_ids))  #converting list to Stringlist     #join function terraform 
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc.database_subnet_group_name
}