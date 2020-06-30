resource "null_resource" "ansible_playbook" {
  count      = var.options.ansible_execution ? 1 : 0
  depends_on = [module.hdb_node.dbnode-data-disk-att, module.jumpbox.prepare-rti, module.jumpbox.vm-windows]
  connection {
    type        = "ssh"
    host        = module.jumpbox.rti-info.public_ip_address
    user        = module.jumpbox.rti-info.authentication.username
    private_key = module.jumpbox.rti-info.authentication.type == "key" ? file(var.sshkey.path_to_private_key) : null
    password    = lookup(module.jumpbox.rti-info.authentication, "password", null)
    timeout     = var.ssh-timeout
  }

  # Run Ansible Playbook on jumpbox if ansible_execution set to true
  provisioner "remote-exec" {
    inline = [
      # Registers the current deployment state with Azure's Metadata Service (IMDS)
      "curl -i -H \"Metadata: \"true\"\" -H \"user-agent: SAP AutoDeploy/${var.auto-deploy-version}; scenario=${var.scenario}; deploy-status=Terraform_finished\" http://169.254.169.254/metadata/instance?api-version=${var.api-version}",
      "export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES",
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "source ~/export-clustering-sp-details.sh",
      "ansible-playbook -i hosts ~/sap-hana/deploy/v2/ansible/sap_playbook.yml"
    ]
  }
}
