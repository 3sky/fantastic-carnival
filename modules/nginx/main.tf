resource "google_compute_network" "vpc_network" {
  name                    = format("%s-custom-mode-network", var.env)
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = format("%s-custom-subnet", var.env)
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  count        = (var.ha == true ? 2 : 1)
  name         = format("%s-app-machine", var.env)
  machine_type = var.vm_shape
  zone         = format("%s-a", var.region)
  tags         = var.tags

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential nginx; sudo systemctl enable nginx; sudo systemctl start nginx"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}



resource "google_compute_firewall" "nginx" {
  name    = format("%s-nginx-firewall", var.env)
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}


