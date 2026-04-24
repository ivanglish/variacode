# ECS Fargate Multi-Environment Infrastructure

This repository contains Infrastructure as Code (Terraform) and application code for a static containerized web app running on AWS ECS Fargate.  
It is designed for **environment isolation (`test` and `prod`)**, safe promotion through Pull Requests, and repeatable CI/CD with AWS CodePipeline + CodeBuild.

## Architecture Diagram

![Alt text](images/variacode_arch.png)

## Architecture Overview

Main AWS components:

- **Compute:** ECS Fargate service for container execution.
- **Network:** VPC, subnets, routing, and security groups for controlled ingress/egress.
- **Traffic:** Application Load Balancer (ALB) as entry point.
- **Security:** IAM roles and least-privilege permissions for ECS, CodePipeline, and CodeBuild.
- **Observability:** CloudWatch logs for deployment and runtime visibility.

## Reusability Across Environments (Test and Prod)

The implementation is built around Terraform workspaces and reusable composition:

- `terraform.workspace` drives environment-specific behavior (`test` vs `prod`).
- A shared root configuration is reused for both environments with different parameters.
- Pipeline resources are encapsulated in the `pipelines` module and instantiated from `main.tf`.
- ECS updates can be selectively applied (`-target=module.ecs`) when only app artifacts change.

This approach keeps one IaC codebase while still allowing different lifecycle behavior per environment.

## Repository Structure and Branching Strategy

Current structure:

```text
.
├── main.tf                  # Calls the reusable pipelines module
├── provider.tf              # Provider and Terraform configuration
├── var.tf                   # Environment mapping and variables
├── networking.tf            # VPC and subnet definitions
├── alb.tf                   # Load balancer resources
├── sg.tf                    # Security groups
├── ecs.tf                   # ECS cluster/service/task resources
├── iam.tf                   # IAM resources
├── output.tf                # Outputs
├── buildspec.yml            # CodeBuild logic (Terraform + Docker flow)
├── pipelines/
│   ├── artifacts.tf
│   ├── codebuild.tf
│   ├── codepipeline.tf
│   ├── github_connection.tf
│   ├── iam.tf
│   └── variables.tf
├── Dockerfile
├── index.html
└── README.md
```

Branching model:

- **`test`:** integration and validation branch. Pushes trigger the test pipeline.
- **`main`:** production branch.  
  **No direct commits to production. Production changes are allowed only through Pull Requests (PR) merged into `main`.**

## CI/CD Pipeline Setup (AWS CodePipeline)

This project uses **AWS CodePipeline (V2)** with **AWS CodeBuild**:

1. **Source stage**
   - Reads from GitHub via CodeStar Connection.
   - `test` pipeline reacts to branch updates.
   - `prod` pipeline is configured to react to merged PR events into `main`.

2. **Deploy stage (CodeBuild + Terraform)**
   - Runs `terraform init`.
   - Selects/creates the target workspace (`test` or `prod`).
   - Executes `terraform plan -detailed-exitcode`.
   - If infra changes exist, applies full plan.
   - If infra is unchanged, checks app changes (`index.html` / `Dockerfile`), builds and pushes image, then applies targeted ECS update.

## Creating Pipelines Locally (`-target`)

For initial bootstrap, create only pipeline prerequisites first to avoid dependency deadlocks and to speed up creation:

```bash
terraform init
terraform workspace select test || terraform workspace new test
terraform plan -target=module.deployment_infrastructure
terraform apply -target=module.deployment_infrastructure
```

You can repeat with `prod` workspace as needed:

```bash
terraform workspace select prod || terraform workspace new prod
terraform apply -target=module.deployment_infrastructure
```

> Recommendation: use `-target` only for bootstrap/recovery scenarios, then return to full `terraform plan/apply` for normal operations.


## Git and Collaboration Best Practices

- Commit frequently in small, atomic changes.
- Write descriptive, imperative commit messages.
- Open PRs early; review infra changes with at least one peer.
- Keep `main` protected and PR-only for production promotion.
- Include plan output and diagram updates in infra PRs when relevant.

## Future Improvement

- **Automate initial GitHub connection bootstrap for pipelines** so the first-time manual setup in CodeStar Connection is minimized or eliminated.
