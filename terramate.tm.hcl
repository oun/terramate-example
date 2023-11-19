terramate {
  config {
    git {
      check_untracked   = false
      check_uncommitted = false
    }
    run {
      env {
        TF_PLUGIN_CACHE_DIR = "${env.HOME}/.terraform.d/plugin-cache"
      }
    }
  }
}