# Redis config template
data "template_file" "redis" {
  template = "${file("${path.module}/files/redis.conf.tpl")}"

  vars {
    password = "${var.password}"
    number_of_dbs = "${var.number_of_dbs}"
  }
}
