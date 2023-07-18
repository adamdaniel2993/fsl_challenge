resource "aws_amplify_app" "fsl_react_app" {
  name       = "fsl-react-app-${var.environment}"
  repository = "https://github.com/adamdaniel2993/fsl_challenge"
  access_token = data.aws_ssm_parameter.fsl_token.value

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - nvm install 15
            - nvm use 15
            - npm install 
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.fsl_react_app.id
  branch_name = "main"

  framework = "React"
  stage     = terraform.workspace

}