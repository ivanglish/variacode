resource "aws_codepipeline" "ecs_pipeline" {
  name     = "pipeline-${terraform.workspace}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifacts.bucket
    type     = "S3"
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
        BranchName       = terraform.workspace == "prod" ? "master" : terraform.workspace
        # Ensures it triggers automatically on every push
        DetectChanges = true
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

        # PASS THE 'envs' VALUE TO CODEBUILD:
        # This sends "testing" or "production" into the build script
        EnvironmentVariables = jsonencode([
          {
            name  = "APP_ENVIRONMENT_LABEL"
            value = var.env_label
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