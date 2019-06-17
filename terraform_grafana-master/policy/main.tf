provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

resource "oci_identity_policy" "test_policy" {
    compartment_id = "${var.tenancy_ocid}"
    description = "user management"
    name = "grafana_policy"
    statements = ["allow dynamicgroup ${var.dynamic_group_name} to read metrics in tenancy", "allow dynamicgroup ${var.dynamic_group_name} to read compartments in tenancy"]
    freeform_tags = {"groupid"= "${var.dynamic_group_id}"}
}
