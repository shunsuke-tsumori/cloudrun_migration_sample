resource "google_artifact_registry_repository" "migration" {
  location      = "asia-northeast1"
  repository_id = "migration"
  description   = "migration docker repository"
  format        = "DOCKER"
}
