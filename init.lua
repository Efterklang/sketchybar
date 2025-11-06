-- #region 🧠 Default Configuration

local defaults = {
  WINDOW_MANAGER = "macos_native",
  PRESET = "gnix",

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
  },

  FONT = {
    nerd_font = "Maple Mono NF CN",
    numbers = "Maple Mono NF CN",
    style_map = {
      ["Regular"] = "Regular",
      ["Semibold"] = "Medium",
      ["Bold"] = "Bold",
      ["Black"] = "ExtraBold",
    },
  },

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
  },

  SPACE_LABEL = "greek_uppercase",
  SPACE_ITEM_PADDING = 12,

  MUSIC = {
    CONTROLLER = "media-control",
    ALBUM_ART_SIZE = 1280,
    TITLE_MAX_CHARS = 15,
    DEFAULT_ARTIST = "Various Artists",
    DEFAULT_ALBUM = "No Album",
    POPUP_WIDTH = 80,
    POPUP_ITEMS = { shuffle = false, repeating = false },
  },

  WIFI = { PROXY_APP = "FlClash" },

  PADDINGS = 3,
  GROUP_PADDINGS = 5,
}

-- #endregion

-- #region 🧩 Deep Merge Helpers

local function deep_merge(base, override)
  for k, v in pairs(override) do
    if type(v) == "table" and type(base[k]) == "table" then
      deep_merge(base[k], v)
    else
      base[k] = v
    end
  end
end

-- #endregion

-- #region ⚙️ Load User Settings

local user = {}
local ok, cfg = pcall(require, "settings")
if ok and type(cfg) == "table" then
  user = cfg
else
  print("[SketchyBar] ⚠️ No valid settings.lua found or returned table, using defaults.")
end

deep_merge(defaults, user)

-- Promote merged config to globals for other modules
WINDOW_MANAGER = defaults.WINDOW_MANAGER
PRESET = defaults.PRESET
PRESET_OPTIONS = defaults.PRESET_OPTIONS
FONT = defaults.FONT
MODULES = defaults.MODULES
SPACE_LABEL = defaults.SPACE_LABEL
SPACE_ITEM_PADDING = defaults.SPACE_ITEM_PADDING
MUSIC = defaults.MUSIC
WIFI = defaults.WIFI
PADDINGS = defaults.PADDINGS
GROUP_PADDINGS = defaults.GROUP_PADDINGS

-- Normalize booleans (for backward compatibility)
for name, conf in pairs(MODULES) do
  if type(conf) == "boolean" then
    MODULES[name] = { enable = conf }
  elseif conf.enable == nil then
    conf.enable = true
  end
end

-- #endregion

-- #region 🎨 Apply SketchyBar Configuration

SBAR = require("sketchybar")
LOG = require("helpers.debug_info")
COLORS = require("colors")
ICONS = require("icons")

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
    font = { family = FONT.nerd_font, style = FONT.style_map["Bold"], size = 16.0 },
    color = COLORS.text,
    padding_left = PADDINGS,
    padding_right = PADDINGS,
    background = { image = { corner_radius = 9 } },
  },
  label = {
    font = { family = FONT.nerd_font, style = FONT.style_map["Bold"], size = 13.0 },
    color = COLORS.text,
    padding_left = PADDINGS,
    padding_right = PADDINGS,
    shadow = { drawing = true, distance = 2, color = COLORS.crust },
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

require("items")

SBAR.end_config()
SBAR.event_loop()

-- #endregion
