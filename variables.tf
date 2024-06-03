variable "agent_count" {
  type    = number
  default = 3
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "k8sguru"
}

variable "cluster_name" {
  default = "k8sguru"
}
variable "location" {
  default = "eastus"
}
variable "loganalytics_workspace_name" {
  default = "guruLogAnalyticsWorkspaceName"
}

variable "loganalytics_workspace_location" {
  default = "eastus"
}

variable "loganalytics_workspace_sku" {
  default = "PerGB2018"
}


variable "aks_service_principal_app_id" {
  default = "service principal app id"
}



variable "aks_service_principal_client_secret" {
  default = "Service principal client secret"
}
