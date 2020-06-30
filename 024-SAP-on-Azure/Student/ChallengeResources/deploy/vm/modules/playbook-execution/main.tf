# This is how we call Ansible and pass in variables from Terraform.
resource null_resource "mount-disks-and-configure-hana" {
  provisioner "local-exec" {
    command = <<EOT
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES \
    AZURE_RESOURCE_GROUPS="${var.az_resource_group}" \
    ANSIBLE_HOST_KEY_CHECKING="False" \
    ansible-playbook -u ${var.vm_user} \
    --private-key '${var.sshkey_path_private}' \
    --extra-vars="{ \"url_sapcar\": \"${var.url_sap_sapcar}\", \
     \"url_hdbserver\": \"${var.url_sap_hdbserver}\", \
     \"sap_sid\": \"${var.sap_sid}\", \
     \"sap_instancenum\": \"${var.sap_instancenum}\", \
     \"pwd_os_sapadm\": \"${var.pw_os_sapadm}\", \
     \"pwd_os_sidadm\": \"${var.pw_os_sidadm}\", \
     \"pwd_db_system\": \"${var.pw_db_system}\", \
     \"pwd_hacluster\": \"${var.pw_hacluster}\", \
     \"hdb0_ip\": \"${var.private_ip_address_hdb0}\", \
     \"hdb1_ip\": \"${var.private_ip_address_hdb1}\", \
     \"use_hana2\": ${var.useHana2}, \
     \"hana1_db_mode\": \"${var.hana1_db_mode}\", \
     \"lb_frontend_ip\": \"${var.private_ip_address_lb_frontend}\", \
     \"resource_group\": \"${var.az_resource_group}\", \
     \"url_xsa_runtime\": \"${var.url_xsa_runtime}\", \
     \"url_di_core\": \"${var.url_di_core}\", \
     \"url_sapui5\": \"${var.url_sapui5}\", \
     \"url_portal_services\": \"${var.url_portal_services}\", \
     \"url_xs_services\": \"${var.url_xs_services}\", \
     \"url_shine_xsa\": \"${var.url_shine_xsa}\", \
     \"url_xsa_hrtt\": \"${var.url_xsa_hrtt}\", \
     \"url_xsa_webide\": \"${var.url_xsa_webide}\", \
     \"url_xsa_mta\": \"${var.url_xsa_mta}\", \
     \"url_sapcar_windows\": \"${var.url_sapcar_windows}\", \
     \"url_hana_studio_windows\": \"${var.url_hana_studio_windows}\", \
     \"url_timeout\": \"${var.url_timeout}\", \
     \"url_retries_cnt\": \"${var.url_retries_cnt}\", \
     \"url_retries_delay\": \"${var.url_retries_delay}\",\
     \"package_retries_cnt\": \"${var.package_retries_cnt}\", \
     \"package_retries_delay\": \"${var.package_retries_delay}\", \
     \"pwd_db_xsaadmin\": \"${var.pwd_db_xsaadmin}\", \
     \"pw_bastion_windows\": \"${var.pw_bastion_windows}\", \
     \"bastion_username_windows\": \"${var.bastion_username_windows}\", \
     \"pwd_db_tenant\": \"${var.pwd_db_tenant}\", \
     \"pwd_db_shine\": \"${var.pwd_db_shine}\", \
     \"email_shine\": \"${var.email_shine}\", \
     \"install_xsa\": ${var.install_xsa}, \
     \"install_shine\": ${var.install_shine}, \
     \"install_cockpit\": ${var.install_cockpit}, \
     \"install_webide\": ${var.install_webide}, \
     \"url_cockpit\": \"${var.url_cockpit}\" }" \
     -i '../../ansible/azure_rm.py' ${var.ansible_playbook_path}
     EOT

    environment = {
      HOSTS = "${var.vms_configured}"
    }
  }
}
