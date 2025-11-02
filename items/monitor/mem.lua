local ram = SBAR.add("graph", "widgets.ram", 42, {
  position = "right",
  graph = { color = COLORS.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = ICONS.ram, color = COLORS.red },
  label = {
    string = "RAM ??%",
    font = {
      family = FONT.nerd_font,
      style = FONT.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  update_freq = 3,
  updates = "when_shown",
  padding_right = PADDINGS,
})

ram:subscribe({ "routine", "forced", "system_woke" }, function(env)
  SBAR.exec("memory_pressure", function(output)
    local percentage = output:match("System%-wide memory free percentage: (%d+)")
    local load = 100 - tonumber(percentage)
    ram:push({ load / 100. })
    local color = COLORS.blue
    if load > 30 then
      if load < 60 then
        color = COLORS.yellow
      elseif load < 80 then
        color = COLORS.orange
      else
        color = COLORS.red
      end
    end
    ram:set({
      graph = { color = color },
      label = { string = "RAM " .. load .. "%" },
    })
  end)
end)
