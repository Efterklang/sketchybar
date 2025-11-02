-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
SBAR.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = SBAR.add("graph", "widgets.cpu", 42, {
  position = "right",
  graph = { color = COLORS.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = ICONS.cpu, color = COLORS.yellow },
  label = {
    string = "CPU ??%",
    font = {
      family = FONT.numbers,
      style = FONT.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  padding_right = PADDINGS + 10,
})

cpu:subscribe("cpu_update", function(env)
  -- Also available: env.user_load, env.sys_load
  local load = tonumber(env.total_load)
  cpu:push({ load / 100. })

  local color = COLORS.blue
  if load > 30 then
    if load < 60 then
      color = COLORS.yellow
    elseif load < 80 then
      color = COLORS.peach
    else
      color = COLORS.red
    end
  end

  cpu:set({
    graph = { color = color },
    label = "CPU " .. env.total_load .. "%",
  })
end)

cpu:subscribe("mouse.clicked", function(env)
  SBAR.exec("open -a 'Activity Monitor'")
end)
