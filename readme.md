<h1 align="center">
  <img alt="image" src="https://github.com/user-attachments/assets/4f293a12-0ee4-44bd-9aad-fe861c4aa2c8" width="60%"/>
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
git clone --depth=1 https://github.com/Efterklang/sketchybar.git sbar
mv ~/.config/sketchybar ~/.config/sketchybar.back
cp -r ./sbar ~/.config/sketchybar
```

## Preview

Rewrite using Lua, for bash version, see [here](https://github.com/Efterklang/sketchybar/tree/bash)

### items left

- logo(finder)
- workspaces/app menus
- front app

> [!NOTE]
> Supported WM
> - MacOS Native (default)
> - Aerospace (experimental and buggy😅)
>
> ```lua init.Lua
> WINDOW_MANAGER = "macos_native" -- or "aerospace"
> ```

### items right

- mpd + mpc (music player deamon+client)
- mem, cpu, network stats
- homebrew stats
- wechat, qq (or any other apps)
- volume
- battery
- cal & time

## Credits

- [FelixKratz/dotfiles: My personal macOS configuration](https://github.com/FelixKratz/dotfiles)
- [TheGoldenPatrik1/sketchybar-config: My personal configuration for SketchyBar](https://github.com/TheGoldenPatrik1/sketchybar-config)
- [binbinsh/sketchybar-config: My sketchybar configuration files.](https://github.com/binbinsh/sketchybar-config)
