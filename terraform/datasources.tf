data "aws_ssm_parameter" "fsl_token" {
    name = "/github/fsl-token"
    with_decryption = true
  
}