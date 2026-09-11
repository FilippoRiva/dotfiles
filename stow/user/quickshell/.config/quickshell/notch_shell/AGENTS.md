# AGENTS.md — notch_shell

QML "notch" shell for the [Hyprland](https://hyprland.org) compositor, built on [Quickshell](https://quickshell.outfoxxed.de). Lifecycle-edited through a GNU stow dotfiles repo (`stow/user/quickshell/...`); run with the system `quickshell` binary.

## WHAT — stack & structure

**Runtime model.** QML is interpreted at runtime — there is no build step. Quickshell launches from a QML entry point; QtQuick provides UI primitives, Quickshell provides Hyprland/shell services (windows, monitors, workspaces, global shortcuts, pipewire), QtQuick.Layouts provides layout.

**Layout of this folder**

| Path | Role |
|---|---|
| `shell.qml` | Entry point / wiring. One `PanelWindow` **per screen** via `Variants { model: Quickshell.screens }`; hosts the `Notch`, ties `HyprlandFocusGrab` to `notch.isExpanded`, masks the window to the notch's region, keeps it focusable. |
| `qmldir` | Declares global singletons: `Colors`, `Audio`. |
| `Colors.qml` | Central palette singleton — the only themed source of truth for colors. |
| `Audio.qml` | Pipewire volume singleton (`value`, `setVolume()`), wraps `PwObjectTracker`. |
| `components/notch/Notch.qml` | The core bar. Sizes to its currently-loaded view, animates width/height, owns the view-switching state machine, registers the `toggleNotch` global shortcut. |
| `components/notch/notch_views/` | Whole-bar layouts: `Default` (workspaces + clock + switch), `Launcher` (app search), `ControlPanel` (audio). All extend `NotchView` (a `ColumnLayout`). |
| `components/notch/notch_elements/` | Atomic widgets: `Clock`, `Launcher` (fuzzy app search UI), `AppLauncher`, `AudioController`, `HyprlandWorkspace`, `WorkspaceDots`, `ViewSwitcher`. All extend `NotchElement` (= `Item`). |

**Naming.** Directories act as QML modules: files are imported by folder (`import "." as Views`, `import '../notch_elements' as Elements`) and are each a single named type. Reserved names: do not create a file named `Launcher.qml` in two sibling namespaces (an existing `Launcher.qml` lives in both `notch_views/` and `notch_elements/`, so always qualify — e.g. `Elements.Launcher`).

## WHY — design intent

The shell is a **top-center "notch" bar** whose content swaps between three views through one reusable mechanism:

- **View switching is a state machine.** `Notch` exposes `property Component view` plus pre-declared `Component { id: ... }` wrappers as `defaultView` / `launcherView` / `controlPanelView`. A `Loader` swaps `sourceComponent`; `onViewChanged` also calls `window.requestActivate()` so keyboard focus follows the view. `isExpanded := view !== defaultView` drives focus-grabbing and animations.
- **Navigation is cyclic & dismissable.** `GlobalShortcut "toggleNotch"` cycles Default → Launcher → ControlPanel → Default, but only when the notch is on the focused monitor. `Escape` in any expanded view returns to `defaultView` `event.accepted = true`. Launching an app / clicking a switch collapses to default.
- **Singletons are app-wide services.** `Colors` and `Audio` are reached from any depth with `import "../../"` (or `'../../../'`) rather than per-module imports — keep them as the palette/service hub.
- **Elements are dumb & injected.** Widgets receive context via `required property` (`notch`, `screen`, `view`, `appName`, `appCommand`) instead of reaching into globals.

## HOW — build, verify, run

- **No build.** `.qml` files are loaded directly by the `quickshell` binary (`/usr/bin/quickshell`); there is no compile step.
- **Syntax/lint checks.** `qmlls` language server config lives in `.qmlls.ini` (points at the Quickshell vfs build dir + Qt import paths). When qmlls is unavailable, self-review for the conventions below. Use `// qmllint disable <rule>` / `// qmllint enable <rule>` around known-unresolvable types, never silence silently.
- **Manual verify.** Run the shell with `quickshell .config/quickshell/notch_shell/shell.qml` from `$HOME`, or `quickshell shell.qml` inside this folder (`.qmlls.ini`'s vfs dir means Qt resolves the singletons when launched from the right cwd). Watch Hyprland for the notch, then exercise toggle, escape-dismiss, app launch, and workspace click animations.
- **Installing the change** (outside the dev loop, for the live setup): this tree is deployed with GNU stow from the repo root via `dotfiles.sh -i` (it symlinks `stow/user/quickshell/.config/quickshell` into `~/.config`). Never hand-edit `~/.config/quickshell/...` — edit the `stow/` tree. After edits, restart the shell process (session config / systemd user unit).
- **Commits** use conventional prefixes, e.g. `quickshell: <summary>`.

### Conventions every edit must follow

- **Animations:** always `Behavior on <prop> { NumberAnimation | ColorAnimation { duration: <ms>; easing.type: Easing.OutCubic } }`. Durations ~100 ms for micro-interactions (press/scale), 300+ ms for layout/color (notch resize, workspace dots).
- **Press feedback:** `scale: mouse.pressed ? 0.9 : 1` inside the `Rectangle`, guarded by its own `Behavior on scale`.
- **Sizing:** size an element to its inner `content` item via `width: content.width; height: content.height`; give that item an `id: content`. Otherwise set `implicitWidth`/`implicitHeight`/`Layout.*`.
- **Colors:** use the `Colors` singleton (via `import "../../"`) for palette entries. Only hardcode hex for accents intentionally novel to a widget.
- **Fonts:** "Geistmono Nerd Font" for text/glyphs, "Material Symbols Rounded" for icons.
- **IDs & properties:** explicit `id` on every root object; typed properties (`property int/bool/string/date/Component`); `required property` for injected deps; safe navigation with `?.` / `??` for optional Hyprland state (`Hyprland.focusedWorkspace?.id ?? 1`).
- **Signals & init:** `Connections { target: ...; function on... }` for signal wiring, `Component.onCompleted` for one-time init, `Timer { running: true; repeat: true }` for periodic refresh. Hyprland integration goes through `Hyprland.dispatch(...)` (e.g. `"hl.dsp.focus({ workspace = N })"`).
- **Comments** are sparse, used mainly as section headers (`// Positioning`, `// Styling`, `// Notch Animations`). Keep it that way.
- **Style:** 4-space indent; existing cosmetic quirks (e.g. `import QtQuick ` with trailing space, snake_case ids like `view_switcher`) are left as-is — don't "fix" them wholesale in the same diff as a feature.