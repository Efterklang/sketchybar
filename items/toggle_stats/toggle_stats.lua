-- 添加自定义事件
SBAR.exec("sketchybar --add event hide_stats")
SBAR.exec("sketchybar --add event show_stats")
SBAR.exec("sketchybar --add event toggle_stats")

-- 需要控制显示/隐藏的 items
local stats_items = {
  "widgets.cpu",
  "widgets.wifi1",
  "widgets.wifi2",
  "widgets.ram",
}

-- 创建 separator_right item
local separator = SBAR.add("item", "separator_right", {
  position = "right",
  icon = {
    string = ICONS.stats_toggle.show,
    color = COLORS.lavender,
  },
  label = { drawing = false },
  background = {
    padding_left = PADDINGS,
    padding_right = 10,
  },
})

-- 创建隐藏的 animator item 用于处理事件
local animator = SBAR.add("item", "animator", {
  position = "right",
  drawing = false,
  updates = true,
})

-- 隐藏 stats
local function hide_stats()
  for _, item_name in ipairs(stats_items) do
    SBAR.set(item_name, { drawing = false })
  end
  separator:set({ icon = { string = ICONS.stats_toggle.hide } })
end

-- 显示 stats
local function show_stats()
  for _, item_name in ipairs(stats_items) do
    SBAR.set(item_name, { drawing = true })
  end
  separator:set({ icon = { string = ICONS.stats_toggle.show } })
end

-- 切换 stats
local function toggle_stats()
  local current_icon = separator:query().icon.value

  if current_icon == ICONS.stats_toggle.hide then
    show_stats()
  else
    hide_stats()
  end
end

-- separator 点击事件
separator:subscribe("mouse.clicked", function()
  SBAR.trigger("toggle_stats")
end)

-- animator 订阅事件
animator:subscribe("hide_stats", hide_stats)
animator:subscribe("show_stats", show_stats)
animator:subscribe("toggle_stats", toggle_stats)
