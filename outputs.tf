output "vsi_private_ip" {
  #   value = ibm_is_instance.vsi.primary_network_interface.0.primary_ip.0.address
  value = ibm_is_instance.vsi.primary_network_attachment[0].virtual_network_interface[0].primary_ip.0.address
}

output "vsi_public_ip" {
  description = "The public Floating IP attached to the VSI"
  # value       = ibm_is_floating_ip.public_ip.0.address
  value = ibm_is_floating_ip.public_ip.address
}

output "ssh_connection_string" {
  value = "ssh -i ./rsakey.pem root@VSI-FLOATING-IP"
}

output "private_key_pem" {
  value = nonsensitive(tls_private_key.rsa_4096_key.private_key_pem)
}