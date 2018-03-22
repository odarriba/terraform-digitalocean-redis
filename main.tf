resource "digitalocean_droplet" "redis" {
  image               = "debian-9-x64"
  name                = "${var.record_name}.${var.record_domain}"
  region              = "${var.region}"
  size                = "${var.size}"
  monitoring          = true
  private_networking  = true
  ipv6                = true
  tags                = ["redis"]
  ssh_keys            = ["${var.ssh_fingerprints}"]
  user_data           = "${file("${path.module}/files/cloudinit.yml")}"

  # Copies the redis.conf file to /etc/redis/agw_config.conf
  provisioner "file" {
    content     = "${(var.custom_template && var.custom_template != "") ? var.custom_template : data.template_file.redis.rendered}"
    destination = "/tmp/redis_config.conf"
  }
}

resource "digitalocean_firewall" "controllers" {
  name         = "redis"

  droplet_ids  = ["${digitalocean_droplet.redis.id}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "6379"
      source_tags        = "${var.tags_allowed_to_access}"
    },
  ]

  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "icmp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}

resource "digitalocean_floating_ip" "redis" {
  droplet_id = "${digitalocean_droplet.redis.id}"
  region     = "${digitalocean_droplet.redis.region}"
}

resource "digitalocean_tag" "redis" {
  name = "redis"
}

resource "digitalocean_record" "redis" {
  domain = "${var.record_domain}"
  type   = "A"
  name   = "${var.record_name}"
  value  = "${digitalocean_floating_ip.redis.ip_address}"
}

output "redis_ip" {
  value = "${digitalocean_floating_ip.redis.ip_address}"
}
