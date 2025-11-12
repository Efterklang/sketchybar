local upload_speed = SBAR.add("item", "widgets.upload_speed", {
  position = "right",
  padding_left = -5,
  width = 0,
  icon = {
    padding_right = 0,
    font = { size = 9.0 },
    string = ICONS.wifi.upload,
  },
  label = {
    font = { size = 9.0 },
    color = COLORS.red,
    string = "??? KB/s",
  },
  y_offset = 4,
})

local download_speed = SBAR.add("item", "widgets.download_speed", {
  position = "right",
  padding_left = -5,
  icon = {
    padding_right = 0,
    font = { size = 9.0 },
    string = ICONS.wifi.download,
  },
  label = {
    font = { size = 9.0 },
    color = COLORS.blue,
    string = "??? KB/s",
  },
  y_offset = -4,
})

local function format_speed(speed_str)
  local speed = tonumber(speed_str)
  if speed < 1024 then
    return string.format("%d KB/s", speed)
  elseif speed < 1024 * 1024 then
    return string.format("%.1f MB/s", speed / 1024)
  else
    return string.format("%.1f GB/s", speed / (1024 * 1024))
  end
end

upload_speed:subscribe("system_stats", function(env)
  local up_color = (env.NETWORK_TX_en0 == "0") and COLORS.grey or COLORS.red
  local down_color = (env.NETWORK_RX_en0 == "0") and COLORS.grey or COLORS.blue

  local tx = format_speed(env.NETWORK_TX_en0)
  local rx = format_speed(env.NETWORK_RX_en0)
  -- make tx, rx string length equal for better alignment
  if #tx < #rx then
    tx = string.rep("0", #rx - #tx) .. tx
  elseif #rx < #tx then
    rx = string.rep("0", #tx - #rx) .. rx
  end

  upload_speed:set({
    icon = { color = up_color },
    label = { string = tx, color = up_color },
  })
  download_speed:set({
    icon = { color = down_color },
    label = { string = rx, color = down_color },
  })
end)
