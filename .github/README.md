<div align="center">

# Nitovim
<br>

## Screenshots

**Dashboard**

<img src="./assets/dashboard.png" width="350">
<br>
<br>

**Editor**
<br>
<img src="./assets/overview1.png" width="750">
<br>
|    |    |
|:-------:|:-------:|
| <img src="./assets/yazi.png" width="350"> | <img src="./assets/snackspicker.png" width="350"> |
| <img src="./assets/search-replace.png" width="350"> | <img src="./assets/git-blame.png" width="350"> |

</div>

# Run
```nix
nix run github:/onelocked/nitovim
```
# Installation

**Add nitovim as a flake input**
```nix
# In your flake.nix
inputs.nitovim.url = "github:onelocked/nitovim";
```

**NixOS**
```nix
environment.packages = [
  inputs.nitovim.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```
