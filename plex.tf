
provider "aws" {
  region = "eu-west-3"
}

variable "username" {
  default = "ubuntu"
}


# =================
# = Bastion Setup =
# =================

resource "aws_default_vpc" "default" {}

resource "aws_instance" "plex" {
  ami                         = "ami-075c0d7b8471e91e9"
  key_name                    = "${aws_key_pair.plex_key.key_name}"
  instance_type               = "t2.medium"
  security_groups             = ["${aws_security_group.plex-sg.name}"]
  associate_public_ip_address = true

  provisioner "file" {
    source      = "./install_plex.sh"
    destination = "/tmp/install_plex.sh"
    connection {
      type    = "ssh"
      host    = aws_instance.plex.public_ip
      user    = var.username
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_plex.sh",
      "sudo /tmp/install_plex.sh",
    ]
    connection {
      type    = "ssh"
      host    = aws_instance.plex.public_ip 
      user    = var.username
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

resource "aws_security_group" "plex-sg" {
  name   = "plex-security-group"
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 32400
    to_port     = 32400
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "plex_key" {
  key_name   = "ahicks_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# ===========
# = Outputs =
# ===========

output "plex_public_dns" {
  value = aws_instance.plex.public_dns
}

