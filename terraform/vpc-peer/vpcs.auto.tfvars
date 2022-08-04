vpc = {
  a4l-vpca = {
    cidr            = "10.16.0.0/16"
    azs             = ["us-east-1a"]
    private_subnets = ["10.16.0.0/20"]
  }
  a4l-vpcb = {
    cidr            = "10.17.0.0/16"
    azs             = ["us-east-1a"]
    private_subnets = ["10.17.0.0/20"]
  }
  a4l-vpcc = {
    cidr            = "10.18.0.0/16"
    azs             = ["us-east-1a"]
    private_subnets = ["10.18.0.0/20"]
  }
}
