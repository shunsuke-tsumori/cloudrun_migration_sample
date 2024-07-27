resource "google_sql_database_instance" "db" {
  name             = "db"
  database_version = "POSTGRES_16"
  region           = "asia-northeast1"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      private_network = google_compute_network.db_network.id
      ipv4_enabled    = false

      enable_private_path_for_google_cloud_services = true
    }
  }
  depends_on = [google_service_networking_connection.db_conn]
}

resource "google_sql_user" "db_admin" {
  project  = data.google_project.current.project_id
  instance = google_sql_database_instance.db.name
  name     = "db-admin"
  # 本来はシークレットマネージャなどを使用するべき
  password = var.password
}

resource "google_sql_database" "db" {
  project  = data.google_project.current.project_id
  instance = google_sql_database_instance.db.name
  name     = "db"
}
