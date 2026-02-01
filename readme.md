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
brew install lua jq switchaudio-osx media-control imagemagick
# install sketchybar system stats plugin for CPU, RAM and network monitoring
brew tap joncrangle/tap
brew install sketchybar-system-stats
# install fonts
brew install --cask font-sketchybar-app-font font-maple-mono-nf-cn font-recursive-mono-nerd-font
# install SbarLua
git clone --depth 1 --quiet https://github.com/FelixKratz/SbarLua.git /tmp/sbarlua
cd /tmp/sbarlua && make install
# install config
git clone --depth 1 https://github.com/Efterklang/sketchybar ~/.config/sketchybar
```

---

## Configuration

The default configuration is located in **`settings.lua`**.

---

## Preview

Rewritten entirely in **Lua** using the `sbarlua` API. For the legacy **bash**
version, see [here](https://github.com/Efterklang/sketchybar/tree/bash).

### Themes

Nord Light, Catppuccin Latte, Rose Pine, Catppuccin Mocha, Tokyo Night

<img width="3418" height="68" alt="CleanShot 2026-02-01 at 20 52 49@2x" src="https://github.com/user-attachments/assets/dcbd2fd9-221e-4e46-8ed8-77d5b0de4ae4" />
<img width="3414" height="72" alt="CleanShot 2026-02-01 at 20 54 13@2x" src="https://github.com/user-attachments/assets/9ed1a063-4f0a-4247-b0f4-a59825abb002" />
<img width="3414" height="70" alt="CleanShot 2026-02-01 at 20 55 03@2x" src="https://github.com/user-attachments/assets/4f3bd6b6-4bbd-4bad-a373-9a0f08caf117" />
<img width="3418" height="72" alt="CleanShot 2026-02-01 at 20 55 48@2x" src="https://github.com/user-attachments/assets/3b0c0484-6aff-4e79-b54a-250c1224ef74" />
<img width="3418" height="68" alt="CleanShot 2026-02-01 at 20 56 28@2x" src="https://github.com/user-attachments/assets/7f98445c-98f7-4be3-af13-941be1e98749" />

| Tokyo Night                                                                                                                          | Catppuccin Mocha                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| <img width="3028" height="1732" alt="image" src="https://github.com/user-attachments/assets/2219184b-5456-438d-b86e-c5fc30369196" /> | <img width="3028" height="1732" alt="image" src="https://github.com/user-attachments/assets/ec762bdd-e8e4-42f5-8fdf-a49ccc43ba87"/> |

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

| Item                           | Click Script                                                            |
| ------------------------------ | ----------------------------------------------------------------------- |
| media                          | show music controller (play/pause, next, previous, repeat/random, etc.) |
| hardware stats                 | cpu graph[^2] · memory graph[^3] · netspeed item[^2]                    |
| toggle stats                   | show/hide hardware stats (cpu, memory, netspeed)                        |
| homebrew stats                 | show outdated packages                                                  |
| wechat, qq (or any other apps) | open chat app                                                           |
| volume                         | show volume slider and output device selector[^2]                       |
| wifi                           | show wifi networks and VPN status                                       |
| battery                        | show remaining time and percentage                                      |
| cal & time                     | open Calendar.app                                                       |

---

## Credits

[^1]: Credit [Sinjhin/SketchyMenu: A menu plugin et al for FelixKratz/SketchyBar](https://github.com/Sinjhin/SketchyMenu)

[^2]: Credit [FelixKratz/dotfiles: My personal macOS configuration](https://github.com/FelixKratz/dotfiles)

[^3]: Credit [TheGoldenPatrik1/sketchybar-config: My personal configuration for SketchyBar](https://github.com/TheGoldenPatrik1/sketchybar-config)

<!-- weather
https://github.com/FelixKratz/SketchyBar/discussions/12?sort=top#discussioncomment-5283361 -->
