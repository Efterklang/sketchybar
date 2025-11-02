local app_icons = require("helpers.spaces_util.app_icons")
local sbar_utils = require("helpers.spaces_util.sbar_util")
--- Ref https://felixkratz.github.io/SketchyBar/config/events
-- Window change: When a window is created or destroyed on a space
-- Focus change: When the focused space changes
local Window_Manager = {
  spaces = {},
  events = {
    window_change = "space_windows_change",
    focus_change = "space_change",
  },
}

--- Initialize space items in SketchyBar
function Window_Manager:init()
  for i = 1, 10 do
    local item = sbar_utils.add_space_item(i, i)
    self.spaces[i] = item.space

    item.space:subscribe(self.events.focus_change, function(env)
      sbar_utils.highlight_focused_space(item, env.SELECTED == "true")
    end)

    item.space:subscribe("mouse.clicked", function(env)
      self:perform_switch_desktop(env.BUTTON, env.SID)
    end)
  end
end

function Window_Manager:start_watcher()
  -- Add an observer item to monitor space window changes globally.
  -- Unlike mouse.clicked and space_change which are bound to individual space items
  -- (since they relate to specific space interactions), space_windows_change is a global event
  -- that triggers whenever any space's window list changes. Using a single observer avoids
  -- redundant subscriptions and ensures efficient event handling across all spaces.
  local watcher = SBAR.add("item", {
    drawing = false,
    updates = true,
  })

  watcher:subscribe(self.events.window_change, function(env)
    self:update_space_label(env)
  end)
end

--- @param button string the mouse button clicked
--- @param sid string clicked space's id
function Window_Manager:perform_switch_desktop(button, sid)
  local key_codes = { 18, 19, 20, 21, 23, 22, 26, 28, 25, 29 }
  if button == "left" then
    SBAR.exec(
      'osascript -e \'tell application "System Events" to key code '
        .. key_codes[tonumber(sid)]
        .. " using {control down}'"
    )
  elseif button == "right" then
    SBAR.exec("osascript -e 'tell application \"Mission Control\" to activate'")
  elseif button == "other" then -- for eaxmple, middle click
    LOG.log("Middle click on space " .. sid)
  end
end

--- @param env table containing INFO.apps and INFO.space
function Window_Manager:update_space_label(env)
  local icon_line = ""
  local no_app = true
  for app, count in pairs(env.INFO.apps) do
    no_app = false
    local lookup = app_icons[app]
    local icon = ((lookup == nil) and app_icons["default"] or lookup)
    icon_line = icon_line .. icon
  end

  if no_app then
    icon_line = " —"
  end
  SBAR.animate("tanh", 10, function()
    self.spaces[env.INFO.space]:set({ label = icon_line })
  end)
end

return Window_Manager
