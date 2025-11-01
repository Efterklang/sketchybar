-- #region Default configuration variables
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

-- Default Preset
PRESET = "Gnix"
PRESET_OPTIONS = {
    -- my personal configurations
    Gnix = {
        BOREDER_WIDTH = 3,
        HEIGHT = 32,
        MARGIN = 5,
        CORNER_RADIUS = 10,
    },
    Compact = {
        BOREDER_WIDTH = 0,
        HEIGHT = 28,
        MARGIN = 0,
        CORNER_RADIUS = 0,
    }
}

-- options: "macos_native", "aerospace"(experimental)
WINDOW_MANAGER = "macos_native"
-- options: "greek_uppercase", "greek_lowercase", nil(use space name/number as label)
SPACE_LABEL = "greek_uppercase"

-- options: "mpc", "media-control"(todo)
MUSIC = {
    CONTROLLER = "media-control",
    ALBUM_ART_SIZE = 1280,
    TITLE_MAX_CHARS = 15,
    DEFAULT_ARTIST = "Various Artists",
    DEFAULT_ALBUM = "No Album",
    POPUP_WIDTH = 80,
    POPUP_ITEMS = {
        shuffle = false,
        repeating = false,
    },
}

WIFI = {
    PROXY_APP = "FlClash"
}

PADDINGS = 3
GROUP_PADDINGS = 5

-- Load user settings if they exist
local settings_file = "settings.lua"
local f = io.open(settings_file, "r")
if f ~= nil then
    io.close(f)
    require("settings")
end
-- #endregion Configurations

-- Require the sketchybar module
SBAR = require("sketchybar")
LOG = require("helpers.debug_info")
COLORS = require("colors")
ICONS = require("icons")

SBAR.begin_config()

SBAR.bar({
    color = COLORS.base,
    height = PRESET_OPTIONS[PRESET].HEIGHT,
    border_width = PRESET_OPTIONS[PRESET].BOREDER_WIDTH,
    border_color = COLORS.surface0,
    corner_radius = PRESET_OPTIONS[PRESET].CORNER_RADIUS,
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
