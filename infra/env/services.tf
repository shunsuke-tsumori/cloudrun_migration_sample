locals {
  services = toset([
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "servicenetworking.googleapis.com",
  ])
}

resource "google_project_service" "project_services" {
  for_each = local.services

  service            = each.key
  disable_on_destroy = false
}
