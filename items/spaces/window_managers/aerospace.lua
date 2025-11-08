-- quite buggy 😅
-- Credits: https://github.com/falleco/dotfiles/blob/main/sketchybar
---@diagnostic disable: need-check-nil
local app_icons = require("helpers.spaces_util.app_icons")
local sbar_utils = require("helpers.spaces_util.sbar_util")

local function parse_string_to_table(s)
  local result = {}
  for line in s:gmatch("([^\n]+)") do
    table.insert(result, line)
  end
  return result
end

local function get_workspaces()
  local file = io.popen("aerospace list-workspaces --all")
  local result = file:read("*a")
  file:close()
  return parse_string_to_table(result)
end

local aerospace_workspaces = get_workspaces()

local function get_current_workspace()
  local file = io.popen("aerospace list-workspaces --focused")
  local result = file:read("*a")
  file:close()
  return parse_string_to_table(result)[1]
end

local initial_current_workspace = get_current_workspace()

local Window_Manager = {
  events = {
    window_change = "space_windows_change", -- TODO: replace with real event name
    focus_change = "aerospace_workspace_change",
  },
  spaces = {},
  observer = nil,
}

function Window_Manager:init()
  for i, workspace in ipairs(aerospace_workspaces) do
    local selected = workspace == initial_current_workspace
    local item = sbar_utils.add_space_item(workspace, i)
    self.spaces[i] = item.space
    sbar_utils.highlight_focused_space(item, selected)

    item.space:subscribe(self.events.focus_change, function(env)
      local selected = env.FOCUSED_WORKSPACE == workspace
      sbar_utils.highlight_focused_space(item, selected)
    end)

    item.space:subscribe("mouse.clicked", function(env)
      LOG:info(env.NAME)
      self:perform_switch_desktop(env.BUTTON, env.SID)
    end)
  end
  -- init app icons for each space
  self:update_space_label()
end

function Window_Manager:start_watcher()
  local watcher = SBAR.add("item", {
    drawing = false,
    updates = true,
    update_freq = 5,
  })

  watcher:subscribe("routine", function(env)
    self:update_space_label()
  end)
end

--- @param button string the mouse button clicked
--- @param sid string clicked space's id
function Window_Manager:perform_switch_desktop(button, sid)
  if button == "left" then
    SBAR.exec("aerospace workspace " .. sid)
  elseif button == "right" then
    -- not implemented
  elseif button == "other" then -- for eaxmple, middle click
    LOG:info("Middle click on space " .. sid)
  end
end

function Window_Manager:update_space_label()
  for i, workspace in ipairs(aerospace_workspaces) do
    SBAR.exec("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}' --json ", function(apps)
      local icon_line = ""
      local no_app = true
      for i, app in ipairs(apps) do
        no_app = false
        local app_name = app["app-name"]
        local lookup = app_icons[app_name]
        local icon = ((lookup == nil) and app_icons["default"] or lookup)
        icon_line = icon_line .. " " .. icon
      end

      if no_app then
        icon_line = " —"
      end

      SBAR.animate("tanh", 10, function()
        self.spaces[i]:set({
          label = icon_line,
        })
      end)
    end)
  end
end

return Window_Manager
