Let's have a quick overview on how you would use terranix.

If you look for working examples check out
[examples folder at github](https://github.com/terranix/terranix-examples).

<div class="warning">
If you don’t know what <a href="https://nixos.org">NixOS</a> or <a
href="https://terraform.io">Terraform</a> is, have a look at <a
href="what-is-terranix.html">what terranix is</a>.
</div>

## shell.nix

A convenient way is to create a `shell.nix`
which holds your terranix and terraform setup.

```nix
{ pkgs ? import <nixpkgs> { } }:
let
  hcloud_api_token = "`${pkgs.pass}/bin/pass development/hetzner.com/api-token`";

  terraform = pkgs.writers.writeBashBin "terraform" ''
    export TF_VAR_hcloud_api_token=${hcloud_api_token}
    ${pkgs.terraform}/bin/terraform "$@"
  '';

in pkgs.mkShell {
  buildInputs = [ pkgs.terranix terraform ];
}
```

## config.nix

Create a `config.nix` for example

```nix
{ ... }:
{
  resource.hcloud_server.nginx = {
    name = "terranix.nginx";
    image  = "debian-10";
    server_type = "cx11";
    backups = false;
  };
  resource.hcloud_server.test = {
    name = "terranix.test";
    image  = "debian-9";
    server_type = "cx11";
    backups = true;
  };
}
```

## Create a Server

Next, lets generate the terraform configuration in json format
and run `terraform apply`
to let terraform do it's magic.

```shell
terranix config.nix > config.tf.json
terraform init && terraform apply
```

## Destroy a Server

cleaning everything up is the job of terraform.

```shell
terraform destroy
```
