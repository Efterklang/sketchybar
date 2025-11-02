-- Use Greek alphabet
local greek_uppercase = {
  "Α",
  "B",
  "Γ",
  "Δ",
  "E",
  "Z",
  "H",
  "Θ",
  "I",
  "K",
  "Λ",
  "M",
  "N",
  "Ξ",
  "O",
  "Π",
  "P",
  "Σ",
  "T",
  "Y",
  "Φ",
  "X",
  "Ψ",
  "Ω",
}

local greek_lowercase = {
  "α",
  "β",
  "γ",
  "δ",
  "ε",
  "ζ",
  "η",
  "θ",
  "ι",
  "κ",
  "λ",
  "μ",
  "ν",
  "ξ",
  "ο",
  "π",
  "ρ",
  "σ",
  "τ",
  "υ",
  "φ",
  "χ",
  "ψ",
  "ω",
}

--- @class space_api
--- @field created_spaces table key space_id, value SketchyBar space item instance
--- @field add_space_item function create sketchybar space item
local space_api = {
  created_spaces = {},
}

-- create a sketchybar space item  and bracket
--- @param space_id string | number The ID of the space, for aerospace, this can be "1","2"..."A","B" etc.
--- @param idx number The index of the space, for example, 1 for first space
--- @return table {space: space_item, bracket: bracket_item}
function space_api.add_space_item(space_id, idx)
  local space_label = space_id
  if SPACE_LABEL == "greek_uppercase" then
    space_label = greek_uppercase[idx] or space_id
  elseif SPACE_LABEL == "greek_lowercase" then
    space_label = greek_lowercase[idx] or space_id
  end

  local space = SBAR.add("space", "space." .. space_id, {
    space = space_id,
    icon = {
      font = { family = FONT.nerd_font },
      string = space_label,
      padding_left = SPACE_ITEM_PADDING,
      padding_right = 8,
      color = COLORS.text,
      highlight_color = COLORS.mauve,
    },
    label = {
      padding_right = SPACE_ITEM_PADDING,
      color = COLORS.grey,
      highlight_color = COLORS.lavender,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = COLORS.base,
      border_width = 2,
      height = 26,
      border_color = COLORS.mantle,
    },
  })

  space_api.created_spaces[space_id] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = SBAR.add("bracket", { space.name }, {
    drawing = false,
    background = {
      color = COLORS.transparent,
      border_color = COLORS.surface1,
      height = 28,
      border_width = 2,
    },
  })

  -- Padding space
  SBAR.add("space", "space.padding." .. idx, {
    space = idx,
    script = "",
    width = GROUP_PADDINGS,
  })

  return { space = space, bracket = space_bracket }
end

-- Highlight or unhighlight a space item based on focused
--- @param sbar_item table containing space and bracket items
--- @param is_selected boolean whether the space is focused
function space_api.highlight_focused_space(sbar_item, is_selected)
  sbar_item.space:set({
    icon = { highlight = is_selected },
    label = { highlight = is_selected },
    background = { border_color = is_selected and COLORS.lavender or COLORS.surface1 },
  })
end

return space_api
