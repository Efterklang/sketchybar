<h1 align="center">
  <img alt="image" src="https://github.com/user-attachments/assets/155b11de-e5e9-4610-9304-be441bb1615e" width="60%"/>
  <br>
  SketchyBar Configuration
  <br>
  <i>part of my <a href="https://github.com/Efterklang/dotfiles">dotfiles</a></i>
  <br>
  <img src="https://img.shields.io/github/commit-activity/y/Efterklang/sketchybar?style=for-the-badge&labelColor=%23222436&color=%235771AA" alt="Commit Frequency">
  <img src="https://img.shields.io/github/license/Efterklang/sketchybar?style=for-the-badge&labelColor=%23222436&color=%235771AA" alt="License">
</h1>

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Efterklang/sketchybar/main/install.sh | sh -s
```

---

## Configuration

The default configuration is located in **`init.lua`**. To override defaults or
toggle modules, create a **`settings.lua`** file in the same directory. It will
be loaded automatically after the defaults, allowing you to override or disable
specific options.

### Example override

```lua
-- settings.lua
WINDOW_MANAGER = "aerospace"
PRESET = "compact"

-- disable some modules
MODULES = {
  chat = false,
  logo = false,
  brew = false,
}
```

---

### All Configuration Options

| Option                  | Description                                          | Default Value                           | Options                                     |
| ----------------------- | ---------------------------------------------------- | --------------------------------------- | ------------------------------------------- |
| `FONT`                  | Font configuration                                   | `Maple Mono NF CN`                      |                                             |
| `PRESET`                | The default preset to use                            | `gnix`                                  | `gnix`, `compact`                           |
| `PRESET_OPTIONS`        | A table of presets                                   | `{ gnix = { ... }, compact = { ... } }` |                                             |
| `WINDOW_MANAGER`        | The window manager to use                            | `macos_native`                          | `macos_native`, `aerospace`                 |
| `SPACE_LABEL`           | The label to use for spaces                          | `greek_uppercase`                       | `greek_uppercase`, `greek_lowercase`, `nil` |
| `MUSIC.CONTROLLER`      | The media controller to use                          | `media-control`                         | `media-control`, `mpc`                      |
| `MUSIC.ALBUM_ART_SIZE`  | The size of the album art                            | `1280`                                  |                                             |
| `MUSIC.TITLE_MAX_CHARS` | The maximum number of characters for the music title | `15`                                    |                                             |
| `MUSIC.DEFAULT_ARTIST`  | The default artist when no artist is found           | `Various Artists`                       |                                             |
| `MUSIC.DEFAULT_ALBUM`   | The default album when none is found                 | `No Album`                              |                                             |
| `WIFI.PROXY_APP`        | Proxy app used for network control                   | `FlClash`                               |                                             |
| `PADDINGS`              | Padding for items                                    | `3`                                     |                                             |
| `GROUP_PADDINGS`        | Padding for groups                                   | `5`                                     |                                             |
| `MODULES`               | Enable or disable each module                        | `{ logo=true, cpu=true, ... }`          | `true` / `false`                            |

---

## Preview

Rewritten entirely in **Lua** using the `sbarlua` API. For the legacy **bash**
version, see [here](https://github.com/Efterklang/sketchybar/tree/bash).

---

### Left Items

| Item             | Click Script                                                              |
| ---------------- | ------------------------------------------------------------------------- |
| logo             | same as clicking the Apple icon                                           |
| workspaces       | left click → switch to that space<br>right click → open `Mission Control` |
| app menus        | click → open macOS app menu                                               |
| space indicators | swap menus and spaces                                                     |
| front app        | show app menu[^1]                                                         |

> [!NOTE]
> Supported Window Managers
>
> - macOS Native (default)
> - Aerospace (experimental and buggy 😅)

---

### Right Items

| Item                                     | Click Script                                                            |
| ---------------------------------------- | ----------------------------------------------------------------------- |
| mpd + mpc (music player daemon + client) | show music controller (play/pause, next, previous, repeat/random, etc.) |
| hardware stats                           | cpu graph[^2] · memory graph[^3] · netspeed item[^2]                    |
| toggle stats                             | show/hide hardware stats (cpu, memory, netspeed)                        |
| homebrew stats                           | show outdated packages                                                  |
| wechat, qq (or any other apps)           | open chat app                                                           |
| volume                                   | show volume slider and output device selector[^2]                       |
| wifi                                     | show wifi networks and VPN status                                       |
| battery                                  | show remaining time and percentage                                      |
| cal & time                               | open Calendar.app                                                       |

---

## Credits

[^1]: Credit
    [Sinjhin/SketchyMenu: A menu plugin et al for FelixKratz/SketchyBar](https://github.com/Sinjhin/SketchyMenu)

[^2]: Credit
    [FelixKratz/dotfiles: My personal macOS configuration](https://github.com/FelixKratz/dotfiles)

[^3]: Credit
    [TheGoldenPatrik1/sketchybar-config: My personal configuration for SketchyBar](https://github.com/TheGoldenPatrik1/sketchybar-config)

    [binbinsh/sketchybar-config: My sketchybar configuration files.](https://github.com/binbinsh/sketchybar-config)
