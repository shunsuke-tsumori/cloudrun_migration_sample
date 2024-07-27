resource "google_artifact_registry_repository" "migration" {
  location      = "asia-northeast1"
  repository_id = "migration"
  description   = "migration docker repository"
  format        = "DOCKER"
}

resource "google_cloud_run_v2_job" "migration" {
  name     = "migration"
  location = "asia-northeast1"
  template {
    template {
      service_account = google_service_account.migration_job.email
      containers {
        image = "asia-northeast1-docker.pkg.dev/${google_artifact_registry_repository.migration.project}/${google_artifact_registry_repository.migration.repository_id}/migration:latest"
      }
      vpc_access {
        connector = google_vpc_access_connector.connector.id
      }
    }
  }
}
