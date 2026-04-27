variable "env_label" {
  description = "The label from var.envs (testing or production)"
  type        = string
}

variable "environment" {
  description = "Environment name for resource naming and build context."
  type        = string
}

variable "source_branch" {
  description = "Branch that the pipeline tracks."
  type        = string
}

variable "pr_trigger" {
  description = "Whether to use PR-merge trigger semantics (prod)."
  type        = bool
}