# Red y gateway VPN dummy
resource "google_compute_network" "default" {
  name = "gcp-network"
}

resource "google_compute_firewall" "allow_all" {
  name    = "allow-all"
  network = google_compute_network.default.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"] # 🚨 Error intencional
  target_tags   = ["allow-all"]
}

# VPN gateway para simular conexión con AWS
resource "google_compute_vpn_gateway" "gcp_gateway" {
  name    = "gcp-vpn-gateway"
  network = google_compute_network.default.name
}

# Túnel VPN simulado (IP privada válida)
resource "google_compute_vpn_tunnel" "to_aws_tunnel" {
  name               = "gcp-to-aws-tunnel"
  peer_ip            = "35.0.0.1" # IP pública de ejemplo
  shared_secret      = "supersecret"
  target_vpn_gateway = google_compute_vpn_gateway.gcp_gateway.id
}
