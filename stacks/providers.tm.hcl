globals {
  providers = [
    "google",
  ]
  available_providers = {
    google = {
      source  = "hashicorp/google"
      version = global.terraform_google_provider_version
    }
  }
  required_providers = { for k, v in global.available_providers : k => v if tm_contains(global.providers, k) }
}

generate_hcl "_providers.tf" {
  content {
    provider "google" {
      project = global.project
      region  = global.region
    }

    terraform {
      tm_dynamic "required_providers" {
        attributes = global.required_providers
      }
    }

    terraform {
      required_version = global.terraform_version
    }
  }
}