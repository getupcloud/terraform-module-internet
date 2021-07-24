locals {
  public_info_read = <<-EOF
      timeout -k $((TIMEOUT + 2)) $TIMEOUT bash -c '
        ip=$(curl -sk --connect-timeout $TIMEOUT $PUBLIC_IP_DISCOVERY_ENDPOINT 2>/dev/null || echo "")
        cidr=$${ip:+$ip/32}
        cat <<-EOD
        {
          "public_ip": "$ip",
          "cidr_block": "$cidr"
        }
EOD
    '
    EOF
}

resource "shell_script" "public_info" {
  lifecycle_commands {
    create = local.public_info_read
    read   = local.public_info_read
    update = local.public_info_read
    delete = "echo {}"
  }

  environment = {
    PUBLIC_IP_DISCOVERY_ENDPOINT = "https://ifconfig.me"
    TIMEOUT                      = "10"
  }
}
