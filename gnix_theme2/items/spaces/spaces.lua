-- options:
-- 1. "macos_native"
-- 2. "aerospace": not implemented
-- 3. "flashspace": not implemented
local window_manager = require("items.spaces.window_managers.macos_native")
window_manager:init()

-- Add an indicator to switch between menus and spaces
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

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == ICONS.switch.on
  spaces_indicator:set({
    icon = currently_on and ICONS.switch.off or ICONS.switch.on
  })
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  SBAR.trigger("swap_menus_and_spaces")
end)
