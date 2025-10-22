local front_app = SBAR.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    font = {
      family = FONT.nerd_font,
      style = FONT.style_map["Bold"],
      size = 14.0
    },
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function()
  SBAR.trigger("swap_menus_and_spaces")
end)
