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

#* terraform apply should be run with all entries set to false initially
#* To enable each vpc peer set enabled to true

vpc_peers = {
  vpca_vpcb = {
    this_vpc_id = "a4l-vpca"
    that_vpc_id = "a4l-vpcb"
    enabled     = false
  }
  vpcb_vpcc = {
    this_vpc_id = "a4l-vpcb"
    that_vpc_id = "a4l-vpcc"
    enabled     = false
  }
  vpca_vpcc = {
    this_vpc_id = "a4l-vpca"
    that_vpc_id = "a4l-vpcc"
    enabled     = false
  }
}
