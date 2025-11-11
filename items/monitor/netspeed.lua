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
    string = "??? Bps",
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
    string = "??? Bps",
  },
  y_offset = -4,
})

upload_speed:subscribe("system_stats", function(env)
  local up_color = (env.NETWORK_TX_en0 == "0KB/s") and COLORS.grey or COLORS.red
  local down_color = (env.NETWORK_RX_en0 == "0KB/s") and COLORS.grey or COLORS.blue
  upload_speed:set({
    icon = { color = up_color },
    label = {
      string = env.NETWORK_TX_en0,
      color = up_color,
    },
  })
  download_speed:set({
    icon = { color = down_color },
    label = {
      string = env.NETWORK_RX_en0,
      color = down_color,
    },
  })
end)
