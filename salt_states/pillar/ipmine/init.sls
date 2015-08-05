mine_functions:
  internal_ip_addrs:
    mine_function: network.ip_addrs 
    interface: eth0
    cidr: 172.31.0.0/16
  hostname:
    mine_function: grains.item
    farm_name