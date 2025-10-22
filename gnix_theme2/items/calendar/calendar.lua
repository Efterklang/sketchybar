-- Padding item required because of bracket
SBAR.add("item", { position = "right", width = GROUP_PADDINGS })

local cal = SBAR.add("item", {
  icon = {
    color = COLORS.lavender,
    padding_left = 8,
    font = {
      family = FONT.numbers,
      style = FONT.style_map["Bold"],
      size = 14.0,
    },
  },
  label = {
    color = COLORS.subtext0,
    padding_right = 8,
    width = 67,
    align = "right",
    font = { family = FONT.numbers, size = 13.0 },
  },
  position = "right",
  update_freq = 1,
  padding_left = 1,
  padding_right = 1,
  click_script = "open -a 'Calendar'"
})

-- Padding item required because of bracket
SBAR.add("item", { position = "right", width = GROUP_PADDINGS })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%b.%d"), label = os.date(" %H:%M:%S") })
end)
