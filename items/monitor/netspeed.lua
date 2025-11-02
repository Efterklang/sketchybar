-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
SBAR.exec(
  "killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)

local upload_speed = SBAR.add("item", "widgets.wifi1", {
  position = "right",
  padding_left = -5,
  width = 0,
  icon = {
    padding_right = 0,
    font = {
      style = FONT.style_map["Bold"],
      size = 9.0,
    },
    string = ICONS.wifi.upload,
  },
  label = {
    font = {
      family = FONT.numbers,
      style = FONT.style_map["Bold"],
      size = 9.0,
    },
    color = COLORS.red,
    string = "??? Bps",
  },
  y_offset = 4,
})

local download_speed = SBAR.add("item", "widgets.wifi2", {
  position = "right",
  padding_left = -5,
  icon = {
    padding_right = 0,
    font = {
      style = FONT.style_map["Bold"],
      size = 9.0,
    },
    string = ICONS.wifi.download,
  },
  label = {
    font = {
      family = FONT.numbers,
      style = FONT.style_map["Bold"],
      size = 9.0,
    },
    color = COLORS.blue,
    string = "??? Bps",
  },
  y_offset = -4,
})

upload_speed:subscribe("network_update", function(env)
  local up_color = (env.upload == "000 Bps") and COLORS.grey or COLORS.red
  local down_color = (env.download == "000 Bps") and COLORS.grey or COLORS.blue
  upload_speed:set({
    icon = { color = up_color },
    label = {
      string = env.upload,
      color = up_color,
    },
  })
  download_speed:set({
    icon = { color = down_color },
    label = {
      string = env.download,
      color = down_color,
    },
  })
end)
