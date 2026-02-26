# `evalTerranixConfiguration`

`lib.evalTerranixConfiguration` evaluates terranix modules and returns
the Terraform configuration as a Nix attrset, without writing anything
to the Nix store.

```nix
terranix.lib.evalTerranixConfiguration {
  system = "x86_64-linux";   # or set pkgs directly
  modules = [ ./config.nix ];
  extraArgs = { };            # extra arguments passed to modules
  strip_nulls = true;         # remove null values from the output
}
```

The return value is an attrset containing `config`, like so:

```nix
{
  config = {
    resource = { ... };
    provider = { ... };
    # ...
  };
}
```

## Exploring in nix repl

The primary use case is inspecting your Terraform configuration interactively.

For example, with `nix repl` you can produce a terranix configuration like so:

```
$ nix repl
nix-repl> terranix = builtins.getFlake "github:terranix/terranix"

nix-repl> result = terranix.lib.evalTerranixConfiguration {
            system = "x86_64-linux";
            modules = [{
              resource.local_file.example = {
                content = "hello";
                filename = "./example.txt";
              };
            }];
          }

nix-repl> result.config.resource.local_file.example
{ content = "hello"; filename = "./example.txt"; }
```

You can also load modules from files:

```
nix-repl> result = terranix.lib.evalTerranixConfiguration {
            system = "x86_64-linux";
            modules = [ ./config.nix ];
          }

nix-repl> builtins.attrNames result.config
[ "provider" "resource" ]
```

## Accessing config from `terranixConfiguration`

`lib.terranixConfiguration` produces a `config.tf.json` store derivation.
It now also carries the evaluated configuration as a passthru attribute,
so you can access the attrset without a separate call:

```nix
let
  tfConfig = terranix.lib.terranixConfiguration {
    inherit system;
    modules = [ ./config.nix ];
  };
in
{
  # tfConfig is the config.tf.json derivation
  # tfConfig.config is the Terraform attrset
  inherit (tfConfig) config;
}
```

This is convenient when your flake already uses `terranixConfiguration`
and you want to inspect or reuse the configuration in other Nix expressions.

## Migrating from terranixConfigurationAst

`lib.terranixConfigurationAst` is deprecated. Replace calls with `lib.evalTerranixConfiguration`:

```nix
# Old
terranix.lib.terranixConfigurationAst { system = "x86_64-linux"; modules = [ ./config.nix ]; }

# New
terranix.lib.evalTerranixConfiguration { system = "x86_64-linux"; modules = [ ./config.nix ]; }
```

The return value is the same: `{ config = { ... }; }`.
