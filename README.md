<p align="center">
  <img width="200" src="https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/nixos.svg">
</p>

<h1 align="center">My NixOS Configurations</h1>

<p align="center">
  Declarative NixOS configurations for my personal machines
</p>

### About

This repository contains the declarative configuration of my current NixOS
systems.\
It serves both as my **source of truth** for system configuration and as a
**reference layout** for organizing NixOS setups in a clear, tree-structured
way.

The goal of this project is to help popularize NixOS by providing an
easy-to-adapt base and an existing workflow that others can reuse and build
upon.

### Repository Structure

The directory layout is designed to resemble a tree, grouping shared modules,
host-specific configs, and Home Manager setups in a predictable structure.

- **`common/`** → Shared system modules
- **`hosts/`** → Host-specific NixOS configurations
- **`home/`** → Home Manager configurations per host type
- **`secrets/`** → Encrypted secrets managed with sops-nix
- **`scripts/`** → Utility scripts

### Hosts

This configuration currently manages three machines:

| Host    | Role               | NixOS `stateVersion` |
| ------- | ------------------ | -------------------- |
| desktop | Workstation        | `25.05`              |
| laptop  | Mobile workstation | `26.05`              |
| server  | Homelab / services | `25.11`              |

### AI Usage

This project uses AI only as a programming assistant, giving me suggestions on
improvements, helping find package options, and reducing the need to repeatedly
check documentation. I care a lot about this system, work on it daily, and
because of that I will never turn this into random vibe coding.

### Disclaimer

Because this repo reflects my live systems:

- Some modules may be incomplete
- Temporary inconsistencies can exist
- Breaking changes may appear between commits

Use at your own risk and adapt to your needs.
