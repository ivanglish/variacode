resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })

  tags = {
    name = "csgtest"
  }
}

# Attach AdministratorAccess for simplicity in this lab, 
# but in real prod, you should use a more restrictive policy.
resource "aws_iam_role_policy_attachment" "codebuild_admin" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# CodePipeline service role (Source + CodeBuild stages)
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-service-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
    }]
  })

  tags = {
    name = "csgtest"
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-inline-${var.environment}"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ArtifactBucket"
        Effect = "Allow"
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
        ]
        Resource = [
          aws_s3_bucket.codepipeline_artifacts.arn,
          "${aws_s3_bucket.codepipeline_artifacts.arn}/*",
        ]
      },
      {
        Sid    = "CodeBuild"
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:StopBuild",
        ]
        Resource = aws_codebuild_project.terraform_build.arn
      },
      {
        Sid    = "CodeStarConnection"
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection",
        ]
        Resource = aws_codestarconnections_connection.github.arn
      },
      {
        Sid    = "PassRoleToCodeBuild"
        Effect = "Allow"
        Action = [
          "iam:PassRole",
        ]
        Resource = aws_iam_role.codebuild_role.arn
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "codebuild.amazonaws.com"
          }
        }
      },
    ]
  })
}