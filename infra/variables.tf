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
variable "subscription_id"{
  type = string
}
variable "github_org" {
  type = string
}
variable "github_repo" {
  description = "personal site"
  type = string
}


# ------------ secrets -------------- #
variable "github_token" {
  description = "My GitHub Personal Access Token"
  type        = string
  sensitive   = true
}
variable "cloudflare_api_token" {
  type = string
  sensitive =true //ttl of the token is about 5 days.
}