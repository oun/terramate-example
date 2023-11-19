generate_hcl "_backend.tf" {
  content {
    terraform {
      backend "gcs" {
        bucket = global.backend_bucket
        prefix = global.backend_prefix
      }
    }
  }
}
