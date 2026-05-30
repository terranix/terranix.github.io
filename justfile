# See available `just` subcommands
list:
    just --list

# Serve website on http://127.0.0.1:1313/
serve:
    hugo serve -D

# Create new documentation page in content/docs/
doc PATH:
    hugo new content 'content/docs/{{ PATH }}'

# Create new news post in content/news/ (page bundle with assets)
news-bundle SLUG:
    hugo new content 'content/news/{{ SLUG }}/index.md'

# Create new news post in content/news/ (single file, no assets)
news SLUG:
    hugo new content 'content/news/{{ SLUG }}.md'

# Build the Hugo site using default.nix (output in ./result/)
build-nix:
    nix build .# --out-link result

# Build the theme on its own (output in ./result/)
build-theme:
    nix build .#theme --out-link result

# Build the Hugo site with the local hugo binary (no Nix)
build:
    hugo --minify
