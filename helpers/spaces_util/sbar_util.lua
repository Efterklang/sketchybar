local icons = require("helpers.spaces_util.app_icons")
local greek_uppercase = { "Α", "B", "Γ", "Δ", "E", "Z", "H", "Θ", "I", "K", "Λ", "M", "N", "Ξ", "O", "Π", "P", "Σ", "T", "Y", "Φ", "X", "Ψ", "Ω" }
local greek_lowercase = { "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω" }

--- @class space_api
--- @field created_spaces table<string, SketchybarItem> key space_id, value SketchyBar space item instance
local space_api = {
  created_spaces = {},
}

-- create a sketchybar space item  and bracket
--- @param space_id string | number The ID of the space, for aerospace, this can be "1","2"..."A","B" etc.
--- @param idx number The index of the space, for example, 1 for first space
--- @return SketchybarItem the created space item
function space_api:add_space_item(space_id, idx)
  local space_label = space_id
  if SPACES.ID_STYLE == "greek_uppercase" then
    space_label = greek_uppercase[idx] or space_id
  elseif SPACES.ID_STYLE == "greek_lowercase" then
    space_label = greek_lowercase[idx] or space_id
  end

  local space = SBAR.add("space", "space." .. space_id, {
    space = space_id,
    icon = {
      string = space_label,
      padding_left = SPACES.ITEM_PADDING,
      padding_right = 8,
      color = COLORS.text,
      highlight_color = COLORS.mauve,
    },
    label = {
      padding_right = SPACES.ITEM_PADDING,
      color = COLORS.subtext0,
      highlight_color = COLORS.lavender,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = GROUP_PADDINGS,
    padding_left = 1,
    background = {
      color = COLORS.base,
      border_width = 2,
      height = 26,
      border_color = COLORS.mantle,
    },
  })
  space_api.created_spaces[space_id] = space
  return space
end

-- Highlight or unhighlight a space item based on focused
--- @param space_item SketchybarItem
--- @param is_selected boolean whether the space is focused
function space_api:highlight_focused_space(space_item, is_selected)
  space_item:set({
    icon = { highlight = is_selected },
    label = { highlight = is_selected },
    background = { border_color = is_selected and COLORS.lavender or COLORS.surface1 },
  })
end

--- @param space_id string | number The ID of the space to update
--- @param app_names string[] List of application names present in the space
function space_api:update_space(space_id, app_names)
  local icon_line = ""

  for _, name in ipairs(app_names) do
    if name and name ~= "" then
      local icon = ((icons[name] == nil) and icons["default"] or icons[name])
      icon_line = icon_line .. icon
    end
  end

  icon_line = icon_line ~= "" and icon_line or "—"

  SBAR.animate("tanh", 10, function()
    self.created_spaces[space_id]:set({ label = icon_line })
  end)
end

return space_api
