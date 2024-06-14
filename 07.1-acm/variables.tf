variable "project_name" {
    default = "expense"
  
}
variable "environment" {
    default = "dev"
  
}
variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
    Component = "app-alb"
  }
}

variable "zone_name" {
    default = "venkatdevops1608.online"
    
  
}

variable "zone_id" {
    default = "Z09487151G38CXJ8Z9XED"
  
}