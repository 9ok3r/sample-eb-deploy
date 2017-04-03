provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-5e63d13e"
  instance_type = "t2.micro"
}

outputs "ip" {
    value = "${aws_instance.example.ip.public_ip}"
}
