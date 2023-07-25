variable "exposed_port" {
  description = "The port number to expose on the load balancer"
  type        = number
  default     = 8080
}

variable "load_balancer_name" {
  description = "The name of the load balancer to create"
  type        = string
}

variable "instance_group" {
  description = "The name of the instance group to associate with the load balancer"
  type        = string
}

variable "port_range" {
  description = "The range of ports to use for the load balancer"
  type        = string
  default     = "8080-8080"
}

variable "ip_name" {
  description = "The name of the IP address to assign to the load balancer"
  type        = string
}

variable "domain" {
  type = string
}

variable "max_connections_per_instance" {
  type    = number
  default = 25
}
