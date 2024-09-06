config {
  plugin_dir = "~/.local/share/tflint/plugins"
}

plugin "terraform" {
  enabled = true
  preset = "all"
}

plugin "aws" {
  enabled = true
  version = "0.32.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}