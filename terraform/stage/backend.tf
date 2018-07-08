terraform {
  backend "gcs" {
    project = "app"
    bucket  = "infra-bucket-stage"
    prefix  = "terraform/state"
  }
}
