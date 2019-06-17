module "dynamic-group" "group" {
  source = "./dynamic_group"
  compartment_ocid ="${var.compartment_ocid}"
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
  dynamic_group_name = "${var.dynamic_group_name}"
}


module "policy" {
  source = "./policy"
  compartment_ocid ="${var.compartment_ocid}"
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
  dynamic_group_name = "${var.dynamic_group_name}"
  dynamic_group_id = "${module.dynamic-group.id}"
}

module "compute" {
  source = "./compute"
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${var.ssh_public_key}"
  ssh_private_key = "${var.ssh_private_key}"
  subnet_id = "${var.subnet_id}"
  availability_domain= "${var.availability_domain}"
}
