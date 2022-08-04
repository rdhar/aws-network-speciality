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
