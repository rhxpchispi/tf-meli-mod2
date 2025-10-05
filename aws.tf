# EKS Cluster básico y recursos asociados

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_security_group" "open_sg" {
  name        = "allow-all"
  description = "Security group overly permissive (intencional)"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 🚨 Error intencional: acceso total
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 🚨 Error intencional
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eksClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "eks.amazonaws.com" },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 🚨 Política intencionalmente insegura
resource "aws_iam_policy" "overly_permissive_policy" {
  name        = "AllowEverythingPolicy"
  description = "Policy que permite todo (intencional para detectar)"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "*",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.overly_permissive_policy.arn
}

# Dummy EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "dummy-eks"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids         = []
    security_group_ids = [aws_security_group.open_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_attach]
}

# Dummy VPN simulando conexión a GCP
resource "aws_vpn_connection" "to_gcp" {
  customer_gateway_id = "cgw-12345"
  vpn_gateway_id      = "vgw-12345"
  type                = "ipsec.1"
  static_routes_only  = true
}
