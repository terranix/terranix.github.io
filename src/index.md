Terranix is a [Nix][nix]-based infrastructure-as-code tool that combines the
providers of Terraform and the lazy, functional configuration of [NixOS][nixos]
Terranix works as a replacement for HCL by generating [Terraform JSON][tf-json].

[nix]: https://serokell.io/blog/what-is-nix
[nixos]: https://nixos.org/
[tf-json]: https://www.terraform.io/docs/configuration/syntax-json.html

## Features

- Terranix is similar to Terraform: you can use the
  [Terraform reference material](https://www.terraform.io/docs/providers/index.html)
- The full power of the Nix language
- The full power of the NixOS module system
- The full power of all the nixpkgs tooling (fetchgit,fetchurl,writers, ...)
- Documentation generation from `config.nix` as json or man page.

## Community

- Write issues on [github](https://github.com/terranix/terranix/issues)
- Create pull requests on [github](https://github.com/terranix/terranix/pulls)
