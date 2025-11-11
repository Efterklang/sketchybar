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
    font = { size = 9.0 },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  padding_right = PADDINGS + 10,
})

cpu:subscribe({ "system_stats" }, function(env)
  GRAPH_UTILS.update_graph(env.CPU_USAGE, cpu, "CPU")
end)

cpu:subscribe("mouse.clicked", function(env)
  SBAR.exec("open -a 'Activity Monitor'")
end)
