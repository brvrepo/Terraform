provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

resource "oci_identity_dynamic_group" "test_dynamic_group" {
    compartment_id = "${var.tenancy_ocid}"
    description = "Allow Grafana VM to read metrics"
    matching_rule = "ANY {instance.compartment.id = '${var.compartment_ocid}'}"
    name = "${var.dynamic_group_name}"
}

output "id" {
  value = "${oci_identity_dynamic_group.test_dynamic_group.id}"
}
