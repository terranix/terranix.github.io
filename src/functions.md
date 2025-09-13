> some Functions which are useful. They are all documented at the [NixOS Website](https://nixos.org/manual/nixpkgs/stable/)

## optionalAttrs

Useful to create a resource depending on a condition.
The following example adds a bastion host only if
the variable `bastionHostEnable` is set to true.

This is just an example for illustration, such things
are better solved using
[modules](modules.md).

```nix
{ lib, ... }:
let
  bastionHostEnable = true;
in
{
  resource.aws_instance = lib.optionalAttrs bastionHostEnable {
    "bastion" = {
      ami = "ami-969ab1f6";
      instance_type = "t2.micro";
      associate_public_ip_address = true;
    };
  };
}
```

## mapping and zipping

Useful to create multiple resources, contains a lot of similar data,
out of a small set of information that differ.

- `map`
  : map a list to another list.
- `zipAttrs`
  : Merge sets of attributes and combine each attribute value in to a list.

The following Example shows how to create 3 S3-buckets with similar configuration.

```nix
{ lib, ... }:
let
  s3Buckets = [
    { name = "awesome-com"; domain = "awesome.com"; }
    { name = "awesome-org"; domain = "awesome.org"; }
    { name = "awesome-live"; domain = "awesome.live"; }
  ];
  createBucket = { name, domain }:
    {
      "${name}" = {
        bucket = name;
        acl = "public-read";

        cors_rule = {
          allowed_headers = ["*"];
          allowed_methods = ["PUT" "POST" "GET"];
          allowed_origins = [ "https://${domain}" ];
          expose_headers  = ["ETag"];
          max_age_seconds = 3000;
        };
      };
    };
in
{
  resource.aws_s3_bucket = lib.zipAttrs (lib.map createBucket s3Buckets);
}
```
