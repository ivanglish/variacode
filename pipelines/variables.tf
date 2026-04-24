variable "workspace_name" {
  description = "The current terraform workspace (test or prod)"
  type        = string
}

variable "env_label" {
  description = "The label from var.envs (testing or production)"
  type        = string
}