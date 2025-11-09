-- Load theme from themes directory
local theme_name = THEME or "catppuccin_mocha"
local theme_path = "themes/" .. theme_name
local success, colors = pcall(require, theme_path)

-- Fallback to catppuccin_mocha if theme not found
if not success then
  print("Theme '" .. theme_name .. "' not found, falling back to catppuccin_mocha")
  colors = require("themes/catppuccin_mocha")
end

-- Add with_alpha utility function
colors.transparent = 0x00000000
colors.with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

return colors
