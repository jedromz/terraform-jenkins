resource "google_compute_instance" "jenkins-compute-instance" {
  tags = ["http-server","https-server","jenkins-task"]
  name         = "jenkins-task"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
	image="ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  network_interface{
  network = "vpc-network"
  subnetwork = "my-custom-subnet"
  access_config {
      // Ephemeral public IP
    }
}
 metadata_startup_script = <<EOT
sudo apt-get install -yq openjdk-11-jre
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt-get install -yq jenkins
sudo systemctl start jenkins.service
sudo systemctl status jenkins > jenkis_status.txt
EOT
}
output "Web-server-URL" {
 value = join("",["http://",google_compute_instance.jenkins-compute-instance.network_interface.0.access_config.0.nat_ip,":80"])
}
