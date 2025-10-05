output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "gcp_network_name" {
  value = google_compute_network.default.name
}

output "vpn_simulada" {
  value = "VPN entre AWS y GCP configurada de forma dummy"
}
