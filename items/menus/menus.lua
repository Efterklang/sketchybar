local menu_watcher = SBAR.add("item", {
  drawing = false,
  updates = false,
})
local space_menu_swap = SBAR.add("item", {
  drawing = false,
  updates = true,
})
SBAR.add("event", "swap_menus_and_spaces")

local max_items = 15
local menu_items = {}
for i = 1, max_items, 1 do
  local menu = SBAR.add("item", "menu." .. i, {
    padding_left = PADDINGS,
    padding_right = PADDINGS,
    drawing = false,
    icon = { drawing = false },
    label = {
      font = {
        style = FONT.style_map[i == 1 and "Heavy" or "Semibold"],
      },
      padding_left = 6,
      padding_right = 6,
    },
    click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s " .. i,
  })

  menu_items[i] = menu
end

SBAR.add("bracket", { "/menu\\..*/" }, {
  background = { color = COLORS.base },
})

local menu_padding = SBAR.add("item", "menu.padding", {
  drawing = false,
  width = 5,
})

local function update_menus(env)
  SBAR.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(menus)
    SBAR.set("/menu\\..*/", { drawing = false })
    menu_padding:set({ drawing = true })
    id = 1
    for menu in string.gmatch(menus, "[^\r\n]+") do
      if id < max_items then
        menu_items[id]:set({ label = menu, drawing = true })
      else
        break
      end
      id = id + 1
    end
  end)
end

menu_watcher:subscribe("front_app_switched", update_menus)

space_menu_swap:subscribe("swap_menus_and_spaces", function(env)
  local drawing = menu_items[1]:query().geometry.drawing == "on"
  if drawing then
    menu_watcher:set({ updates = false })
    SBAR.set("/menu\\..*/", { drawing = false })
    SBAR.set("/space\\..*/", { drawing = true })
    SBAR.set("front_app", { drawing = true })
  else
    menu_watcher:set({ updates = true })
    SBAR.set("/space\\..*/", { drawing = false })
    SBAR.set("front_app", { drawing = false })
    update_menus()
  end
end)

return menu_watcher
