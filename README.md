# terraform-digitalocean-redis
Terraform module to build up a Redis instance in DigitalOcean

## How to use

To use it you only need to define your resource like this:

```
module "redis" {
  source  = "git::https://github.com/odarriba/terraform-digitalocean-redis.git"

  region = "fra1"
  size = "s-2vcpu-2gb"
  record_name = "redis"
  record_domain = "yourdomain.net"
  ssh_fingerprints = [
    "38:57:de:e8:bd:c9:..."
  ]
  tags_allowed_to_access = [
    "my_instance",
    "my_cluster"
  ]
  password = "YOUR_PASSWORD"
}

output "redis_ip" {
  value = "${module.redis.redis_ip}"
}
```

and after executing it you will have your Redis instance available at redis.yourdomain.net

This recipe creates:

- A Debian-based instance with redis installed from source.
- A firewasll rule that allows SSH from outside and Redis port access from
droplets with the tags specified.
- A floating IP linked to the instance.

## Configuration

By default, the configuration applied **does not save redis data to disk** as that
is our use case.

But you can change the whole configuration file by passing it's
content in a var called `custom_config`.

To see more configuration variables, you can take a look at `variables.tf` file.

## License

This software is licensed under MIT license.

To know more about it, just read LICENSE file.
