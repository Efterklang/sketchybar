-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
SBAR.exec(
  "killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0")

local popup_width = 250

local wifi_up = SBAR.add("item", "widgets.wifi1", {
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

local wifi_down = SBAR.add("item", "widgets.wifi2", {
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

local wifi = SBAR.add("item", "widgets.wifi.padding", {
  position = "right",
  label = { drawing = false },
})

-- Background around the item
local wifi_bracket = SBAR.add("bracket", "widgets.wifi.bracket", {
  wifi.name,
  wifi_up.name,
  wifi_down.name
}, {
  popup = { align = "center", height = 30 }
})

local ssid = SBAR.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    font = {
      style = FONT.style_map["Bold"]
    },
    string = ICONS.wifi.router,
  },
  width = popup_width,
  align = "center",
  label = {
    font = {
      size = 15,
      style = FONT.style_map["Bold"]
    },
    max_chars = 18,
    string = "????????????",
  },
  background = {
    height = 2,
    color = COLORS.grey,
    y_offset = -15
  }
})

local hostname = SBAR.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Hostname:",
    width = popup_width / 2,
  },
  label = {
    max_chars = 20,
    string = "????????????",
    width = popup_width / 2,
    align = "right",
  }
})

local ip = SBAR.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "IP:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  }
})

local mask = SBAR.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Subnet mask:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  }
})

local router = SBAR.add("item", {
  position = "popup." .. wifi_bracket.name,
  icon = {
    align = "left",
    string = "Router:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  },
})

SBAR.add("item", { position = "right", width = GROUP_PADDINGS })

wifi_up:subscribe("network_update", function(env)
  local up_color = (env.upload == "000 Bps") and COLORS.grey or COLORS.red
  local down_color = (env.download == "000 Bps") and COLORS.grey or COLORS.blue
  wifi_up:set({
    icon = { color = up_color },
    label = {
      string = env.upload,
      color = up_color
    }
  })
  wifi_down:set({
    icon = { color = down_color },
    label = {
      string = env.download,
      color = down_color
    }
  })
end)

wifi:subscribe({ "wifi_change", "system_woke" }, function(env)
  SBAR.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "")
    wifi:set({
      icon = {
        string = connected and ICONS.wifi.connected or ICONS.wifi.disconnected,
        color = connected and COLORS.blue or COLORS.red,
      },
    })
  end)
end)

local function hide_details()
  wifi_bracket:set({ popup = { drawing = false } })
end

local function toggle_details()
  local should_draw = wifi_bracket:query().popup.drawing == "off"
  if should_draw then
    wifi_bracket:set({ popup = { drawing = true } })
    SBAR.exec(
      "networksetup -listpreferredwirelessnetworks en0 | sed -n '2p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'",
      function(result)
        ssid:set({ label = result })
      end)
    SBAR.exec("networksetup -getcomputername", function(result)
      hostname:set({ label = result })
    end)
    SBAR.exec("ipconfig getifaddr en0", function(result)
      ip:set({ label = result })
    end)
    SBAR.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
      mask:set({ label = result })
    end)
    SBAR.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router:set({ label = result })
    end)
  else
    hide_details()
  end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
wifi_down:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
  local label = SBAR.query(env.NAME).label.value
  SBAR.exec("echo \"" .. label .. "\" | pbcopy")
  SBAR.set(env.NAME, { label = { string = ICONS.clipboard, align = "center" } })
  SBAR.delay(1, function()
    SBAR.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

ssid:subscribe("mouse.clicked", copy_label_to_clipboard)
hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)
