# Terraform Variables
#
# Secrets can be supplied here but it's safer to pass vars inline when applying:
# terraform apply -var 'password=PASSWORD' -var 'new_password=NEWPASS'

# Connection parameters
raspi_ip = "192.168.0.107"
username = "pi"
password = ""

# Config parameters
new_hostname = ""
new_password = ""
timezone     = "America/New_York"

# Network config parameters
static_ip_and_mask = "192.168.0.107/24"
static_router      = "192.168.0.1"
static_dns         = "192.168.0.1."
