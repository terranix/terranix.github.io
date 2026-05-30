{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    let
      # `just --fmt` is gated behind --unstable. Wrap it so each matched justfile
      # gets passed via --justfile (treefmt would otherwise call it with multiple
      # positional args, and just would interpret the second as a recipe name).
      just-fmt = pkgs.writeShellApplication {
        name = "just-fmt";
        runtimeInputs = [ pkgs.just ];
        text = ''
          for f in "$@"; do
            just --unstable --fmt --justfile "$f"
          done
        '';
      };
    in
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs.nixfmt.enable = true;
        programs.prettier.enable = true;
        programs.taplo.enable = true;

        settings.formatter.prettier.includes = [
          "*.md"
        ];

        settings.formatter.just = {
          command = pkgs.lib.getExe just-fmt;
          includes = [
            "justfile"
            "*.justfile"
            "*.just"
          ];
        };

        settings.global.excludes = [
          "public/**"
          "result"
          "result-*"
          "*.lock"
          "*.svg"
          "themes/terratheme/layouts/**"
          # prettier mangles Hugo shortcode delimiters (it reads `>}}` as a
          # blockquote and splits the closing tag onto its own line).
          "content/**"
        ];
      };
    };
}
