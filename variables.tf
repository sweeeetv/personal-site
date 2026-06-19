variable "project" {
  default = "cloud_resume"
}

variable "location" {
  default = "australiaeast"
}
variable "tags" {
  default = {
    project = "cloud_resume"
  }
}
variable "visiter_counter_api_name" {
  default = "weirdcloud-visiter-counter-api"
}

variable "github_token" {
  description = "My GitHub Personal Access Token"
  type        = string
  sensitive   = true # This hides the token from appearing in your terminal logs
}