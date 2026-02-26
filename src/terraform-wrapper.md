# Customizing the Terraform binary

When using terranix with [flake-parts][getting-started-flakes], the `terraformWrapper`
option lets you control which Terraform implementation is used, bundle provider plugins,
and run custom commands around each invocation. By default it uses `pkgs.terraform`.

All options live under `terranix.terranixConfigurations.<name>.terraformWrapper`.

[getting-started-flakes]: getting-started-with-flakes.html
[flake-module]: https://github.com/terranix/terranix/blob/main/flake-module.nix

## Using OpenTofu

To use [OpenTofu](https://opentofu.org/) instead of Terraform, set the `package` option:

```nix
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
        terranix.terranixConfigurations.default = {
          terraformWrapper.package = pkgs.opentofu;
          modules = [ ./config.nix ];
        };
      };
    };
}
```

This replaces every `terraform` call in the generated scripts (`init`, `apply`, `plan`, `destroy`) with `tofu`.

## Bundling provider plugins

You can pre-bundle provider plugins so that `terraform init` doesn't need to download them:

```nix
terranix.terranixConfigurations.default = {
  terraformWrapper.package = pkgs.terraform.withPlugins (p: [
    p.aws
  ]);
  modules = [ ./config.nix ];
};
```

This works the same way for OpenTofu:

```nix
terraformWrapper.package = pkgs.opentofu.withPlugins (p: [
  p.aws
  p.null
  p.external
]);
```

## Running commands before or after Terraform

The `prefixText` and `suffixText` options inject shell commands that run before and after
every Terraform invocation. A common use case is exporting secrets:

```nix
terraformWrapper.prefixText = ''
  export TF_VAR_hcloud_token="$(cat /run/secrets/hcloud-token)"
'';
```

Or running a cleanup step afterwards:

```nix
terraformWrapper.suffixText = ''
  echo "Terraform finished, cleaning up temp files..."
  rm -f /tmp/tf-scratch-*
'';
```

## Extra runtime inputs

When your `prefixText` or `suffixText` call external programs, add them to `extraRuntimeInputs` so they're available on `PATH`:

```nix
terraformWrapper.extraRuntimeInputs = [ pkgs.jq pkgs.awscli2 ];
```

For example, to fetch a secret from AWS Secrets Manager before each run:

```nix
terranix.terranixConfigurations.default = {
  terraformWrapper = {
    extraRuntimeInputs = [ pkgs.jq pkgs.awscli2 ];
    prefixText = ''
      export TF_VAR_db_password="$(
        aws secretsmanager get-secret-value \
          --secret-id my-db-password \
          --query SecretString \
          --output text
      )"
    '';
  };
  modules = [ ./config.nix ];
};
```
