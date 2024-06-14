variable "project_name" {
    default = "expense"
  
}
variable "environment" {
    default = "dev"
  
}
variable "common_tags" {
    default = {
        project = "expense"
        environment = "dev"
        terraform = "true"
        Component = "frontend"
    }
}

variable "zone_name" {
    default = "venkatdevops1608.online"
  
}