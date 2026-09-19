# AGENTS.md — dotfiles

Arch Linux dotfiles managed with GNU stow + a custom `dotfiles.sh` installer.
Based around [Hyprland](https://hyprland.org) (Lua config) + [Quickshell](https://quickshell.outfoxxed.de) QML notch shell + [pywal](https://github.com/dylanaraps/pywal) color generation.

## Repo layout

```
stow/user/     → symlinked into $HOME with stow
stow/system/   → symlinked into / with sudo stow
scripts/       → sourced by dotfiles.sh (print.sh, stow.sh, themes.sh, hooks.sh)
themes/        → installed to /usr/share/<app>/themes/ for GRUB, Plymouth, SDDM
wallpapers/    → wallpaper PNGs, default is Doodle_Space_Nord.png
```

**Key managed configs:**

| Directory | Component | Targets |
|---|---|---|
| `stow/user/hyprland/` | Hyprland WM | `~/.config/hypr/*.lua` |
| `stow/user/quickshell/` | Quickshell notch shell | `~/.config/quickshell/` |
| `stow/user/kitty/` | Kitty terminal | `~/.config/kitty/kitty.conf` |
| `stow/user/zsh/` | Z shell | `~/.zshrc` |
| `stow/user/vscodium/` | VSCodium editor | `~/.config/VSCodium/User/` |
| `stow/user/wal/` | pywal templates | `~/.config/wal/templates/` |
| `stow/system/grub/` | GRUB bootloader | `/etc/default/grub` |
| `stow/system/plymouth/` | Plymouth splash | `/etc/plymouth/plymouthd.conf` |
| `stow/system/sddm/` | SDDM display manager | `/etc/sddm.conf.d/sddm.conf` |

## How to install

```bash
./dotfiles.sh -i              # full install (needs sudo)
./dotfiles.sh -ti             # test install — skip git reset --hard step
./dotfiles.sh -i -u           # user-mode only (no sudo stow, no system hooks)
./dotfiles.sh -i -w wallpapers/plant-music-studio.png   # custom wallpaper
```

**What `-i` does in order:** stow user packages → stow system packages (unless `-u`) → git reset --hard (overwrites stow back with repo versions, paired with `--adopt`) → sync themes → run post-install hooks.

## Editing rules — never hand-edit `~/.config/`

- **Always edit files inside `stow/user/` or `stow/system/`**, not their symlinked targets.
- Changes take effect after re-running `dotfiles.sh -i` or restarting the relevant service.
- `.gitignore` exists at repo root for `stow/user/quickshell/.config/quickshell/.qmlls.ini` (generated config).

## Theme pipeline

1. `themes.sh` copies the chosen wallpaper to SDDM theme dir + `~/Images/wallpapers/wallpaper.png`
2. `pywal` generates a color palette from the wallpaper (or uses `--theme` flag for a named scheme)
3. Custom templates in `~/.cache/wal/` (named `custom__<app>__<theme>__<name>` and `hyprland__<name>`) are copied into `themes/` and `stow/user/hyprland/`
4. System-level themes for GRUB, Plymouth, SDDM are `sudo cp`-ed to `/usr/share/<app>/themes/`

## Post-install hooks

| Hook | Condition | Effect |
|---|---|---|
| `grub_hook` | skipped with `-u` | `sudo grub-mkconfig -o /boot/grub/grub.cfg` |
| `plymouth_hook` | skipped with `-u` | `sudo mkinitcpio -P` (rebuilds UKI) |
| `hyprland_hook` | always | `hyprctl reload; pkill hyprpaper; hyprpaper &` |

## Quickshell notch shell

See the dedicated `AGENTS.md` at `stow/user/quickshell/.config/quickshell/notch_shell/AGENTS.md` for:
- QML structure, view-switching state machine, naming conventions
- no build step, verify with `quickshell shell.qml` from `$HOME`
- animation, font, color, sizing, and style conventions

## Commit convention

Use `<component>: <summary>` prefixes. Observed examples: `quickshell:`, `vscodium:`, `zsh:`, `kitty:`, `sddm:`, `chore:`, `gitignore:`.

## .vscode/settings.json

Contains `Lua.workspace.library` pointing at `/usr/share/hypr/stubs` for Hyprland Lua config autocompletion.