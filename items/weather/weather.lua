require("items.weather.services.get_weather")

local wttr_icon = SBAR.add("item", "weather.icon", {
  position = "right",
  padding_left = -5,
  width = 0,
  icon = {
    string = " ",
    color = COLORS.lavender,
    font = {
      size = 13.0,
    },
  },
  y_offset = 6,
})

-- Temperature/main item with popup
local wttr_temperature = SBAR.add("item", "weather.temp", {
  position = "right",
  padding_left = -5,
  padding_right = 0,
  label = {
    string = "temp",
    color = COLORS.lavender,
    font = {
      size = 12.0,
    },
  },
  y_offset = -6,
  update_freq = 600,
})
