# What is terranix?

terranix is a [Nix][nix]-based infrastructure-as-code tool that combines the
providers of Terraform and the lazy, functional configuration of [NixOS][nixos].
terranix works as an alternative to HCL by generating [Terraform JSON][tf-json]
that can then be applied using the same providers.

[nix]: https://serokell.io/blog/what-is-nix
[nixos]: https://nixos.org/
[tf-json]: https://www.terraform.io/docs/configuration/syntax-json.html

## Features

- terranix is similar to Terraform: you can use the
  [Terraform reference material](https://www.terraform.io/docs/providers/index.html)
- The full power of the Nix language
- The full power of the NixOS module system
- The full power of all the nixpkgs tooling (fetchgit,fetchurl,writers, ...)
- Documentation generation from `config.nix` as json or man page.

## Community

- Write issues on [GitHub](https://github.com/terranix/terranix/issues)
- Create pull requests on [GitHub](https://github.com/terranix/terranix/pulls)
