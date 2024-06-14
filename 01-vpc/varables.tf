variable "project_name" {
    default = "expense"
  
}
variable "environment" {
    default = "dev"
  
}
variable "sg_group" {
    default = "db"
  
}

variable "common_tags" {
    default = {
        project = "expense"
        environment = "dev"
        terraform = "true"
    }
  
}

variable "public_subnet_cidrs" {
    default = ["10.0.1.0/24","10.0.2.0/24" ]
  
}

variable "private_subnet_cidrs" {
    default = ["10.0.15.0/24","10.0.17.0/24"]
  
}

variable "database_subnet_cidrs" {
    default = ["10.0.101.0/24","10.0.102.0/24"]
  
}

# peering connection ##
# variable "is_peering_required" {
#     type = bool
#     default = false
  
# }

# variable "acceptor_vpc_id" {
#     type = string
#     default = ""     # ""  this means default value 
  
# }

# variable "vpc_peering_tags" {
#     default = {}
  
# }