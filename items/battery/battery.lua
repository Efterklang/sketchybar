if not (MODULES.battery and MODULES.battery.enable) then
  return
end

local style = MODULES.battery.style or "icon"

if style == "text" then
  require("items.battery.text_style")
else
  require("items.battery.icon_style")
end
