resource "google_compute_instance" "vm_instance" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = var.network_self_link
    subnetwork = var.subnetwork_self_link

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = var.private_key_pem
      host        = self.network_interface[0].access_config[0].nat_ip
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y default-mysql-client",
      "curl -o /tmp/cloud_sql_proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.0.0/cloud-sql-proxy.linux.amd64",
      "sudo mv /tmp/cloud_sql_proxy /usr/local/bin/cloud_sql_proxy",
      "sudo chmod +x /usr/local/bin/cloud_sql_proxy",
      "sudo mkdir /cloudsql",
      "sudo chmod 777 /cloudsql",
      "sudo /usr/local/bin/cloud_sql_proxy --private-ip ${var.instance_connection_name} &",
    ]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_key_pub}"
  }

  tags = ["vm-instance"]
}

resource "google_compute_firewall" "allow_ssh" {
  project = var.project_id
  name    = "allow-ssh"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vm-instance"]
}

resource "google_compute_firewall" "allow_cloud_sql_proxy" {
  project = var.project_id
  name    = "allow-cloud-sql-proxy"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_tags = ["vm-instance"]
  target_tags = ["cloud-sql-proxy"]
}