# terranix.org website

This repository contains the source code for [terranix.org](https://terranix.org) / [terranix.github.io](https://terranix.github.io)
rendered by [mdBook](https://github.com/rust-lang/mdBook).

## How to preview

```sh
# Serve dynamic preview on `localhost:3000`
nix run .#serve

# Check that website builds and that .nix files are formatted
nix run .#check

# Produce static website content in `book/`
nix run .#build
```
