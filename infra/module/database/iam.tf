resource "google_service_account" "migration_job" {
  account_id  = "migration-job"
  description = "for migration job"
}

resource "google_project_iam_member" "migration_job" {
  for_each = toset([
    "roles/artifactregistry.reader",
    "roles/cloudsql.admin",
  ])
  project = data.google_project.current.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.migration_job.email}"
}
