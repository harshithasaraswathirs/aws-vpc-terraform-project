 
# Security Group - Virtual firewall for EC2 instance
# Controls what traffic can reach your server
resource "aws_security_group" "web_server" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web server - allows HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  # INBOUND RULES (what can reach your server)
  
  # Allow HTTP traffic from anywhere (port 80)
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 0.0.0.0/0 = anywhere
  }

  # Allow SSH access from anywhere (port 22)
  # In production, you'd restrict this to your IP only
  ingress {
    description = "SSH from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OUTBOUND RULES (what your server can access)
  
  # Allow all outbound traffic (for updates, downloads, etc.)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-web-sg"
    Project = var.project_name
  }
}