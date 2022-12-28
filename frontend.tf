# Create frontend web server

resource "aws_instance" "frontend-srv" {
  ami                         = "ami-08d4ac5b634553e16"
  instance_type               = "t2.small"
  vpc_security_group_ids      = [aws_security_group.frontend-srv-sg.id]
  key_name                    = "dev-kp"
  subnet_id                   = aws_subnet.public-SN1.id
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 30
    delete_on_termination = true
  }

  tags = {
    "Name" = "frontend-github-srv"
  }
}


#Create security group for frontend
resource "aws_security_group" "frontend-srv-sg" {
  name        = "frontend-srv-sg"
  description = "Allow  traffics"
  vpc_id      = aws_vpc.main-vpc.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    },

    {
      description      = "icmp"
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["10.0.0.0/16"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    },

    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["71.150.189.42/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    },


    {
      description      = "CUSTOM TCP"
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]


  egress = [
    {
      description      = "for all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "frontend-github-sg"
  }
}

