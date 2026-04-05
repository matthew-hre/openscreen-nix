# openscreen-nix

Nix flake for [OpenScreen](https://github.com/siddharthvaddem/openscreen) — a free, open-source alternative to Screen Studio.

## Usage

### Run directly

```sh
nix run github:matthew-hre/openscreen-nix
```

### Install in your system configuration

Add the flake input:

```nix
{
  inputs.openscreen.url = "github:matthew-hre/openscreen-nix";
}
```

Then either use the overlay:

```nix
{
  nixpkgs.overlays = [ inputs.openscreen.overlays.default ];
  environment.systemPackages = [ pkgs.openscreen ];
}
```

Or reference the package directly:

```nix
{
  environment.systemPackages = [ inputs.openscreen.packages.${pkgs.system}.default ];
}
```

### Home Manager

```nix
{
  home.packages = [ inputs.openscreen.packages.${pkgs.system}.default ];
}
```

## Updating

When a new version of OpenScreen is released, update `version`, `hash`, and `npmDepsHash` in `package.nix`. You can get the new source hash with:

```sh
nix-prefetch-url --unpack https://github.com/siddharthvaddem/openscreen/archive/refs/tags/v<VERSION>.tar.gz
```

Then set `npmDepsHash = ""` and build — the error output will include the correct hash.
