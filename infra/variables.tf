variable "project" {
  default = "resume"
}

variable "location" {
  default = "australiaeast"
}
variable "tags" {
  default = {
    project = "cloud_resume"
    managed_by = "terraform"
  }
}
variable "vc_api_name" {
  default = "weirdcloud-visitor-counter-api"
}

# variable "github_token" {
#   description = "My GitHub Personal Access Token"
#   type        = string
#   sensitive   = true #security
# }