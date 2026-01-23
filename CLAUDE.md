# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Home Manager configuration for macOS (aarch64-darwin) using Nix flakes. It manages user-level packages and program configurations declaratively.

## Commands

Apply configuration changes:
```bash
hm
# Or explicitly:
nix run github:nix-community/home-manager -- switch --flake .#sdmichelini
```

Update flake inputs:
```bash
nix flake update
```

Check configuration without applying:
```bash
nix run github:nix-community/home-manager -- build --flake .#sdmichelini
```

## Architecture

- `flake.nix` - Flake definition with nixpkgs-unstable and home-manager inputs; targets aarch64-darwin with unfree packages allowed
- `home.nix` - User configuration module defining packages (awscli2, pixi, uv) and program configs (zsh with oh-my-zsh, vim, tmux)

The configuration username is `sdmichelini` - update `homeConfigurations.sdmichelini` in flake.nix and `home.username`/`home.homeDirectory` in home.nix if changing users.
