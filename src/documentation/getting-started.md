# Getting Started

Let's have a quick overview on how you could use terranix.

If you look for working examples, check out [examples at GitHub](https://github.com/terranix/terranix-examples).

If you don’t know what [Terraform][tf] is, have a look at
<a href="what-is-terranix.html">What is Terraform / OpenTofu?</a>

This guide assumes you have Nix installed. If you don't have, check [Determinate Nix installer][det-nix].

[tf]: https://terraform.io
[det-nix]: https://github.com/DeterminateSystems/nix-installer#determinate-nix-installer

## shell.nix

One way to get started is to create a `shell.nix`
that holds your terranix and terraform setup.

```nix
{ pkgs ? import <nixpkgs> { } }:
let
  hcloud_token = "...";
  tf = pkgs.writers.writeBashBin "tf" ''
    export TF_VAR_hcloud_token="${hcloud_token}"
    ${pkgs.opentofu}/bin/tofu "$@"
  '';
in pkgs.mkShell {
  buildInputs = [ pkgs.terranix tf ];
}
```

This installs both terranix and opentofu.

It also creates a `tf` CLI wrapper that embeds an API key.

You want to avoid putting the API token(s) directly into shell.nix.

But that can be done in a number of ways.

## config.nix

Create a `config.nix` that holds your resource definitions.

This example is adapted from the pure HCL example in [What is Terraform / OpenTofu?](./what-is-terranix.md):

```nix
{ lib, ... }:
{
  # Control the API token with a variable to hide it from version control
  variable.hcloud_token = {
    sensitive = true;
  };

  # Configure the Hetzner Cloud Provider
  provider.hcloud = {
    token = "\${var.hcloud_token}";
  };

  resource.hcloud_server.my_server = {
    image       = "debian-12";
    name        = "myserver.example.org";
    server_type = "cx22";
    datacenter  = "nbg1-dc3";
    ssh_keys    = [ "\${hcloud_ssh_key.my_key.id}" ];
    public_net  = {
      ipv4_enabled = true;
      ipv6_enabled = true;
    };
  };

  resource.hcloud_ssh_key.my_key = {
    name       = "my-ssh-key";
    public_key = ''''${file("~/.ssh/id_ed25519.pub")}'';
  };
}
```

<div class="warning">
<b>Escaping string interpolation:</b> Since both Terraform and Nix use the same string 
interpolation syntax, <code>${}</code>, it is necessary to escape Terraform literal
<code>${}</code> references so that they don't get picked up by Nix. This happens in two
different ways in the example above:

- `"\${var.hcloud_token}"`: Escaping here is necessary; `${var.hcloud_token}` is a Terraform string that gets interpreted when running `plan` or `apply`. If it were not escaped, it would result in a "variable not found" error in Nix, since `var` is not a Nix variable.

  It could also have been written as `lib.tf.ref "var.hcloud_token"`

- `''''${file("~/.ssh/id_ed25519.pub")}''`: Because the Terraform expression contains double quotes, a Nix multi-line string is used to avoid also escaping the double quotes. Escaping a Nix `${...}` expression inside a multi-line string looks like `''${...}`, i.e. instead of a backslash, two single quotes escape the string interpolation.

  It could also have been written as `"\${file(\"~/.ssh/id_ed25519.pub\")}"`.

The resulting Terraform JSON contains strings that contain these string interpolations.

</div>

## Create a Server

Convert `config.nix` into Terraform JSON, `init` the Terraform provider, and `apply` the configuration:

```shell
terranix config.nix > config.tf.json
tf init
tf apply
```

Note that the `tf` binary assumes the wrapper from shell.nix.

Use `terraform` or `tofu` if you installed either of them plainly.

## Destroy a Server

cleaning everything up is the job of terraform.

```shell
tf destroy
```
