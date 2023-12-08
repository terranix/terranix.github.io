You are new to terraform, but you are fit in nix?
This is the place for you to start.

## What is Terraform?

[Terraform](https://terraform.io) is a tool to interact with APIs via declarative files.
Also known as "infrastructure as code".
Instead of write imperative scripts, you
define the setup you like to have and terraform will make it happen.

### What is config.tf.json?

`config.tf.json` or `config.tf` is the file that contains the
setup descriptions to be realized behind one or multiple APIs.
The majority of your work will be to create these files.

### What are Providers?

Providers are the **thing** that enables terraform to talk to APIs.
A huge list of providers is available on
[the Terraform website](https://www.terraform.io/docs/providers/index.html).

#### Definition of multiple identical providers

Here is an example of how you would [define multiple providers of the same kind](https://www.terraform.io/language/syntax/json#provider-blocks)

```nix
provider.aws = [{
  region = "us-east-1";
} {
  alias = "eu";
  region = "eu-central-1";
}];
```

### What is Terraform State?

Terraform is not capable of seeing the state behind APIs,
because APIs never share all information.
This is why terraform creates a state file
on every run to provide information for the next run.

<div class="warning">
It is not always clear what ends up in this state file,
so handle secrets always with care!
</div>

## What is terranix?

terranix is a tool that enables you to render the `config.tf.json` file.
It uses the NixOS module system and gives you tools like `terranix-doc-man` and `terranix-doc-json`
to generate documentation of terranix modules.
