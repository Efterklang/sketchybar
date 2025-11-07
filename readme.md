<h1 align="center">
  <img alt="image" src="https://github.com/user-attachments/assets/ec762bdd-e8e4-42f5-8fdf-a49ccc43ba87" width="60%"/>
  <br>
  SketchyBar Configuration
  <br>
  <i>part of my <a href="https://github.com/Efterklang/dotfiles">dotfiles</a></i>
  <br>
  <img src="https://img.shields.io/github/commit-activity/y/Efterklang/sketchybar?style=for-the-badge&labelColor=%23222436&color=%235771AA" alt="Commit Frequency">
  <img src="https://img.shields.io/github/license/Efterklang/sketchybar?style=for-the-badge&labelColor=%23222436&color=%235771AA" alt="License">
</h1>

## Install

### Using script

```sh
curl -fsSL https://raw.githubusercontent.com/Efterklang/sketchybar/main/install.sh | sh -s
```

### Manual

```sh
# install dependencies
brew install lua switchaudio-osx media-control
# install fonts
brew install --cask sf-symbols font-sketchybar-app-font font-maple-mono-nf-cn
# install SbarLua
git clone --depth 1 --quiet https://github.com/FelixKratz/SbarLua.git /tmp/sbarlua
cd /tmp/sbarlua && make install
# install config
git clone --depth 1 https://github.com/Efterklang/sketchybar ~/.config/sketchybar
```

---

## Configuration

The default configuration is located in **`init.lua`**. To override or disable
specific options, create a **`settings.lua`** file in the same directory. It
will be automatically loaded _after_ the defaults and merged.

<details><summary>Every configuration with their default value:
</summary>

<!-- config:start -->

```lua
return {
  WINDOW_MANAGER = "macos_native", -- or "aerospace"
  PRESET = "gnix", -- or "compact"

  FONT = {
    icon_font = "Maple Mono NF CN",
    label_font = "Maple Mono NF CN",
    style_map = {
      Regular = "Regular",
      Semibold = "Medium",
      Bold = "Bold",
      Black = "ExtraBold",
    },
  },

  PADDINGS = 3,
  GROUP_PADDINGS = 5,
  SPACE_LABEL = "greek_uppercase",

  MODULES = {
    logo = { enable = true },
    menus = { enable = true },
    spaces = { enable = true },
    front_app = { enable = true },
    calendar = { enable = true },
    wifi = { enable = true },
    volume = { enable = true },
    chat = { enable = true },
    brew = { enable = true },
    toggle_stats = { enable = true },
    netspeed = { enable = true },
    cpu = { enable = true },
    mem = { enable = true },
    music = { enable = true },
    battery = {
      enable = true,
      style = "icon", -- "icon" or "text"
    },
  },
}
```

> 💡 When `battery.style = "text"`, the border/bracket around battery items is
> disabled automatically.

<!-- config:end -->
</details>

### Example

To change defaults, create `~/.config/sketchybar/settings.lua`:

```lua
-- example settings.lua
return {
  WINDOW_MANAGER = "aerospace",
  PRESET = "compact",
  MODULES = {
    logo = { enable = false },
    chat = { enable = false },
    brew = { enable = false },
    battery = {
      style = "text",
    },
  },
}
```

That’s it — no need to modify `init.lua`. Your custom settings will be merged on
load.

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
