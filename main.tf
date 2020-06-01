# Define Security Group for subnet
resource "aws_security_group" "tf-securitygroup" {
  description = "Allow limited inbound external traffic"
  name        = "tf-demo-securitygroup"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf-demo-securitygroup"
  }
}
# Define SSH key pair for EC2 instance
resource "aws_key_pair" "key-demo" {
  key_name   = "key-demo"
  public_key = "${file("key-demo.pub")}"
}

#Define EC2 instance webserver
resource "aws_instance" "ec2testserver" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.tf-securitygroup.id}"]
  key_name                    = "${aws_key_pair.key-demo.key_name}"
  count                       = 1
  description                 = "test desc"
  associate_public_ip_address = true
  user_data                   = <<EOF
        #!bin/bash
        yum install httpd -y
        service httpd start
        chkconfig httpd on
        var_ip =  file("$/tmp/public_ip.txt")

echo  $var_ip  > /var/www/html/index.html

        EOF

  tags = {
    Name    = "ec2testserver"
    Project = "demo project"
  }
  connection {
    type = "ssh"
    host = "self.public_ip"
    user = "ubuntu"
  }

  provisioner "local-exec" {
    command = "echo '<h1> Hello from IP: ' ${self.public_ip} >> public_ip.txt"
  }
  provisioner "file" {
    source      = "public_ip.txt"
    destination = "/tmp/public_ip.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/public-ip.txt",
    ]
  }
}

output "public_ip" {
  description = "bulic IP assigned to the instances"
  value       = aws_instance.ec2testserver.*.public_ip
}
