# ─────────────────────────────────────────────────────────────────
# General
# ─────────────────────────────────────────────────────────────────
variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "airbnb-clone-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "app_name" {
  description = "Base name used for all resources"
  type        = string
  default     = "airbnb-clone"
}

variable "acr_name" {
  description = "Azure Container Registry name (globally unique, alphanumeric only)"
  type        = string
  default     = "airbnbcloneacr"
}

# ─────────────────────────────────────────────────────────────────
# Backend env vars
# ─────────────────────────────────────────────────────────────────
variable "db_url" {
  description = "MongoDB Atlas connection string"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT signing secret"
  type        = string
  sensitive   = true
}

variable "jwt_expiry" {
  description = "JWT expiry duration"
  type        = string
  default     = "20d"
}

variable "cookie_time" {
  description = "Cookie expiry in days"
  type        = string
  default     = "7"
}

variable "session_secret" {
  description = "Express session secret"
  type        = string
  sensitive   = true
}

variable "cloudinary_name" {
  description = "Cloudinary cloud name"
  type        = string
}

variable "cloudinary_api_key" {
  description = "Cloudinary API key"
  type        = string
  sensitive   = true
}

variable "cloudinary_api_secret" {
  description = "Cloudinary API secret"
  type        = string
  sensitive   = true
}
