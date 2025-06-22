variable "demo_password" {
  description = "Demo password for NGINX (used as a secret)"
  type        = string
  sensitive   = true
}
