variable "vpc_cidr" {

    default = "10.0.0.0/16"
}


variable "subnets_cidr" {

    default = "10.0.1.0/24"
}


variable "ami" {

    default = "ami-0851b76e8b1bce90b"
}




variable "instance_type" {

    default = "t2.micro"
}



variable "aws_key" {

    default = "devops_practice"
}


variable "azs" {

    default = "ap-south-1a"

}