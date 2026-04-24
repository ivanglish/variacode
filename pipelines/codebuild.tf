resource "aws_codebuild_project" "terraform_build" {
  name         = "terraform-ecs-build-${terraform.workspace}"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts { type = "CODEPIPELINE" }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true # Required to run Docker inside CodeBuild

    environment_variable {
      name  = "TF_WORKSPACE"
      value = terraform.workspace
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = {
    name = "csgtest"
  }
}