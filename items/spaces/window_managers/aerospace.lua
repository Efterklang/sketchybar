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
  observer = nil,
}

function Window_Manager:init()
  for i, workspace in ipairs(aerospace_workspaces) do
    local selected = workspace == initial_current_workspace
    local space_item = sbar_utils:add_space_item(workspace, i)
    sbar_utils:highlight_focused_space(space_item, selected)

    space_item:subscribe(self.events.focus_change, function(env)
      local selected = env.FOCUSED_WORKSPACE == workspace
      sbar_utils:highlight_focused_space(space_item, selected)
    end)

    space_item:subscribe("mouse.clicked", function(env)
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
  for _, workspace in ipairs(aerospace_workspaces) do
    SBAR.exec("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}' ", function(apps)
      sbar_utils:update_space(workspace, parse_string_to_table(apps))
    end)
  end
end

return Window_Manager
