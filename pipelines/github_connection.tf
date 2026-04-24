resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection"
  provider_type = "GitHub"

  tags = {
    name = "csgtest"
  }
}