# Usage Guide

This guide explains how to use the NixOS modules and packages provided by this configuration, both internally (within this flake) and externally (as a flake input in another project).

## Important: Special Arguments

Many modules in this configuration rely on `specialArgs` being passed to the NixOS system. These arguments are essential for the modules to know which user to configure, what the hostname is, and whether to enable certain features like impermanence.

Key `specialArgs` used across modules:

- `username`: The primary user's name (required for almost all modules).
- `hostname`: The name of the host (used for networking and secrets).
- `impermanence`: A boolean flag to enable/disable persistence logic.

Refer to [special args docs](./special-args.md) for more informations.

Ensure these are passed in your `nixosSystem` configuration:

```nix
modules = [
  {
    _module.args = {
      username = "your-user";
      hostname = "your-host";
      impermanence = false;
    };
  }
];
```

---

## Internal Usage

Within this repository, modules and packages are exposed via the `self` argument.

### Using Configuration Modules

To use a module in a host configuration (e.g., in `hosts/armin/default.nix`), add it to the `modules` list:

```nix
{ self, inputs, ... }: {
  flake.nixosConfigurations.armin = inputs.nixpkgs.lib.nixosSystem {
    # ...
    modules = [
      ./hardware.nix
      self.nixosModules.audio
      self.nixosModules.browser
      # ...
    ];
  };
}
```

### Using Packages

Custom packages are available under `self.packages.${pkgs.system}`. You can use them in your configuration like this:

```nix
{ self, pkgs, ... }: {
  environment.systemPackages = [
    self.packages.${pkgs.system}.foot
    self.packages.${pkgs.system}.btop
  ];
}
```

You can install them with home manager too, they're normal packages with all the functionality.

---

## External Usage

You can use this configuration as a flake input in your own project.

### Adding as an Input

In your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Note: You can change it for anything. Just keep it consistant.
    nixos-config = {
      url = "github:First-Non-Interesting-Username/NixOS-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, nixos-config, ... }: {
    nixosConfigurations.my-new-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        username = "myuser"; # Required for modules
        hostname = "myhost";
        impermanence = false;
      };
      modules = [
        ./configuration.nix
        nixos-config.nixosModules.audio
        nixos-config.nixosModules.theme
      ];
    };
  };
}
```

### Using Packages Externally

To use the custom packages from this flake:

```nix
{ nixos-config, system, ... }: {
  environment.systemPackages = [
    nixos-config.packages.${system}.foot
  ];
}
```

---

## Documentation References

- [Module List](./module-list.md): Detailed description of all available NixOS modules.
- [Package List](./package-list.md): List of custom-wrapped packages.
- [Host Guide](./host-guide.md): Information about existing host configurations.
