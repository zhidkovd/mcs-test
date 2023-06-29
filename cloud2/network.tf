data "vkcs_networking_network" "extnet" {
   name = "ext-net"
}

resource "vkcs_networking_network" "network" {
   name = "net"
}

resource "vkcs_networking_subnet" "subnetwork" {
   name       = "subnet_1"
   network_id = vkcs_networking_network.network.id
   cidr       = "192.168.20.0/24"
}

resource "vkcs_networking_router" "router" {
   name                = "router"
   admin_state_up      = true
   external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "db" {
   router_id = vkcs_networking_router.router.id
   subnet_id = vkcs_networking_subnet.subnetwork.id
}

output "router_ip" {
  value = vkcs_networking_router.router.id
}

resource "vkcs_compute_keypair" "keypair" {
  name = "test-keypair2"
}

output "public_key2" {
  value = vkcs_compute_keypair.keypair.public_key
}

output "private_key2" {
  value = vkcs_compute_keypair.keypair.private_key
  #sensitive = true
}

data "vkcs_compute_flavor" "compute" {
  name = var.compute_flavor
}

data "vkcs_images_image" "compute" {
  name = var.image_flavor
}

resource "vkcs_compute_instance" "compute" {
  name                    = "compute-instance2"
  flavor_id               = data.vkcs_compute_flavor.compute.id
  key_pair                = vkcs_compute_keypair.keypair.id
  security_groups         = ["default", "security_group"]
  availability_zone       = var.availability_zone_name

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 8
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.network.id
  }

  depends_on = [
    vkcs_networking_network.network,
    vkcs_networking_subnet.subnetwork
  ]
}

resource "vkcs_networking_floatingip" "fip" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip" {
  floating_ip = vkcs_networking_floatingip.fip.address
  instance_id = vkcs_compute_instance.compute.id
}

output "instance_fip" {
  value = vkcs_networking_floatingip.fip.address
}

resource "vkcs_networking_secgroup" "secgroup" {
   name = "security_group"
   description = "terraform security group"
}

resource "vkcs_networking_secgroup_rule" "secgroup_rule_1" {
   direction = "ingress"
   ethertype = "IPv4"
   port_range_max = 22
   port_range_min = 22
   protocol = "tcp"
   remote_ip_prefix = "0.0.0.0/0"
   security_group_id = vkcs_networking_secgroup.secgroup.id
   description = "secgroup_rule_1"
}
