local function safe_require(path)
  local ok, err = pcall(require, path)
  if not ok then
    print("⚠️ Failed to load " .. path .. ": " .. err)
  end
end

local function is_enabled(mod)
  return MODULES[mod] and MODULES[mod].enable ~= false
end

if is_enabled("logo") then
  safe_require("items.logo.apple")
end
if is_enabled("menus") then
  safe_require("items.menus.menus")
end
if is_enabled("spaces") then
  safe_require("items.spaces.spaces")
end
if is_enabled("front_app") then
  safe_require("items.front_app.front_app")
end
if is_enabled("calendar") then
  safe_require("items.calendar.calendar")
end
if is_enabled("battery") then
  safe_require("items.battery.battery")
end
if is_enabled("wifi") then
  safe_require("items.monitor.wifi")
end
if is_enabled("volume") then
  safe_require("items.volume.volume")
end
if is_enabled("chat") then
  safe_require("items.chat.qq_wechat")
end
if is_enabled("brew") then
  safe_require("items.brew.brew")
end
if is_enabled("toggle_stats") then
  safe_require("items.toggle_stats.toggle_stats")
end
if is_enabled("netspeed") then
  safe_require("items.monitor.netspeed")
end
if is_enabled("cpu") then
  safe_require("items.monitor.cpu")
end
if is_enabled("mem") then
  safe_require("items.monitor.mem")
end
if is_enabled("music") then
  safe_require("items.music.music")
end

-- 🧱 Optional bracket (no border if battery text style)
if is_enabled("battery") and is_enabled("brew") then
  local border_width = 2
  if MODULES.battery and MODULES.battery.style == "text" then
    border_width = 0
  end

  SBAR.add("bracket", "stats_bracket", {
    is_enabled("battery") and "battery" or nil,
    is_enabled("brew") and "brew" or nil,
  }, {
    background = {
      color = COLORS.base,
      border_color = COLORS.surface0,
      border_width = border_width,
    },
  })
end
