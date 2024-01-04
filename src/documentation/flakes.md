terranix is available via the [nix flakes](https://nixos.wiki/wiki/Flakes).

<div class="warning">
If you don’t know what <a href="https://nixos.org">NixOS</a> or
<a href="https://terraform.io">Terraform</a> is, have a look at 
<a href="what-is-terranix.html">what terranix is</a>.
</div>

## Using terranix via flakes

You can check out an example using the `template` feature of nix flakes.

```shell
nix flake init --template github:terranix/terranix-examples
```

## Using terranixConfiguration

You can render the `config.tf.json` using the `lib.terranixConfiguration`.

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

### Import terranix modules

You can include a terranix module like a `nixosModule` with flakes.

```nix
inputs.github.url = "github:terranix/terranix-module-github";
...
terraformConfiguration = terranix.lib.terranixConfiguration{
  inherit system;
  modules = [
    github.terranixModule
    ./config.nix
  ];
};
```

## Writing terranix modules

If you want to create your own terranix module
you can start with the module template from `terranix-examples`

```shell
nix flake init --template "github:terranix/terranix-examples#module"
```

terranix modules should obey the following output structure:

- `terranixModules.<name>`
- `terranixModule` : contains all `terranixModules` combined of the given flake.

### using terranixOptions

It's good practise to provide a `options.json` and `options.md` on the top of your
Repository.
The function `lib.terranixOptions` renders a `options.json` which contains a lot of information,
which can be easily queried by [jq](https://stedolan.github.io/jq/manual/).

For example you can pull the options.json of the
[terranix github module](https://github.com/terranix/terranix-module-github)

```shell
 curl https://raw.githubusercontent.com/terranix/terranix-module-github/main/options.json | \
   jq 'to_entries | .[] |
     {
       label: .key,
       type: .value.type,
       description: .value.description,
       example: .value.example | tojson,
       default: .value.default | tojson,
       defined: .value.declarations[0].path,
       url: .value.declarations[0].url,
     }' | \
   jq  -s '{ options: . }'
```

## Using terranixConfigurationAst or terranixOptionsAst

If you want to get deeper insides in the output of `terranixConfiguration` or `terranixOptions`
you can make use of the `terranixConfigurationAst` or the `terranixOptionsAst` function.

Here is a simple example of using `nix repl` and `terranixConfigurationAst`.

```nix
nix-repl> terranixAst = (builtins.getFlake "github:terranix/terranix").lib.terranixConfigurationAst
nix-repl> terranix = terranixAst {
  system = "x86_64-linux";
  modules = [{
    resource.local_file = {
      content = "yolo";
      filename = "./example";
    };
  }];
}
nix-repl> terranix.config.resource.local_file
{ content = "yolo"; filename = "./example"; }

```
