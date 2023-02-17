data "google_compute_network" "vpc_data_network"{
    name = "vpc-network"
  }

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = data.google_compute_network.vpc_data_network.name
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins-task"]
}
resource "google_compute_firewall" "jenkins" {
  name    = "jenkins-firewall"
  network = data.google_compute_network.vpc_data_network.name

  allow {
    protocol = "tcp"
    ports    = ["80","8080"]
  }
  source_ranges = ["0.0.0.0/0"]
}
