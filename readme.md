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

```shell
curl -fsSL https://raw.githubusercontent.com/Efterklang/sketchybar/main/install.sh | sh -s
```

## Preview

Rewrite using Lua, for bash version, see [here](https://github.com/Efterklang/sketchybar/tree/bash)

### items left

| Item             | Click Script                                                                   |
| ---------------- | ------------------------------------------------------------------------------ |
| logo             | same as click at apple icon                                                    |
| workspaces       | left click → switch to that space<br> right click → open `Mission Control`<br> |
| app menus        | click → open macOS app menu                                                    |
| space indicators | swap menus and spaces                                                          |
| front app        | show app menu[^1]                                                              |

> [!NOTE]
> Supported WM
> - MacOS Native (default)
> - Aerospace (experimental and buggy😅)
>
> ```lua init.Lua
> WINDOW_MANAGER = "macos_native" -- or "aerospace"
> ```

### items right

| Item                                     | Click Script                                                            |
| ---------------------------------------- | ----------------------------------------------------------------------- |
| mpd + mpc (music player daemon + client) | show music controller (play/pause, next, previous, repeat/random, etc.) |
| hardware stats                           | cpu graph[^2] · memory graph[^3] · netspeed item[^2]                    |
| toggle stats                             | show/hide hardware stats(cpu, memory, netspeed)                         |
| homebrew stats                           | show outdated packages                                                  |
| wechat, qq (or any other apps)           | Open wechat/qq                                                          |
| volume                                   | show volume slider and output device selector[^2]                       |
| wifi                                     | show wifi networks and vpn status                                       |
| battery                                  | show remaining time and percentage                                      |
| cal & time                               | open Calendar.app                                                       |

## Credits

[^1]: Credit [Sinjhin/SketchyMenu: A menu plugin et al for FelixKratz/SketchyBar](https://github.com/Sinjhin/SketchyMenu)
[^2]: Credit [FelixKratz/dotfiles: My personal macOS configuration](https://github.com/FelixKratz/dotfiles)
[^3]: Credit [TheGoldenPatrik1/sketchybar-config: My personal configuration for SketchyBar](https://github.com/TheGoldenPatrik1/sketchybar-config)
[^4]: Credit [binbinsh/sketchybar-config: My sketchybar configuration files.](https://github.com/binbinsh/sketchybar-config)
