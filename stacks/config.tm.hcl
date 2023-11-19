globals {
  terraform_version                 = "~> 1.5"
  terraform_google_provider_version = "> 4, < 5.0"

  project = "terramate-demo-${global.environment}"
  region  = "asia-southeast1"

  backend_bucket = "terramate-demo-tfstate"
  backend_prefix = "${terramate.stack.path.relative}"
}
  