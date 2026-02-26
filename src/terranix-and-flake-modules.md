# terranix and flake modules

[flake-parts][flake-parts] is a framework for Nix flakes built on the module
system. As flake.parts puts it:

> flakes are configuration, and the module system lets you refactor that configuration
> into reusable pieces — reducing the proliferation of custom Nix glue code.

terranix ships a [flake-module][flake-module] that plugs into flake-parts. It
gives you a declarative, options-based way to use terranix instead of calling
`lib.terranixConfiguration` manually and wiring up your own flake outputs.

[flake-parts]: https://flake.parts
[flake-module]: https://github.com/terranix/terranix/blob/main/flake-module.nix

## Before and after

Without the flake-module, you call `lib.terranixConfiguration` yourself and
manually assemble `packages`, `apps`, and `devShells`. The [Getting started
with flakes](./getting-started-with-flakes.md) page shows what this looks like.

With the flake-module, you declare `terranixConfigurations` and everything else
is generated for you:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.terranix.flakeModules.default ];
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, ... }: {
        terranix.terranixConfigurations.myproject = {
          modules = [ ./config.nix ];
        };
      };
    };
}
```

This single declaration auto-generates `packages`, `apps`, and `devShells` for
each configuration.

## What you get

### packages

Each `terranixConfigurations.<name>` becomes a package. The package is an
`apply` script that runs `terraform init && terraform apply`.

```shell
nix run .#myproject
```

### Passthru scripts

The apply derivation carries `init`, `plan`, `apply`, and `destroy` as passthru
attributes. This means you can run each command directly:

```shell
nix run .#myproject          # apply
nix run .#myproject.plan     # plan
nix run .#myproject.destroy  # destroy
nix run .#myproject.init     # init only
```

### devShells

Run `nix develop .#myproject` to get an interactive shell with `apply`, `plan`,
`destroy`, `init`, and the terraform/opentofu wrapper all on your `PATH`.

```shell
$ nix develop .#myproject
$ plan
$ apply
$ destroy
```

Set `terranix.exportDevShells = false` if you don't want these.

### Terraform/OpenTofu wrapper

Each script automatically creates the working directory, symlinks the generated
`config.tf.json`, and runs the appropriate terraform commands.

See [Customizing the Terraform binary](terraform-wrapper.md) for how to use
OpenTofu, bundle provider plugins, or inject secrets.

## Configuration options

Each entry under `terranix.terranixConfigurations` accepts:

| Option                                | Description                                                                |
| ------------------------------------- | -------------------------------------------------------------------------- |
| `modules`                             | List of terranix modules to evaluate                                       |
| `extraArgs`                           | Extra arguments passed to module evaluation (as `specialArgs`)             |
| `workdir`                             | Working directory for terraform state (defaults to the configuration name) |
| `terraformWrapper.package`            | Terraform or OpenTofu package (default: `pkgs.terraform`)                  |
| `terraformWrapper.extraRuntimeInputs` | Additional packages available during terraform runs                        |
| `terraformWrapper.prefixText`         | Shell commands to run before each terraform invocation                     |
| `terraformWrapper.suffixText`         | Shell commands to run after each terraform invocation                      |

## Multiple configurations

You can define more than one configuration in the same flake. Each gets its own
package, scripts, and devShell:

```nix
perSystem = { pkgs, ... }: {
  terranix.terranixConfigurations.staging = {
    modules = [ ./staging.nix ];
  };
  terranix.terranixConfigurations.production = {
    modules = [ ./production.nix ];
    terraformWrapper.package = pkgs.opentofu;
  };
};
```

```shell
nix run .#staging          # apply staging
nix run .#production.plan  # plan production
nix develop .#staging      # interactive shell for staging
```
