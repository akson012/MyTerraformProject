provider "aws" {
  region     =  var.aws_region
  skip_region_validation = true
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Create VPC network, subnet, nat gateway and network acl
# = = = = = = = = = = = = = = = = = = = = = = = = = = = =


module "vpc" {
  source                = "./src/vpc"
  name                  = "${var.aws_user_prefix}"
  cidr                  = "10.0.0.0/16"
  azs                   = ["us-east-1a", "us-east-1b"]
  private_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets        = ["10.0.3.0/24", "10.0.4.0/24"]
  single_nat_gateway = true
  enable_nat_gateway = true

  public_subnet_tags = {
  Name = "${var.aws_user_prefix}-public"
}

tags = {
  Owner       = "${var.aws_user_prefix}"
  Environment = "${var.environment}"
}

vpc_tags = {
  Name = "${var.aws_user_prefix}"
}
}


# = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Create EC2 instance using AMI with cloudwatch alarm
# = = = = = = = = = = = = = = = = = = = = = = = = = = = =

module "ec2_provision" {
  source                 = "./src/ec2"
  #name                   = "testec2"
  instance_count         = 1
  ami                    = "ami-111112222223333"
  instance_type          = "t3a.micro"
  key_name               = "specialproject"
  monitoring             = true
  vpc_security_group_ids = ["sg-123124123"]
  subnet_id              = "subnet-1231231231"
  tags                   = {
    Name = "ec2 test1"
    Project = "special projects"
    Environment = "Development"
    Contact = "infra@xyz.com"
  }
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Application Load Balancer (HTTP and HTTPS listeners)
# = = = = = = = = = = = = = = = = = = = = = = = = = = = =

module "alb_provision" {
  source  = "./src/alb"
#  version = "~> 5.0"
  name = "my-alb2"
  load_balancer_type = "application"
  vpc_id             = "vpc-012312312"
  subnets            = ["subnet-1231241231", "subnet-1231241231"]
  security_groups    = ["sg-123124123123"]

  access_logs = {
    bucket = "test-myalb-project"
  }

  target_groups = [
    {
      name_prefix      = "test-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn   = "CERT_MANAGER_SSL_ARN"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}
