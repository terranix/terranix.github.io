# terranix vs. HCL

HCL is the language of Terraform. It has its flaws. That is why terranix was born.

This page explains some general differences between the two.

## Declarations

In HCL you would do something like this:

```hcl
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
```

Which is the equivalent for the following in **terranix**:

```nix
resource."aws_instance"."web" = {
  ami = "\${data.aws_ami.ubuntu.id}";
  instance_type = "t2.micro";
  tags = {
    Name = "HelloWorld";
  };
}
```

So while HCL has declarations, Nix only has [attribute sets][attrset].

[attrset]: https://nix.dev/manual/nix/2.18/language/values.html?highlight=attribute+set#attribute-set

## References

In HCL you can only reference variable outputs.

But in terranix, because it is Nix, you can basically reference anything.

For example if you have a resource and you want to reuse its parameters:

```nix
resource.hcloud_server.myserver = {
  name = "node1";
  image = "debian-9";
  server_type = "cx11";
};
```

You can reference parameters the terraform way.

```nix
resource.hcloud_server.myotherserver = {
  name = "node2";
  image = "\${ hcloud_server.myserver.image }";
  server_type = "\${ hcloud_server.myserver.server_type }";
};
```

Or the terranix way:

```nix
{ config, ... }:
resource.hcloud_server.myotherotherserver = {
  name = "node3";
  image = config.resource.hcloud_server.myserver.image;
  server_type = config.resource.hcloud_server.myserver.server_type;
};
```

Or the terranix pro way:

```nix
{ config, ... }:
resource.hcloud_server.myotherotherotherserver = {
  name = "node4";
  inherit (config.resource.hlcoud_server) image server_type;
};
```

> terranix references being evaluated when generating the json file.
> terraform references being calculated when running terraform.

## multi line strings

In terraform you can create
[multi line strings](https://www.terraform.io/docs/configuration/expressions.html#string-literals)
using the [`heredoc`](https://en.wikipedia.org/wiki/Here_document) style.

```hcl
variable "multiline" {
  description = <<EOT
Description for the multi line variable.
The indentation here is not wrong.
The terminating word must be on a new line without any indentation.
EOT
}
```

This won't work in terranix.
In terranix you have to use the nix way of multi line strings.

```nix
variable.multiline.description = ''
  Description for the multi line variable.
  The indentation here is not wrong.
  All spaces in front of the text block will be removed by terranix.
'';
```

## escaping expressions

The form `${expression}` is used by terranix and terraform.
So if you want to use a terraform expression in terranix,
you have to escape it.
Escaping differs for multi and single line strings.

### escaping in single line strings

In a single line strings, you escape via `\${expression}`.
For example :

```nix
variable.hcloud_token = {};
provider.hcloud.token = "\${ var.hcloud_token }";
```

You can avoid escaping `$` with the `tfRef` function:

```nix
{ lib, ... }:
variable.hcloud_token = {};
provider.hcloud.token = lib.tfRef "var.hcloud_token";
```

### escaping in multi line strings

In multi line strings, you escape via `''${expression}`.
For example :

```nix
resource.local_file.sshConfig = {
  filename = "./ssh-config";
  content = ''
    Host ''${ hcloud_server.terranix_test.ipv4_address }
    IdentityFile ./sshkey
  '';
};
```
