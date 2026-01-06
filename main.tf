locals {
  public_info_read = <<-EOF
      timeout -k $((TIMEOUT + 2)) $TIMEOUT bash -c '
        set -o pipefail
        if ip=$(curl -sk --connect-timeout $TIMEOUT $PUBLIC_IP_DISCOVERY_ENDPOINT_IFCONFIG_ME 2>/dev/null); then
          echo '{"public_ip": "'$ip'","cidr_block": "'$ip/32'","source":"'$PUBLIC_IP_DISCOVERY_ENDPOINT_IFCONFIG_ME'"}'
        elif ip=$(curl -sk --connect-timeout $TIMEOUT $PUBLIC_IP_DISCOVERY_ENDPOINT_IPINFO_IO 2>/dev/null | jq -r .ip); then
          echo '{"public_ip": "'$ip'","cidr_block": "'$ip/32'","source":"'$PUBLIC_IP_DISCOVERY_ENDPOINT_IPINFO_IO'"}'
        else
          echo '{"public_ip": "0.0.0.0","cidr_block": "0.0.0.0/32","source":null}'
        fi
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
    PUBLIC_IP_DISCOVERY_ENDPOINT_IFCONFIG_ME = "https://ifconfig.me"
    PUBLIC_IP_DISCOVERY_ENDPOINT_IPINFO_IO   = "https://ipinfo.io"
    TIMEOUT                                  = "10"
  }
}
