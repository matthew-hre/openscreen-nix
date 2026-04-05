<p align="center">
  <img src="https://raw.githubusercontent.com/siddharthvaddem/openscreen/main/icons/icons/png/512x512.png" width="128" height="128" alt="OpenScreen Logo" />
</p>

<h1 align="center">openscreen-nix</h1>

<p align="center">
  Nix flake for <a href="https://github.com/siddharthvaddem/openscreen">OpenScreen</a> — a free, open-source alternative to Screen Studio.
</p>

<p align="center">
  <a href="https://nixos.org"><img src="https://img.shields.io/badge/Nix_Flake-5277C3?logo=nixos&logoColor=white" alt="Nix Flake" /></a>
  <a href="https://github.com/siddharthvaddem/openscreen/releases/tag/v1.3.0"><img src="https://img.shields.io/badge/OpenScreen-v1.3.0-blue" alt="OpenScreen Version" /></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License" /></a>
</p>

---

## Usage

### Run without installing

```sh
nix run github:matthew-hre/openscreen-nix
```

### Installation

Add the flake to your inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    openscreen = {
      url = "github:matthew-hre/openscreen-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

#### NixOS (configuration.nix)

Using the overlay:

```nix
{
  nixpkgs.overlays = [ inputs.openscreen.overlays.default ];
  environment.systemPackages = [ pkgs.openscreen ];
}
```

Or referencing the package directly:

```nix
{
  environment.systemPackages = [
    inputs.openscreen.packages.${pkgs.system}.default
  ];
}
```

#### Home Manager

```nix
{
  home.packages = [
    inputs.openscreen.packages.${pkgs.system}.default
  ];
}
```

## Platform support

| Platform | Status |
| --- | --- |
| `x86_64-linux` | ✅ Tested |
| `aarch64-linux` | ✅ Supported |
| `x86_64-darwin` | ✅ Supported |
| `aarch64-darwin` | ✅ Supported |

## Updating

When a new version of OpenScreen is released:

1. Update `version` and `hash` in [`package.nix`](./package.nix)
2. Set `npmDepsHash = ""` and build — the error output will contain the correct hash
3. Update `npmDepsHash` with the correct value

```sh
# Get the new source hash
nix-prefetch-url --unpack https://github.com/siddharthvaddem/openscreen/archive/refs/tags/v<VERSION>.tar.gz
```

## License

MIT — same as [OpenScreen](https://github.com/siddharthvaddem/openscreen/blob/main/LICENSE).
