local app_icons = require("helpers.app_icons")

local spaces = {}

local space_label = { "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ" }

for i = 1, 10, 1 do
  local space = SBAR.add("space", "space." .. i, {
    space = i,
    icon = {
      font = { family = FONT.nerd_font },
      string = space_label[i],
      padding_left = 15,
      padding_right = 8,
      color = COLORS.text,
      highlight_color = COLORS.mauve,
    },
    label = {
      padding_right = 20,
      color = COLORS.grey,
      highlight_color = COLORS.lavender,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = COLORS.base,
      border_width = 1,
      height = 26,
      border_color = COLORS.mantle,
    },
    popup = { background = { border_width = 5, border_color = COLORS.mantle } }
  })

  spaces[i] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = SBAR.add("bracket", { space.name }, {
    background = {
      color = COLORS.transparent,
      border_color = COLORS.surface1,
      height = 28,
      border_width = 2
    }
  })

  -- Padding space
  SBAR.add("space", "space.padding." .. i, {
    space = i,
    script = "",
    width = GROUP_PADDINGS,
  })

  local space_popup = SBAR.add("item", {
    position = "popup." .. space.name,
    padding_left = 5,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
      background = { border_color = selected and COLORS.mantle or COLORS.surface1 }
    })
    space_bracket:set({
      background = { border_color = selected and COLORS.grey or COLORS.surface1 }
    })
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    elseif env.BUTTON == "right" then
      -- 右键：打开 Mission Control
      SBAR.exec("osascript -e 'tell application \"Mission Control\" to activate'")
    else
      -- 左键：使用 macOS 原生快捷键切换空间 (Control + 数字)
      -- macOS 键盘码：1=18, 2=19, 3=20, 4=21, 5=23, 6=22, 7=26, 8=28, 9=25, 10=29
      local key_codes = { 18, 19, 20, 21, 23, 22, 26, 28, 25, 29 }
      local key_code = key_codes[tonumber(env.SID)]
      if key_code then
        SBAR.exec("osascript -e 'tell application \"System Events\" to key code " .. key_code .. " using {control down}'")
      end
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = SBAR.add("item", {
  drawing = false,
  updates = true,
})

local spaces_indicator = SBAR.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = COLORS.grey,
    string = ICONS.switch.on,
  },
  label = {
    drawing = false,
  },
  background = {
    color = COLORS.with_alpha(COLORS.grey, 0.0),
    border_color = COLORS.with_alpha(COLORS.base, 0.0),
  }
})

space_window_observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  local no_app = true
  for app, count in pairs(env.INFO.apps) do
    no_app = false
    local lookup = app_icons[app]
    local icon = ((lookup == nil) and app_icons["Default"] or lookup)
    icon_line = icon_line .. icon
  end

  if (no_app) then
    icon_line = " —"
  end
  SBAR.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = icon_line })
  end)
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == ICONS.switch.on
  spaces_indicator:set({
    icon = currently_on and ICONS.switch.off or ICONS.switch.on
  })
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  SBAR.trigger("swap_menus_and_spaces")
end)
