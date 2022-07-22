resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "ansible_deploy" {
  provisioner "local-exec" {
    command = "sudo bash -c '../ansible_run.sh inventory-${terraform.workspace}' "
  }

  depends_on = [
    null_resource.wait
  ]
}
