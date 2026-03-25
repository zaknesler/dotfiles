#!/usr/bin/env bash

# Set default app to Zed for most file types
# Usage: bash ext.sh

ZED="dev.zed.zed"

handlers=(
  # Content types
  public.plain-text public.html public.xml public.json public.yaml
  public.shell-script public.python-script public.c-source public.make-source
  public.mpeg-2-transport-stream com.netscape.javascript-source com.apple.log
  com.sun.java-source net.daringfireball.markdown

  # Go
  .go .mod .sum

  # Rust
  .rs .toml

  # C / C++
  .c .h .cc .cpp .cxx .hh .hpp

  # C#
  .cs .csproj .sln

  # JavaScript / TypeScript
  .js .jsx .ts .tsx .mjs .cjs .mts .cts

  # Web
  .html .htm .css .scss .sass .less .vue .svelte .astro

  # Ruby
  .rb .erb .gemspec

  # Python
  .py .pyi .ipynb

  # Elixir
  .ex .exs .heex

  # Kotlin
  .kt .kts .gradle

  # Swift
  .swift

  # Zig
  .zig

  # Lua
  .lua

  # PHP
  .php

  # Shell
  .sh .bash .zsh .fish .nu .cmd

  # Data
  .json .jsonc .yaml .yml .xml .ini .cfg .conf .env .csv .tsv .sql .lock

  # Markup
  .md .mdx .markdown .rst .adoc .typ

  # Misc
  .tf .tfvars .nix .prisma .proto
  .map .diff .patch .vim .log
  .graphql .gql
)

for handler in "${handlers[@]}"; do
  duti -s "$ZED" "$handler" all 2>/dev/null || true
done
