resource "null_resource" "raspi_bootstrap" {
  # TODO: Do this without using a provisioner?
  # Per terraform.io/docs/provisioners/index.html this should be avoided
  connection {
    type     = "ssh"
    user     = "${var.username}"
    password = "${var.password}"
    host     = "${var.raspi_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      # Set hostname
      "sudo hostnamectl set-hostname ${var.new_hostname}",
      "echo '127.0.0.1 ${var.new_hostname}' | sudo tee -a /etc/hosts",

      # Date/time config
      "sudo timedatectl set-timezone ${var.timezone}",
      "sudo timedatectl set-ntp true",

      # Change default password
      "echo 'pi:${var.new_password}' | sudo chpasswd",

      # Install some packages
      "sudo apt-get update -y",
      "sudo apt-get install docker vim -y",

      # System and package updates
      "sudo apt-get upgrade -y",
      "sudo apt-get dist-upgrade -y",
      "sudo apt --fix-broken install -y",

      # Disable x11 GUI on boot
      "sudo update-rc.d lightdm disable",

      # Set static IP
      "echo 'interface eth0\nstatic ip_address=${var.static_ip_and_mask}\nstatic routers=${var.static_router}\nstatic domain_name_servers=${var.static_dns}' | cat >> /etc/dhcpd.conf",

      # Don't need much GPU memory -- no GUI or desktop environments
      "echo 'gpu_mem=16' | sudo tee -a /boot/config.txt",

      # Reboot
      "sudo shutdown -r +0"
    ]
  }
}
