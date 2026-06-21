<p align="center">
  <img width="200" src="https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/nixos.svg">
</p>

<h1 align="center">My NixOS Configurations</h1>

<p align="center">
  Declarative NixOS configurations for my personal machines
</p>

### About

This repository contains the declarative configuration of my current NixOS systems.  
It serves both as my **source of truth** for system configuration and as a **reference layout** for organizing NixOS setups in a clear, tree-structured way.

The goal of this project is to help popularize NixOS by providing an easy-to-adapt base and an existing workflow that others can reuse and build upon.

> **Important**
>
> This repository is primarily intended as a **layout reference and learning resource**.  
> Many parts may be inconsistent or in transition because most commits are generated via automation (`nrall`, `nrpush`) and may capture intermediate states.
>
> Use it as a base or inspiration, not as a drop-in production configuration.

### Repository Structure

The directory layout is designed to resemble a tree, grouping shared modules, host-specific configs, and Home Manager setups in a predictable structure.

- **`common/`** → Shared system modules  
- **`hosts/`** → Host-specific NixOS configurations  
- **`home/`** → Home Manager configurations per host type  
- **`secrets/`** → Encrypted secrets managed with sops-nix  
- **`scripts/`** → Utility scripts  

This structure helps separate concerns while keeping everything discoverable.

### Hosts

This configuration currently manages three machines:

| Host    | Role    | NixOS `stateVersion` |
|---------|---------|----------------------|
| desktop | Workstation | `25.05` |
| laptop  | Mobile workstation | `25.05` |
| server  | Homelab / services | `25.11` |

### Disclaimer

Because this repo reflects my live systems and automated deploy workflow:

- Some modules may be incomplete  
- Temporary inconsistencies can exist  
- Breaking changes may appear between commits  

Use at your own risk and adapt to your needs.
