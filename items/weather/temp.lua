-- Weather item for sketchybar
-- Provides weather icon, temperature, and detailed forecast popup
-- Uses Weather.gov API for forecasts and wttr.in for detailed information

local http = require("socket.http")
local json = require("json")

-- Configuration
local CONFIG = {
  weathergov = {
    url = "https://api.weather.gov/gridpoints/",
    location = "LOC/104.074701,30.702457999999996", -- Will be overridden by weather_config.json or settings
    format = "forecast",
  },
  wttr = {
    url = "https://wttr.in/",
    location = "Chengdu", -- Will be overridden
    format = "format=2",
  },
}

-- Weather icon mapping based on conditions and time of day
local function weather_icon_map(is_daytime, forecast)
  local forecast_str = forecast or ""

  if is_daytime then -- Daytime
    if forecast_str:find("Snow", 1, true) then
      return ""
    elseif forecast_str:find("Rain", 1, true) then
      return ""
    elseif forecast_str:find("Partly Sunny", 1, true) or forecast_str:find("Partly Cloudy", 1, true) then
      return ""
    elseif forecast_str:find("Sunny", 1, true) then
      return ""
    elseif forecast_str:find("Cloudy", 1, true) then
      return ""
    else
      return "" -- Default sunny
    end
  else -- Nighttime
    if forecast_str:find("Snow", 1, true) then
      return ""
    elseif forecast_str:find("Rain", 1, true) then
      return ""
    elseif forecast_str:find("Clear", 1, true) then
      return ""
    elseif forecast_str:find("Cloudy", 1, true) then
      return ""
    elseif forecast_str:find("Fog", 1, true) then
      return ""
    else
      return "" -- Default moon
    end
  end
end

-- Fetch data from URL with timeout
local function fetch_url(url)
  local result = {}
  local request_completed = false

  local body, code = http.request(url)

  if code == 200 and body then
    return body
  else
    LOG:warn("Failed to fetch URL: " .. url .. " (HTTP " .. tostring(code) .. ")")
    return nil
  end
end

-- Parse weather data from Weather.gov API
local function get_weather_data()
  local url = CONFIG.weathergov.url .. CONFIG.weathergov.location .. "/" .. CONFIG.weathergov.format
  local response = fetch_url(url)

  if not response then
    return nil
  end

  local ok, data = pcall(json.decode, response)
  if not ok or not data or not data.properties or not data.properties.periods or #data.properties.periods == 0 then
    LOG:warn("Invalid weather.gov response")
    return nil
  end

  local current = data.properties.periods[1]
  return {
    temperature = current.temperature or "N/A",
    forecast = current.shortForecast or "Unknown",
    is_daytime = current.isDaytime == true,
    periods = data.properties.periods,
    raw_data = data,
  }
end

-- Parse weather data from wttr.in
local function get_wttr_data()
  local url = CONFIG.wttr.url .. CONFIG.wttr.location .. "?" .. CONFIG.wttr.format
  local response = fetch_url(url)

  if not response then
    return nil
  end

  -- wttr.in returns formatted text, clean up extra spaces
  return response:gsub("  +", " ")
end

-- Update bar display (icon and temperature)
local function update_bar(weather_item, weather_data)
  if not weather_data then
    weather_item:set({
      icon = { string = "" },
      label = { string = "N/A" },
    })
    return
  end

  local icon = weather_icon_map(weather_data.is_daytime, weather_data.forecast)
  local temp_label = tostring(weather_data.temperature) .. "°"

  weather_item:set({
    icon = { string = icon },
    label = { string = temp_label },
  })
end

-- Split text into sentences
local function split_sentences(text)
  local sentences = {}
  for sentence in text:gmatch("[^.!?]+[.!?]") do
    table.insert(sentences, sentence:match("^%s*(.-)%s*$"))
  end
  return sentences
end

-- Update popup display with detailed forecast
local function update_popup(weather_item, weather_data, wttr_data)
  -- Remove old popup items
  SBAR.exec("sketchybar --remove '/weather\\.details\\..*/g' 2>/dev/null || true")

  if not weather_data then
    return
  end

  local popup_position = "popup." .. weather_item.name
  local counter = 0

  -- Add header with current conditions
  local header = SBAR.add("item", "weather.details." .. counter, {
    position = popup_position,
    label = {
      string = (weather_data.forecast or "") .. " " .. (wttr_data or ""),
      padding_left = 80,
      drawing = true,
    },
    icon = { drawing = false },
    click_script = "sketchybar --set $NAME popup.drawing=off",
  })

  -- Add forecast periods (up to 3)
  if weather_data.periods and #weather_data.periods > 0 then
    for period_idx = 1, math.min(3, #weather_data.periods) do
      counter = counter + 1
      local period = weather_data.periods[period_idx]

      local period_name = period.name or ("Period " .. tostring(period_idx))
      local temperature = period.temperature or "N/A"
      local temp_unit = period.temperatureUnit or "F"
      local detailed = period.detailedForecast or ""

      -- Add period header
      SBAR.add("item", "weather.details." .. counter, {
        position = popup_position,
        icon = {
          string = period_name .. " - " .. temperature .. " " .. temp_unit,
          color = COLORS.blue,
          drawing = true,
        },
        label = { drawing = false },
        click_script = "sketchybar --set $NAME popup.drawing=off",
      })

      -- Add period sentences
      local sentences = split_sentences(detailed)
      for sent_idx, sentence in ipairs(sentences) do
        counter = counter + 1
        SBAR.add("item", "weather.details." .. counter, {
          position = popup_position,
          label = {
            string = sentence,
            drawing = true,
          },
          icon = { drawing = false },
          click_script = "sketchybar --set $NAME popup.drawing=off",
        })
      end

      -- Add newline separator
      counter = counter + 1
      SBAR.add("item", "weather.details.newline." .. counter, {
        position = popup_position,
        label = { drawing = true },
        icon = { drawing = false },
      })
    end
  end
end

-- Main update function
local function update_weather(weather_item)
  LOG:info("Updating weather...")

  local weather_data = get_weather_data()
  local wttr_data = get_wttr_data()

  update_bar(weather_item, weather_data)
  update_popup(weather_item, weather_data, wttr_data)
end

-- Create weather items
-- Icon item

-- Details popup container (invisible, used for positioning)
SBAR.add("item", "weather.details", {
  position = "popup.weather.temp",
  label = { drawing = false },
  icon = { drawing = false },
  drawing = false,
  background = {
    corner_radius = 12,
    drawing = true,
  },
  padding_left = 7,
  padding_right = 7,
})

-- Subscribe to events
wttr_temperature:subscribe("routine", function()
  update_weather(wttr_temperature)
end)

wttr_temperature:subscribe("mouse.entered", function()
  wttr_temperature:set({ popup = { drawing = true } })
end)

wttr_temperature:subscribe("mouse.exited", function()
  wttr_temperature:set({ popup = { drawing = false } })
end)

wttr_temperature:subscribe("mouse.exited.global", function()
  wttr_temperature:set({ popup = { drawing = false } })
end)

wttr_temperature:subscribe("mouse.clicked", function()
  wttr_temperature:set({ popup = { drawing = "toggle" } })
end)

-- Initial update
update_weather(wttr_temperature)

LOG:info("Weather item initialized")
