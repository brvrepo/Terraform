resource "oci_core_instance" "TFInstance" {
  count               = "${var.NumInstances}"
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TFInstance${count.index}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${var.subnet_id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "tfexampleinstance${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"

    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

    #remote exec stuff
  connection {
    type        = "ssh"
    host        = "${self.public_ip}"
    user        = "opc"
    private_key = "${file(var.ssh_private_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-6.0.0-1.x86_64.rpm",
      "wget https://objectstorage.us-ashburn-1.oraclecloud.com/n/oracle-cloudnative/b/Grafanaplugin/o/plugin.tar",
      "sudo systemctl start grafana-server",
      "sudo mkdir -p /var/lib/grafana/plugins/oci && sudo tar -C /var/lib/grafana/plugins/oci -xvf plugin.tar",
      "sudo systemctl restart grafana-server"
    ]
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.BootStrapFile))}"
  }
}
