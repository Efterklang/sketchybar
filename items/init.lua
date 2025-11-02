local function safe_require(path)
  local ok, err = pcall(require, path)
  if not ok then
    print("⚠️ Failed to load " .. path .. ": " .. err)
  end
end

if MODULES.logo then
  safe_require("items.logo.apple")
end
if MODULES.menus then
  safe_require("items.menus.menus")
end
if MODULES.spaces then
  safe_require("items.spaces.spaces")
end
if MODULES.front_app then
  safe_require("items.front_app.front_app")
end

-- Right side
if MODULES.calendar then
  safe_require("items.calendar.calendar")
end
if MODULES.battery then
  safe_require("items.battery.battery")
end
if MODULES.wifi then
  safe_require("items.monitor.wifi")
end
if MODULES.volume then
  safe_require("items.volume.volume")
end
if MODULES.chat then
  safe_require("items.chat.qq_wechat")
end
if MODULES.brew then
  safe_require("items.brew.brew")
end

if MODULES.toggle_stats then
  safe_require("items.toggle_stats.toggle_stats")
end

if MODULES.netspeed then
  safe_require("items.monitor.netspeed")
end
if MODULES.cpu then
  safe_require("items.monitor.cpu")
end
if MODULES.mem then
  safe_require("items.monitor.mem")
end
if MODULES.music then
  safe_require("items.music.music")
end

-- Optional bracket (only if related modules are enabled)
if MODULES.battery or MODULES.brew then
  SBAR.add("bracket", "stats_bracket", {
    MODULES.battery and "battery" or nil,
    MODULES.brew and "brew" or nil,
  }, {
    background = {
      color = COLORS.base,
      border_color = COLORS.surface0,
      border_width = 2,
    },
  })
end
