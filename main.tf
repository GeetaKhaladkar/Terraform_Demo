resource "aws_vpc" "my-vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      "Name" = "MY-VPC"
    }
}



resource "aws_subnet" "pubsub" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = var.subnets_cidr
    availability_zone = var.azs
    map_public_ip_on_launch = true
    tags = {
      "Name" = "MY-PUBLIC-SUBNET"
    }
}



resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      "Name" = "MY-IGW"
    }
}



resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "MY-PUBLIC-RT"
  }
}





resource "aws_route_table_association" "Public-RT-Association" {
    subnet_id = aws_subnet.pubsub.id
    route_table_id = aws_route_table.public-rt.id
}






resource "aws_security_group" "SG_Devops" {
    vpc_id = aws_vpc.my-vpc.id
    name = "SG_Devops"
    
    ingress {
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"

    }

    ingress {
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"

    }

     ingress {
        from_port = 3000
        to_port = 3000
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"

    }
    
    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

  
}





resource "aws_instance" "EC2-Instance" {
    ami = var.ami
    instance_type = var.instance_type
    security_groups = [aws_security_group.SG_Devops.id]
    subnet_id = aws_subnet.pubsub.id
    key_name = var.aws_key
    tags = {
      "Name" = "EC2-Instance"
    }
    
    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y",
        "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
        "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
        "sudo apt update",
        "sudo apt-cache policy docker-ce -y",
        "sudo apt install docker-ce -y",
        "sudo git clone https://github.com/pathakbhaskar/samplequest",
        "cd samplequest",
        "sudo docker build -t mytestapp .",
        "sudo docker run -d -p 3000:3000 mytestapp",
        "sudo echo 'Done'",
      ]
    }

    connection {
		
		        type = "ssh"
		        host = self.public_ip
		        user = "ubuntu"
		        private_key = file("C:\\PEM file\\devops_practice.pem")
	}
 }