-- Require the sketchybar module
SBAR = require("sketchybar")
LOG = require("helpers.debug_info")
COLORS = require("colors")
ICONS = require("icons")

require("settings")

SBAR.begin_config()

SBAR.bar({
    color = COLORS.base,
    height = PRESETS[PICKED_PRESET].HEIGHT,
    border_width = PRESETS[PICKED_PRESET].BOREDER_WIDTH,
    border_color = COLORS.surface0,
    corner_radius = PRESETS[PICKED_PRESET].CORNER_RADIUS,
    blur_radius = 15,
    shadow = { drawing = true },
    sticky = true,
    padding_right = PADDINGS,
    padding_left = PADDINGS,
    y_offset = 1,
    margin = PRESETS[PICKED_PRESET].MARGIN,
    notch_width = 200,
})

SBAR.default({
    updates = "when_shown",
    padding_left = PADDINGS,
    padding_right = PADDINGS,
    icon = {
        font = {
            family = FONT.nerd_font,
            style = FONT.style_map["Bold"],
            size = 16.0
        },
        color = COLORS.text,
        padding_left = PADDINGS,
        padding_right = PADDINGS,
        background = { image = { corner_radius = 9 } },
    },
    label = {
        font = {
            family = FONT.nerd_font,
            style = FONT.style_map["Bold"],
            size = 13.0
        },
        color = COLORS.text,
        padding_left = PADDINGS,
        padding_right = PADDINGS,
        shadow = {
            drawing = true,
            distance = 2,
            color = COLORS.crust,
        },
    },
    background = {
        height = 28,
        corner_radius = 9,
        border_width = 2,
        border_color = COLORS.surface1,
        image = {
            corner_radius = 9,
            border_color = COLORS.grey,
            border_width = 1
        }
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

require("items")
SBAR.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
SBAR.event_loop()
