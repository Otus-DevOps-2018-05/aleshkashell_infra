terraform {
  backend "gcs" {
    project = "app"
    bucket  = "infra-bucket-prod"
    prefix  = "terraform/state"
  }
}
