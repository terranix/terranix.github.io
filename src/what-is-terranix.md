# What is Terraform / OpenTofu?

<div class="warning">
This page explains Terraform enough to motivate and explain terranix easily. You may already be using Terraform and Nix separately and wonder exactly how one combines the two. Or either one of the two may be new to you.

You can skip this section if all of these words make perfect sense:

- HCL
- _provider_
- _tfstate_
</div>

[Terraform][tf] is a declarative infrastructure-as-code tool.

[OpenTofu][opentofu] is the open-source fork of Terraform.

Instead of writing imperative scripts that get executed to create or configure infrastructure
resources, like you would with [Ansible][ansible], you describe the resources you want to exist
and their configuration, but not the steps to get there. Using the _provider_ of a given service
or platform, the accumulated _tfstate_, the Terraform _`plan`_ and _`apply`_ commands, resources
are created, modified, or deleted to reflect the description.

[ansible]: https://docs.ansible.com/

You have a text file under version control that closely reflects the state of:

- hardware
- virtual machines
- VPC networks and policies
- GitHub account policies
- DNS records
- _etc._

## Terraform vs. OpenTofu

The Open Source fork of Terraform is [OpenTofu][opentofu].

OpenTofu was [announced in Sept. 2023][opentofu-announce] after Terraform switched to a Business Source License (BSL).

[tf]: https://terraform.io
[opentofu]: https://www.opentofu.org/
[opentofu-announce]: https://www.linuxfoundation.org/press/announcing-opentofu

Both are available in nixpkgs and are compatible with terranix, but Terraform requires allowing
[unfree software][nixos-unfree] using e.g. `nixpkgs.config.allowUnfree = true;` so it's slightly
easier to create working examples with OpenTofu.

[nixos-unfree]: https://nixos.wiki/wiki/Unfree_Software

## HCL vs. Terraform JSON

Terraform comes with two syntaxes, [HCL][hashi-hcl] and [Terraform JSON][hashi-json].

HCL compiles to Terraform JSON.

**The main role of terranix is to compile Nix to Terraform JSON.**

[hashi-hcl]: https://developer.hashicorp.com/terraform/language/syntax/configuration
[hashi-json]: https://developer.hashicorp.com/terraform/language/syntax/json

Here is a complete [resource definition][hcloud-server-docs] for a Hetzner VPS one could store to `myserver.tf`:

[hcloud-server-docs]: https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server.html

```hcl
# Control the API token with a variable to hide it from version control
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

resource "hcloud_server" "myserver" {
  image       = "debian-13"
  name        = "myserver.example.org"
  server_type = "cx23"
  location    = "nbg1"
  ssh_keys    = [ hcloud_ssh_key.my_key.id ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_ssh_key" "my_key" {
  name       = "my-ssh-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}
```

The same definition using Terraform JSON looks like the following.

One could store this to `myserver.tf.json`:

```json
{
  "variable": {
    "hcloud_token": {}
  },
  "provider": {
    "hcloud": {
      "token": "${var.hcloud_token}"
    }
  },
  "resource": {
    "hcloud_server": {
      "myserver": {
        "image": "debian-12",
        "name": "myserver.example.org",
        "server_type": "cx22",
        "location": "nbg1",
        "ssh_keys": ["${hcloud_ssh_key.my_key.id}"],
        "public_net": {
          "ipv4_enabled": true,
          "ipv6_enabled": true
        }
      }
    },
    "hcloud_ssh_key": {
      "my_key": {
        "name": "my-ssh-key",
        "public_key": "${file(\"~/.ssh/id_ed25519.pub\")}"
      }
    }
  }
}
```

## What is myserver.tf / myserver.tf.json?

`myserver.tf` or `myserver.tf.json` is the file that contains the setup descriptions to be realized
behind one or multiple APIs. The majority of your work will be to create and maintain these files.

Besides a declarative description of your resource, Terraform also requires:

- the `terraform` (or `opentofu`) CLI for running `plan` or `apply` commands
- the _provider_ software to be installed for each relevant service or platform
- an API token for each relevant service or platform
- a _tfstate_

## What are _providers_?

Providers are plugins that enables Terraform to interact with external services and platforms,
like cloud or SaaS providers, through their APIs, translating Terraform's resource definitions
into API calls.

A huge list of providers is available on [Terraform.io][tf].

Here is an example of how you would [define multiple providers of the same kind][tf-provider-blocks]

[tf-provider-blocks]: https://www.terraform.io/language/syntax/json#provider-blocks

```nix
provider.aws = [
  { region = "us-east-1"; }
  { region = "eu-central-1"; alias = "eu"; }
];
```

## What is Terraform state?

Terraform state, or _tfstate_, keeps track of the resources that Terraform has created and is currently managing.

Terraform is not capable of seeing the state behind APIs, because APIs never share all information.
This is why Terraform creates a state file on every run to provide information for the next run.

This means a part of managing resources with Terraform is to store the _tfstate_ and keep it in sync.

<div class="warning">
It is not always clear what ends up in this state file, so always handle secrets and tfstate with care!
</div>
