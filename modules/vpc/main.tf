# =====================
# 🌐 VPC + Subnet Setup
# ===================== 

# 🚧 Creates the main Virtual Private Cloud
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc-${var.environment}"
  }
}

# 📦 Public Subnets 
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-frontend-public-${element(var.availability_zones, count.index)}-${var.environment}"
  }
}

# 📦 Private Subnets for frontend 
resource "aws_subnet" "frontend_private" {
  count = length(var.frontend_private_subnets)

  vpc_id            = aws_vpc.this.id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = element(var.frontend_private_subnets, count.index)

  tags = {
    Name = "${var.project_name}-frontend-private-${element(var.availability_zones, count.index)}-${var.environment}"
  }
}

# 🔒 Private Subnets 
resource "aws_subnet" "backend_private" {
  count = length(var.backend_private_subnets)

  vpc_id            = aws_vpc.this.id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = element(var.backend_private_subnets, count.index)

  tags = {
    Name = "${var.project_name}-backend-private-${element(var.availability_zones, count.index)}-${var.environment}"
  }
}


# 🔒 Private Subnets 
resource "aws_subnet" "database_private" {
  count = length(var.database_private_subnets)

  vpc_id            = aws_vpc.this.id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = element(var.database_private_subnets, count.index)

  tags = {
    Name = "${var.project_name}-database-private-${element(var.availability_zones, count.index)}-${var.environment}"
  }
}

# =========================
# 🌍 Internet Gateway Setup
# =========================

# 🌐 Internet Gateway for public subnets (1 per VPC)
resource "aws_internet_gateway" "this" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-ig-${var.environment}"
  }
}

# ====================
# 🚪 NAT Gateway Setup
# ====================

# 📤 Elastic IP for NAT Gateway
resource "aws_eip" "this" {
  count = var.enable_nat_gateway == true ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-${var.environment}"
  }
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway == true ? 1 : 0

  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.this[0].id

  tags = {
    Name = "${var.project_name}-nat-gw-${var.environment}"
  }

  depends_on = [aws_internet_gateway.this]
}

# =========================
# 🛣️ Route Tables & Routing
# =========================

# 🛣️ Public Route Table
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = {
    Name = "${var.project_name}-public-rt-${var.environment}"
  }
}

# 🔒 Private Route Tables
resource "aws_route_table" "frontend_private" {
  count = var.enable_nat_gateway == true && length(var.frontend_private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = "${var.project_name}-frontend-private-rt-${var.environment}"
  }
}

resource "aws_route_table" "backend_private" {
  count = var.enable_nat_gateway == true && length(var.backend_private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = "${var.project_name}-backend-private-rt-${var.environment}"
  }
}

resource "aws_route_table" "database_private" {
  count = var.enable_nat_gateway == true && length(var.database_private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = "${var.project_name}-database-private-rt-${var.environment}"
  }
}

# ===========================
# 🔗 Route Table Associations
# ===========================

# 🔗 Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count = length(aws_route_table.public) > 0 && length(aws_subnet.public) > 0 ? length(aws_subnet.public) : 0

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}

# 🔗 Associate private subnets with private route table
resource "aws_route_table_association" "frontend_private" {
  count = length(aws_route_table.frontend_private) > 0 && length(aws_subnet.frontend_private) > 0 ? length(aws_subnet.frontend_private) : 0

  route_table_id = aws_route_table.frontend_private[0].id
  subnet_id      = aws_subnet.frontend_private[count.index].id
}

resource "aws_route_table_association" "backend_private" {
  count = length(aws_route_table.backend_private) > 0 && length(aws_subnet.backend_private) > 0 ? length(aws_subnet.backend_private) : 0

  route_table_id = aws_route_table.backend_private[0].id
  subnet_id      = aws_subnet.backend_private[count.index].id
}

resource "aws_route_table_association" "database_private" {
  count = length(aws_route_table.database_private) > 0 && length(aws_subnet.database_private) > 0 ? length(aws_subnet.database_private) : 0

  route_table_id = aws_route_table.database_private[0].id
  subnet_id      = aws_subnet.database_private[count.index].id
}

# ===============
# Security Groups 
# ===============

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg-${var.environment}"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg-${var.environment}"
  }
}

resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-frontend-sg-${var.environment}"
  description = "Security group for frontend instances"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Allow frontend ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-frontend-sg-${var.environment}"
  }
}

resource "aws_security_group" "backend" {
  name        = "${var.project_name}-backend-sg-${var.environment}"
  description = "Security group for backend instances"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Allow backend ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-backend-sg-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg-${var.environment}"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  dynamic "ingress" {
    for_each = var.rds_allowed_ips
    content {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg-${var.environment}"
  }
}