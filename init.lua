require("settings")
SBAR = require("sketchybar")
LOG = require("helpers.debug_info")
COLORS = require("themes.init")
ICONS = require("icons")
GRAPH_UTILS = require("helpers.graph_utils")
SBAR.begin_config()

local preset_conf = PRESET_OPTIONS[PRESET] or PRESET_OPTIONS["gnix"]

SBAR.bar({
  color = COLORS.base,
  height = preset_conf.HEIGHT,
  border_width = preset_conf.BOREDER_WIDTH,
  border_color = COLORS.surface0,
  corner_radius = preset_conf.CORNER_RADIUS,
  blur_radius = 15,
  shadow = { drawing = true },
  sticky = true,
  font_smoothing = true,
  padding_right = PADDINGS,
  padding_left = PADDINGS,
  y_offset = preset_conf.Y_OFFSET,
  margin = preset_conf.MARGIN,
  notch_width = 200,
})

SBAR.default({
  updates = "when_shown",
  padding_left = PADDINGS,
  padding_right = PADDINGS,
  icon = {
    font = { family = FONT.icon_font, style = FONT.style_map["Bold"], size = 16.0 },
    color = COLORS.text,
    padding_left = PADDINGS,
    padding_right = PADDINGS,
    background = { image = { corner_radius = 9 } },
  },
  label = {
    font = { family = FONT.label_font, style = FONT.style_map["Bold"], size = 13.0 },
    color = COLORS.text,
    padding_left = PADDINGS,
    padding_right = PADDINGS,
    shadow = { drawing = false },
  },
  background = {
    height = 28,
    corner_radius = 9,
    border_width = 2,
    border_color = COLORS.surface1,
    image = { corner_radius = 9, border_color = COLORS.grey, border_width = 1 },
  },
  popup = {
    background = {
      border_width = 2,
      corner_radius = 9,
      border_color = COLORS.surface0,
      color = COLORS.base,
      shadow = { drawing = true },
    },
    blur_radius = 50,
    align = "center",
  },
  scroll_texts = true,
})

SBAR.exec("killall stats_provider >/dev/null; stats_provider --cpu usage --memory ram_usage --network en0 --interval 1", function()
  LOG:info("Started stats_provider_rust")
end)

require("items")

SBAR.end_config()
SBAR.event_loop()
