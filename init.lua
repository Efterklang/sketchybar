-- Require the sketchybar module
SBAR = require("sketchybar")
LOG = require("helpers.debug_info")

-- #region Global Variables
-- This section contains configuration variables used throughout the theme
-- Feel free to modify these variables to customize the theme to your liking
FONT = {
    nerd_font = "Maple Mono NF CN",
    numbers = "Maple Mono NF CN",
    style_map = {
        ["Regular"] = "Regular",
        ["Semibold"] = "Medium",
        ["Bold"] = "Bold",
        ["Black"] = "ExtraBold",
    },
}
-- options: "macos_native", "aerospace"(experimental)
WINDOW_MANAGER = "macos_native"
PADDINGS = 3
GROUP_PADDINGS = 5
-- Colors for the theme, default is catppuccin-mocha
COLORS = require("colors")
-- Font for sketchybar items
ICONS = require("icons")

-- #endregion Config Variables

SBAR.begin_config()

SBAR.bar({
    height = 35,
    color = COLORS.base,
    border_width = 3,
    border_color = COLORS.surface0,
    corner_radius = 10,
    blur_radius = 15,
    shadow = { drawing = true },
    sticky = true,
    padding_right = PADDINGS,
    padding_left = PADDINGS,
    y_offset = 1,
    margin = 5,
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
    },
    scroll_texts = true,
})

require("items")
SBAR.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
SBAR.event_loop()
