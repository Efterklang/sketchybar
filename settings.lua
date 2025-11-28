--- @type "macos_native" | "aerospace"
WINDOW_MANAGER = "macos_native"
--- @type "gnix" | "compact"
PRESET = "gnix"
--- @type "catppuccin_mocha" | "catppuccin_latte" | "rose_pine" | "tokyo_night"
THEME = "catppuccin_mocha"

SBAR_HOME = (os.getenv("HOME") or "~") .. "/.config/sketchybar/"
ITEMS_HOME = SBAR_HOME .. "items/"
HELPERS_HOME = SBAR_HOME .. "helpers/"

PRESET_OPTIONS = {
  gnix = {
    BOREDER_WIDTH = 3,
    HEIGHT = 32,
    Y_OFFSET = 1,
    MARGIN = 5,
    CORNER_RADIUS = 10,
  },
  compact = {
    BOREDER_WIDTH = 0,
    HEIGHT = 27,
    Y_OFFSET = 0,
    MARGIN = 0,
    CORNER_RADIUS = 0,
  },
}

FONT = {
  icon_font = "Maple Mono NF CN",
  label_font = "Maple Mono NF CN", -- SF Mono, Monaspace Radon
  style_map = {
    ["Regular"] = "Regular",
    ["Semibold"] = "Medium",
    ["Bold"] = "Bold",
    ["Black"] = "ExtraBold",
  },
}

MODULES = {
  logo = { enable = true },
  menus = { enable = true },
  spaces = { enable = true },
  front_app = { enable = true },
  calendar = { enable = true },
  battery = { enable = true, style = "icon" },
  wifi = { enable = true },
  volume = { enable = true },
  chat = { enable = true },
  brew = { enable = true },
  toggle_stats = { enable = true },
  netspeed = { enable = true },
  cpu = { enable = true },
  mem = { enable = true },
  music = { enable = true },
}

SPACES = {
  --- @type "greek_uppercase" | "greek_lowercase" | nil
  ID_STYLE = "greek_uppercase",
  ITEM_PADDING = 12,
}

MUSIC = {
  CONTROLLER = "media-control",
  ALBUM_ART_SIZE = 1280,
  TITLE_MAX_CHARS = 15,
  DEFAULT_ARTIST = "Various Artists",
  DEFAULT_ALBUM = "No Album",
  DEFAULT_ALBUM_ART_PATH = ITEMS_HOME .. "music/default_albumarts/various_artists_mocha.jpg",
  POPUP_WIDTH = 80,
  POPUP_ITEMS = { shuffle = false, repeating = false },
}

WIFI = { PROXY_APP = "FlClash" }

PADDINGS = 3
GROUP_PADDINGS = 5
