resource "null_resource" "linux_provisioner" {
  count      = var.nb_count
  depends_on = [
    azurerm_linux_virtual_machine.linux-vm
  ]

  provisioner "local-exec" {
    command = "sleep 2; ansible-playbook groupX-playbook.yml"
    connection {
      type     = "ssh"
      user     = var.admin_username
      private_key = file(var.priv_key)
      timeout     = "45"
      host        = element(azurerm_public_ip.linux-pip[*].fqdn, count.index + 1)
    }
  }
}