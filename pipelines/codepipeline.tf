resource "aws_codepipeline" "ecs_pipeline" {
  name     = "pipeline-${var.environment}"
  role_arn = aws_iam_role.codepipeline_role.arn
  pipeline_type = "V2"
  
  artifact_store {
    location = aws_s3_bucket.codepipeline_artifacts.bucket
    type     = "S3"
  }

  dynamic "trigger" {
    for_each = var.pr_trigger ? [1] : []
    content {
      provider_type = "CodeStarSourceConnection"
      git_configuration {
        source_action_name = "Source"
        pull_request {
          events   = ["CLOSED"] # Triggers when PR is merged
          branches {
            includes = ["main"]
          }
        }
      }
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "ivanglish/variacode"
        BranchName       = var.source_branch
        DetectChanges    = var.pr_trigger ? false : true
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "BuildAndDeploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.terraform_build.name

        EnvironmentVariables = jsonencode([
          {
            name  = "APP_ENVIRONMENT_LABEL"
            value = var.env_label
            type  = "PLAINTEXT"
          },
          {
            name  = "TARGET_WORKSPACE"
            value = var.environment
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  tags = {
    name = "csgtest"
  }
}