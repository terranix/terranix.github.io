# Getting started with flakes

[Nix flakes](https://nixos.wiki/wiki/Flakes)
make dependency management of modules and packages much easier.

## Quick start from template

The fastest way to get started is with the terranix flake template:

```shell
nix flake init --template github:terranix/terranix-examples
```

This creates a `flake.nix` and `config.nix` you can build right away.

## A minimal flake.nix

Extending [Getting started](./getting-started.md), this minimal flake defines your terranix resources in `config.nix`:

```nix
{
  inputs = {
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { terranix, ... }:
    let
      system = "x86_64-linux";
    in
    {
      defaultPackage.${system} = terranix.lib.terranixConfiguration {
        inherit system;
        modules = [ ./config.nix ];
      };
    };
}
```

## nix build

Instead of `terranix config.nix > config.tf.json`, you can run `nix build -o config.tf.json`:

```
nix build -o config.tf.json
tofu init
tofu apply
```

Use terraform or tofu if you installed either of them plainly.

## nix run

You can create Nix flake _apps_ that let you run:

- `nix run`
- `nix run .#apply`
- `nix run .#destroy`

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, terranix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      terraform = pkgs.terraform;
      terraformConfiguration = terranix.lib.terranixConfiguration {
        inherit system;
        modules = [ ./config.nix ];
      };
    in
    {
      # nix run ".#apply"
      apps.${system} = {
        apply = {
          type = "app";
          program = toString (pkgs.writers.writeBash "apply" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration} config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform apply
          '');
        };

        # nix run ".#destroy"
        destroy = {
          type = "app";
          program = toString (pkgs.writers.writeBash "destroy" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration} config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform destroy
          '');
        };
      };

      # nix run
      defaultApp.${system} = self.apps.${system}.apply;
    };
}
```

## Writing terranix modules

You can scaffold a new terranix module with:

```shell
nix flake init --template "github:terranix/terranix-examples#module"
```

A terranix module flake should provide the following outputs:

- `terranixModules.<name>` — individual modules
- `terranixModule` — all `terranixModules` combined

The function `lib.terranixOptions` can render an `options.json` for your module,
which is useful for generating documentation. See the
[terranix-module-github](https://github.com/terranix/terranix-module-github)
repository for an example.

For more on the module system itself, see the [Modules](modules.md) page.

As a next step, read [terranix and flake modules](./terranix-and-flake-modules.md)
to use flake-parts to manage terranix configurations declaratively
