## General
resource "openstack_compute_secgroup_v2" "ssh_sg" {
  name = "ssh-sg"
  description = "ssh security group"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "web_sg" {
  name = "web-sg"
  description = "web security group"
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}


## Networking
resource "openstack_networking_router_v2" "iod_router" {
  name = "iod_router"
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "iod_net" {
  name = "iod_net"
  admin_state_up = "true"
}
resource "openstack_networking_subnet_v2" "iod_subnet" {
  name = "iod_subnet"
  network_id = "${openstack_networking_network_v2.iod_net.id}"
  cidr = "10.0.0.0/24"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8","8.8.4.4"]
}
resource "openstack_networking_router_interface_v2" "iod_ext_interface" {
  router_id = "${openstack_networking_router_v2.iod_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.iod_subnet.id}"
}

resource "openstack_compute_instance_v2" "iod" {
  name = "iod"
  image_name = "CentOS 7 (LTS)"
  availability_zone = "AMS-EQ1"
  flavor_name = "Standard 4GB"
  key_pair = "${var.openstack_keypair}"
  security_groups = ["${openstack_compute_secgroup_v2.ssh_sg.name}","${openstack_compute_secgroup_v2.web_sg.name}"]
  network {
    uuid = "${openstack_networking_network_v2.iod_net.id}"
  }
  user_data = "${file("bootstrap_iod.sh")}"
}

resource "openstack_networking_floatingip_v2" "iod_fip" {
  pool = "floating"
}

resource "openstack_compute_floatingip_associate_v2" "iod_fip" {
  floating_ip = "${openstack_networking_floatingip_v2.iod_fip.address}"
  instance_id = "${openstack_compute_instance_v2.iod.id}"
}
