-- 🔋 icon version (with popup)
local battery = SBAR.add("item", "battery", {
  position = "right",
  icon = { font = { size = 19.0 } },
  label = { drawing = false },
  update_freq = 180,
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
  local function getColor(battery_percent)
    if battery_percent <= 20 then
      return COLORS.red
    elseif battery_percent <= 40 then
      return COLORS.peach
    else
      return COLORS.green
    end
  end

  SBAR.exec("pmset -g batt", function(batt_info)
    local icon, color = "!", COLORS.green
    local _, _, charge = batt_info:find("(%d+)%%")
    if charge then
      charge = tonumber(charge)
    end
    local charging = batt_info:find("AC Power")

    if charging then
      icon = ICONS.battery.charging
      -- if charge >= 100 then
      --   icon = ICONS.battery.charging_100
      -- elseif charge >= 90 then
      --   icon = ICONS.battery.charging_90
      -- elseif charge >= 80 then
      --   icon = ICONS.battery.charging_80
      -- elseif charge >= 70 then
      --   icon = ICONS.battery.charging_70
      -- elseif charge >= 60 then
      --   icon = ICONS.battery.charging_60
      -- elseif charge >= 50 then
      --   icon = ICONS.battery.charging_50
      -- elseif charge >= 40 then
      --   icon = ICONS.battery.charging_40
      -- elseif charge >= 30 then
      --   icon = ICONS.battery.charging_30
      -- elseif charge >= 20 then
      --   icon = ICONS.battery.charging_20
      -- else
      --   icon = ICONS.battery.charging_10
      -- end
    else
      if charge then
        if charge > 80 then
          icon = ICONS.battery._100
        elseif charge > 60 then
          icon = ICONS.battery._75
        elseif charge > 40 then
          icon = ICONS.battery._50
        elseif charge > 20 then
          icon = ICONS.battery._25
        else
          icon = ICONS.battery._0
        end
      end
    end
    battery:set({ icon = { string = icon, color = getColor(charge) } })
  end)
end)

local battery_percent = SBAR.add("item", {
  position = "popup." .. battery.name,
  icon = { string = "Percentage:", width = 100, align = "left" },
  label = { string = "??%", width = 100, align = "right" },
})

local remaining_time = SBAR.add("item", {
  position = "popup." .. battery.name,
  icon = { string = "Time remaining:", width = 100, align = "left" },
  label = { string = "??:??h", width = 100, align = "right" },
})

battery:subscribe("mouse.clicked", function()
  local drawing = battery:query().popup.drawing
  battery:set({ popup = { drawing = "toggle" } })
  if drawing == "off" then
    SBAR.exec("pmset -g batt", function(batt_info)
      local _, _, charge = batt_info:find("(%d+)%%")
      battery_percent:set({ label = charge and (charge .. "%") or "N/A" })
      local _, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local time_label = remaining and (remaining .. "h") or "No estimate"
      remaining_time:set({ label = time_label })
    end)
  end
end)
