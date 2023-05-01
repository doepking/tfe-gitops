resource "google_sql_database_instance" "mysql" {
  project   = var.project_id
  region    = var.region
  name      = var.instance_name
  database_version = "MYSQL_8_0"

  settings {
    tier = var.instance_tier

    backup_configuration {
      enabled = var.enable_backup
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.private_network_self_link
    }

    database_flags {
      name  = "innodb_strict_mode"
      value = "on"
    }
  }
  deletion_protection = var.deletion_protection
  depends_on = [var.private_vpc_connection]
}

resource "google_sql_database" "mydb" {
  project   = var.project_id
  name      = var.database_name
  instance  = google_sql_database_instance.mysql.name
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "google_sql_user" "db_user" {
  project     = var.project_id
  instance    = google_sql_database_instance.mysql.name
  name        = var.db_user_name
  host        = "cloudsqlproxy~%"
  password    = random_password.db_password.result
  depends_on  = [google_sql_database_instance.mysql]
}
