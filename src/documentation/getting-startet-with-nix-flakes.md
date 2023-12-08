[nix flakes](https://nixos.wiki/wiki/Flakes)
make dependency management of modules and packages much easier.

Deeper look at terranix and nix flakes is done in the
[flake chapter](documentation/flakes.md)

## nix build

Here is a minimal `flake.nix`

```nix
{
  inputs.terranix.url = "github:terranix/terranix";
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

You can run `nix build -o config.tf.json`, which should create a `config.tf.json`
in your current folder.
Now you are ready to run `terraform`.

## nix run

Of course, you can use `apps` to do everything at once.

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.terranix.url = "github:terranix/terranix";
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

This provides you with the commands `nix run`, `nix run ".#apply"` and `nix run ".#destroy"`.
