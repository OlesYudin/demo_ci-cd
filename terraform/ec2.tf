resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.ubuntu.id     # ubuntu 16.04
  instance_type          = var.instance_type          # instant params
  vpc_security_group_ids = [aws_security_group.sg.id] # attach sec group
  subnet_id              = aws_subnet.public_subnet[0].id
  key_name               = var.ssh_key                        # key for SSH connection
  user_data              = file("./shell/password_config.sh") # initial config

  tags = {
    Name        = "Password generator"
    Owner       = "Student"
    Description = "Password generator in AWS EC2 instance that have CI/CD using Jenkins and Docker"
    Environment = var.env
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id     # ubuntu 16.04
  instance_type          = var.instance_type          # instant params
  vpc_security_group_ids = [aws_security_group.sg.id] # attach sec group
  subnet_id              = aws_subnet.public_subnet[1].id
  key_name               = var.ssh_key                       # key for SSH connection
  user_data              = file("./shell/jenkins_config.sh") # initial config

  tags = {
    Name        = "Jenkins"
    Owner       = "Student"
    Descriprion = "Webserver for jenkins"
    Environment = var.env
  }

  depends_on = [aws_internet_gateway.igw]
}




# resource "aws_instance" "web1" {
#   count                  = length(var.public_subnet)                # count numbers of public subnets
#   ami                    = data.aws_ami.ubuntu.id                   # ubuntu 16.04
#   instance_type          = var.instance_type                        # instant params
#   subnet_id              = aws_subnet.public_subnet[count.index].id # attach EC2 to subnet
#   vpc_security_group_ids = [aws_security_group.sg.id]               # attach sec group
#   key_name               = var.ssh_key                              # key for SSH connection
#   user_data              = file("./shell/apache.sh")                # install apache

#   tags = {
#     Name        = "Webserver-${count.index + 1}"
#     AZ          = "${data.aws_availability_zones.available.names[count.index]}"
#     Owner       = "Student"
#     Environment = var.env
#   }

#   depends_on = [aws_internet_gateway.igw]
# }
