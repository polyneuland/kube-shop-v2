data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "ssh" {
  key_name   = "kubeshop-${var.environment}-ssh-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "vm_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.vm_app_group.id]
  key_name               = aws_key_pair.ssh.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "kubeshop-${var.environment}-instance-app"
  }
}

resource "aws_instance" "vm_banco" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.vm_banco_group.id]
  key_name               = aws_key_pair.ssh.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "kubeshop-${var.environment}-instance-banco"
  }
}

resource "aws_ebs_volume" "ebs_banco" {
  availability_zone = aws_instance.vm_banco.availability_zone
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "kubeshop-${var.environment}-ebs-banco"
  }
}

resource "aws_volume_attachment" "banco_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ebs_banco.id
  instance_id = aws_instance.vm_banco.id
}