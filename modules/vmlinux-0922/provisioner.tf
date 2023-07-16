resource "null_resource" "linux_provisioner" {
  count      = var.nb_count
  depends_on = [azurerm_linux_virtual_machine.vm-linux]

  provisioner "remote-exec" {
    inline = ["hostname"]
    connection {
      type        = "ssh"
      user        = var.admin-username
      private_key = file(var.private_key)
      host        = element(azurerm_linux_virtual_machine.vm-linux[*].public_ip_address, count.index + 1)
    }
  }
}