-- Padding item required because of bracket
SBAR.add("item", { position = "right", width = PADDINGS + 6 })

local cal_date = SBAR.add("item", {
  position = "right",
  padding_left = -5,
  width = 0,
  label = {
    color = COLORS.lavender,
    font = {
      size = 13.0,
    },
  },
  y_offset = 6,
})

local cal_time = SBAR.add("item", {
  position = "right",
  padding_left = -5,
  label = {
    color = COLORS.lavender,
    font = {
      size = 12.0,
    },
  },
  y_offset = -6,
})

-- Double border for calendar using a single item bracket
local cal_bracket = SBAR.add("bracket", { cal_date.name, cal_time.name }, {
  update_freq = 1,
})

-- Padding item required because of bracket
SBAR.add("item", { position = "right", width = PADDINGS })

cal_bracket:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal_date:set({ label = { string = os.date("%a %b %d") } })
  cal_time:set({ label = { string = os.date("%H:%M:%S %p") } })
end)

local function click_event()
  SBAR.exec("open -a Calendar")
end

cal_date:subscribe("mouse.clicked", click_event)
cal_time:subscribe("mouse.clicked", click_event)
