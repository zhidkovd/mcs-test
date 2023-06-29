resource "vkcs_vpnaas_service" "service" {
  router_id = "${vkcs_networking_router.router.id}"
}

resource "vkcs_vpnaas_ipsec_policy" "policy_1" {
	name = "ipsec-policy"
}

resource "vkcs_vpnaas_ike_policy" "policy_2" {
  name = "ike-policy"
}

resource "vkcs_vpnaas_endpoint_group" "group_1" {
	name = "remote_endpoint"
	type = "cidr"
	endpoints = ["192.168.10.0/24"]
}
resource "vkcs_vpnaas_endpoint_group" "group_2" {
	name = "local_endpoint"
	type = "subnet"
	endpoints = [ "${vkcs_networking_subnet.subnetwork.id}" ]
}

resource "vkcs_vpnaas_site_connection" "connection" {
	name = "connection"
	ikepolicy_id = "${vkcs_vpnaas_ike_policy.policy_2.id}"
	ipsecpolicy_id = "${vkcs_vpnaas_ipsec_policy.policy_1.id}"
	vpnservice_id = "${vkcs_vpnaas_service.service.id}"
	psk = "P@ssw0rdP@ssw0rd"
	peer_address = "109.120.190.41"
	peer_id = "109.120.190.41"
	local_ep_group_id = "${vkcs_vpnaas_endpoint_group.group_2.id}"
	peer_ep_group_id = "${vkcs_vpnaas_endpoint_group.group_1.id}"
	dpd {
		action   = "restart"
		timeout  = 42
		interval = 21
	}
	depends_on = ["vkcs_networking_router_interface.db"]
}
