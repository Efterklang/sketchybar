local helpers_path = os.getenv("HOME") .. "/.config/sketchybar/helpers/"

local front_app = SBAR.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    font = {
      family = FONT.nerd_font,
      style = FONT.style_map["Bold"],
      size = 14.0,
    },
  },
  updates = true,
  click_script = helpers_path .. "sketchymenu/app_menu.sh toggle",
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)
