output "public_ip_address" {
  value = shell_script.public_info.output["public_ip"]
}

output "public_cidr_block" {
  value = shell_script.public_info.output["cidr_block"]
}
