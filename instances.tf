# 1. AWS Linux 2 Latest AMI Fetcher (Dynamic)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. Security Group for Bastion Host (Allows SSH from Internet)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Allow SSH access to Bastion Host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Production me yahan sirf aapka IP hota hai
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-bastion-sg"
  }
}

# 3. Security Group for Private App Server (Allows SSH ONLY from Bastion SG)
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow SSH from Bastion Host only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Strictly locked to Bastion!
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Application deployment ke liye HTTP port open kiya
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-app-sg"
  }
}

# 4. Bastion Host Server (Public Subnet)
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  key_name               = "cicd-runner-key"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "prod-bastion-host"
  }
}

# 5. Application Server (Private Subnet)
resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  key_name               = "cicd-runner-key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "prod-app-server"
  }
}

# 6. Outputs to print IP addresses after creation
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}