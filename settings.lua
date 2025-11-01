-- Global configuration variables
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
PICKED_PRESET = "Gnix"
PRESETS = {
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
-- options: "macos_native", "aerospace"(experimental) WINDOW_MANAGER = "macos_native"
-- options: "greek_uppercase", "greek_lowercase", nil(use space name/number as label)
SPACE_LABEL = "greek_uppercase"
-- options: "mpc", "media-control"(todo)
MEDIA_CONTROLLER = "media-control"
ALBUM_ART_SIZE = 1280
MUSIC_TITLE_MAX_CHARS = 10
MUSIC_DEFAULT_ARTIST = "Various Artists"
MUSIC_DEFAULT_ALBUM = "No Album"
PADDINGS = 3
GROUP_PADDINGS = 5
