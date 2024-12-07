variable "location" {
  type    = string
  default = "{{config.get_value('azure', 'az_location', 'westeurope')}}"
}

# default size : 2cpu / 4GB
variable "size" {
  type    = string
  default = "Standard_B2s"
}

variable "username" {
  type    = string
  default = "goadmin"
}

variable "password" {
  description = "Password of the windows virtual machine admin user"
  type    = string
  default = "goadmin"
}

variable "jumpbox_username" {
  type    = string
  default = "goad"
}

variable "bastion_host_name" {
  description = "Name of the Azure Bastion Host"
  default     = "goad-bastion"
}

variable "bastion_subnet_name" {
  description = "Name of the subnet for the Bastion Host"
  default     = "AzureBastionSubnet"
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for the Bastion subnet"
  default     = "192.168.56.224/28"  # Make sure this does not overlap with other subnets in the VNet
}
