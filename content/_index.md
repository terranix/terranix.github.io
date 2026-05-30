+++
title = 'terranix'
+++

{{< hero
  title="infrastructure as nix code"
  lead="terranix is a Nix-based infrastructure-as-code tool that combines the providers of <a href=\"https://www.terraform.io/\">Terraform</a> (or <a href=\"https://opentofu.org/\">OpenTofu</a>) and the lazy, functional configuration of <a href=\"https://nixos.org/\">NixOS</a>. terranix works as an alternative to <a href=\"https://github.com/hashicorp/hcl\">HCL</a> by generating <a href=\"https://developer.hashicorp.com/terraform/language/syntax/json\">Terraform JSON</a> that can then be applied using the same providers."
  ctaPrimary="Getting started|/docs/getting-started/"
  ctaSecondary="View on GitHub|https://github.com/terranix/terranix" >}}

{{< codetabs >}}

{{< features >}}
{{< feature title="Full Nix language" >}}Use let-bindings, imports, conditionals, and module composition with the same language you already use for NixOS.{{< /feature >}}
{{< feature title="NixOS module system" >}}Type-checked configuration with sensible defaults, overrides, and reusable modules.{{< /feature >}}
{{< feature title="nixpkgs ecosystem" >}}Tap into `fetchgit`, `fetchurl`, `writers`, and pin Terraform / OpenTofu versions and providers reproducibly.{{< /feature >}}
{{< feature title="Documentation generator" >}}Generate JSON or man-page documentation straight from your `config.nix` module options.{{< /feature >}}
{{< /features >}}
