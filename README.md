ECS Fargate Multi-Environment Infrastructure
This repository contains the Infrastructure as Code (IaC) and application source code for a containerized static web application deployed on AWS ECS Fargate. The project leverages Terraform Workspaces and AWS CodePipeline to provide a fully automated, scalable, and environment-isolated deployment workflow.

🏗 Architecture Overview
The infrastructure is designed for high availability and security. It utilizes a regional networking strategy in São Paulo (sa-east-1) to serve traffic via an Application Load Balancer (ALB).

Core Components:
Compute: AWS ECS Fargate (Serverless container execution).

Networking: Custom VPC logic with public subnets across multiple Availability Zones, managed dynamically via Terraform.

Traffic Management: Application Load Balancer (ALB) providing a single, persistent DNS entry point.

Security: Tiered Security Groups (ALB-to-ECS) and IAM Execution Roles for granular permission control.

Monitoring: Integrated CloudWatch Log Groups for real-time application forensics.

🚀 CI/CD Pipeline & Branching Strategy
We utilize a Branch-per-Environment strategy to ensure code quality and stability across different stages of the lifecycle.

Branching Model:
test Branch: Used for active development and integration testing. Every push to this branch triggers the Test Pipeline.

main Branch: Represents the production-ready state. This branch only accepts Pull Requests (PRs). Every merge to main triggers the Production Pipeline.

The Pipeline Workflow:
Source: AWS CodeStar Connection monitors GitHub for pushes.

Smart Build (CodeBuild): * Detects changes specifically in index.html or Dockerfile.

If changes are detected, it builds a Linux/AMD64 image and pushes it to ECR.

If only infrastructure files change, it skips the Docker build to save time.

Deploy (Terraform):

Dynamically selects the correct Terraform Workspace (test or prod).

Executes terraform apply to synchronize the cloud state with the code.

📂 Repository Structure
Plaintext
.
├── modules/                # Reusable Terraform logic
│   ├── networking/         # VPC, Subnets, and IGW
│   ├── ecs/                # Cluster, Services, and Task Definitions
│   └── iam/                # Roles and Policies
├── environments/
│   ├── variables.tf        # Environment-specific lookups (test vs prod)
│   ├── providers.tf        # AWS and Version configurations
│   └── main.tf             # Root module calling reusable modules
├── src/
│   ├── index.html          # Application source code
│   └── Dockerfile          # Container configuration
├── buildspec.yml           # CI/CD instructions for AWS CodeBuild
└── README.md               # This documentation
🛠 Terraform Best Practices
To maintain a "Professional Grade" infrastructure, we adhere to the following principles:

Modularization: Instead of one giant file, we split code into logic-based modules. This makes the code readable and allows us to reuse the same networking logic for both Test and Prod.

Parameterization: We use lookup() functions tied to terraform.workspace. Hardcoding is strictly avoided to ensure the code remains flexible.

Remote State Locking: The state is stored in S3 with state locking enabled, preventing two developers (or two pipelines) from corrupting the infrastructure state simultaneously.

Version Pinning: We lock provider versions (e.g., ~> 5.0) to ensure that an update to the AWS plugin doesn't unexpectedly break our deployment.

🤝 Git & Collaboration Best Practices
Efficiency in a team environment depends on how we interact with the repository:

Atomic Commits: Commit often and keep changes small. One commit should ideally represent one logical change (e.g., "Add health check to ALB").

Descriptive Messages: Use the imperative mood (e.g., "Fix subnet CIDR overlap" instead of "Fixed some stuff").

Pull Request Reviews: No code should reach the main branch without a peer review. This is our primary defense against infrastructure misconfigurations and security leaks.

Local Validation: Always run terraform plan on your local machine before pushing to a branch to catch syntax errors early.

📖 How to Deploy
Local Development
Initialize: terraform init

Switch Workspace: terraform workspace select test

Preview: terraform plan

Apply: terraform apply

Via Pipeline
Simply push your changes to your working branch:

Bash
git checkout test
git add .
git commit -m "Update homepage content"
git push origin test
The AWS CodePipeline will take it from there.

Developed by Ivan — Focused on Scalability and Automation.