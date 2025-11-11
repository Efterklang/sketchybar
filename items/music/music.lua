local client

if MUSIC.CONTROLLER == "media-control" then
  LOG:info("Using media-control as music controller")
  client = require("items.music.controller.media-control")
elseif MUSIC.CONTROLLER == "mpc" then
  LOG:info("Using mpc as music controller")
  client = require("items.music.controller.mpc")
else
  LOG:info("No valid media controller specified, defaulting to media-control")
  client = require("items.music.controller.media-control")
end

local POPUP_HEIGHT = 120
local IMAGE_SCALE = 0.15
local Y_OFFSET = -5

--- @type number the delay between `media control` command and `info fetch` command; This should be adjusted based on system performance.
-- After sending a next_track command, the track info might not update immediately.
-- That is to say, running `media-control get` right after `media-control next-track` may still return the old track info.
local DELAY_TIME = 0.2

local music_anchor = SBAR.add("item", "music.anchor", {
  position = "right",
  update_freq = 1,
  padding_right = PADDINGS + 6,
  icon = {
    string = "􁁒",
    font = { size = 20.0 },
    color = COLORS.lavender,
    y_offset = 2,
  },
  label = {
    max_chars = MUSIC.TITLE_MAX_CHARS,
    padding_left = PADDINGS,
    color = COLORS.lavender,
  },
  popup = {
    horizontal = true,
    height = POPUP_HEIGHT,
  },
})

local popup_position = "popup." .. music_anchor.name

local albumart = SBAR.add("item", "music.cover", {
  position = popup_position,
  label = { drawing = false },
  icon = { drawing = false },
  padding_right = 10,
  background = {
    image = {
      string = "/tmp/music_cover.jpg",
    },
  },
})

local track_title = SBAR.add("item", "music.title", {
  position = popup_position,
  icon = { drawing = false },
  padding_left = 0,
  padding_right = 0,
  width = 0,
  label = {
    font = { size = 20.0 },
    max_chars = MUSIC.TITLE_MAX_CHARS,
    color = COLORS.mauve,
    shadow = {
      drawing = false,
    },
  },
  y_offset = 80 + Y_OFFSET,
})

local track_artist = SBAR.add("item", "music.artist", {
  position = popup_position,
  icon = { drawing = false },
  y_offset = 50 + Y_OFFSET,
  padding_left = 0,
  padding_right = 0,
  width = 0,
  align = "center",
  label = {
    font = { size = 15.0 },
    max_chars = 20,
    color = COLORS.blue,
  },
})

local track_album = SBAR.add("item", "music.album", {
  position = popup_position,
  icon = { drawing = false },
  padding_left = 0,
  padding_right = 0,
  y_offset = 25 + Y_OFFSET,
  width = 0,
  label = {
    font = { size = 15.0 },
    max_chars = 20,
    color = COLORS.lavender,
  },
})

-- #region Playback Controls
local CONTROLS_Y_OFFSET = -55 + Y_OFFSET

local shuffle_btn = SBAR.add("item", "music.shuffle", {
  position = popup_position,
  icon = {
    string = ICONS.media.shuffle,
    padding_left = 5,
    padding_right = 5,
    color = COLORS.grey,
    highlight_color = COLORS.lavender,
  },
  label = { drawing = false },
  y_offset = CONTROLS_Y_OFFSET,
})

local prev_btn = SBAR.add("item", "music.back", {
  position = popup_position,
  icon = {
    string = ICONS.media.back,
    padding_left = 5,
    padding_right = 5,
    color = COLORS.grey,
  },
  label = { drawing = false },
  y_offset = CONTROLS_Y_OFFSET,
})

local play_btn = SBAR.add("item", "music.play", {
  position = popup_position,
  background = {
    height = 40,
    corner_radius = 20,
    color = COLORS.surface0,
    border_color = COLORS.surface1,
    border_width = 2,
    drawing = true,
  },
  width = 40,
  align = "center",
  icon = {
    string = ICONS.media.pause,
    padding_left = 4,
    padding_right = 4,
    color = COLORS.red,
  },
  label = { drawing = false },
  y_offset = CONTROLS_Y_OFFSET,
})

local next_btn = SBAR.add("item", "music.next", {
  position = popup_position,
  icon = {
    string = ICONS.media.forward,
    padding_left = 5,
    padding_right = 5,
    color = COLORS.grey,
  },
  label = { drawing = false },
  y_offset = CONTROLS_Y_OFFSET,
})

local repeat_btn = SBAR.add("item", "music.repeat", {
  position = popup_position,
  icon = {
    string = ICONS.media.repeating,
    highlight_color = COLORS.lavender,
    padding_left = 5,
    padding_right = 10,
    color = COLORS.grey,
  },
  label = { drawing = false },
  y_offset = CONTROLS_Y_OFFSET,
})

SBAR.add("item", "music.spacer", {
  position = popup_position,
  width = 5,
})

SBAR.add("bracket", "music.controls", {
  shuffle_btn.name,
  prev_btn.name,
  play_btn.name,
  next_btn.name,
  repeat_btn.name,
}, {
  background = {
    color = COLORS.surface0,
    corner_radius = 11,
    drawing = true,
  },
  y_offset = CONTROLS_Y_OFFSET,
})
-- #endregion ...

-- #region Callbacks functions for updating music info
local track_info_updater = function(title, artist, album)
  music_anchor:set({ label = title })
  track_title:set({ label = title })
  -- 检查是否为空字符串或nil
  local display_artist = (artist and artist ~= "") and artist or MUSIC.DEFAULT_ARTIST
  local display_album = (album and album ~= "") and album or MUSIC.DEFAULT_ALBUM

  track_artist:set({ label = display_artist })
  track_album:set({ label = display_album })
end

local albumart_updater = function(path)
  LOG:info("Updating album art with path: " .. path)
  albumart:set({
    background = {
      image = {
        string = path,
        scale = IMAGE_SCALE,
        drawing = true,
      },
      drawing = true,
    },
  })
end

local icon_updater = function(is_playing, is_repeat, is_shuffle)
  if is_playing then
    play_btn:set({
      icon = { string = ICONS.media.play, color = COLORS.green },
    })
  else
    play_btn:set({
      icon = { string = ICONS.media.pause, color = COLORS.red },
    })
  end

  if is_shuffle then
    shuffle_btn:set({ icon = { highlight = true } })
  else
    shuffle_btn:set({ icon = { highlight = false } })
  end

  if is_repeat then
    repeat_btn:set({ icon = { highlight = true } })
  else
    repeat_btn:set({ icon = { highlight = false } })
  end
end
-- #endregion Updaters

-- #region Event
music_anchor:subscribe("routine", function()
  client.update_current_track(track_info_updater)
end)

music_anchor:subscribe("mouse.clicked", function()
  music_anchor:set({ popup = { drawing = "toggle" } })
  client.update_album_art(albumart_updater)
  client.stats(icon_updater)
end)

play_btn:subscribe("mouse.clicked", function()
  client.toggle_play()
  SBAR.exec("sleep " .. DELAY_TIME, function()
    client.stats(icon_updater)
  end)
end)

shuffle_btn:subscribe("mouse.clicked", function()
  client.toggle_shuffle()
  SBAR.exec("sleep " .. DELAY_TIME, function()
    client.stats(icon_updater)
  end)
end)

repeat_btn:subscribe("mouse.clicked", function()
  client.toggle_repeat()
  SBAR.exec("sleep " .. DELAY_TIME, function()
    client.stats(icon_updater)
  end)
end)

prev_btn:subscribe("mouse.clicked", function()
  client.prev_track()
  SBAR.exec("sleep " .. DELAY_TIME, function()
    client.update_album_art(albumart_updater)
    client.update_current_track(track_info_updater)
    client.stats(icon_updater)
  end)
end)

next_btn:subscribe("mouse.clicked", function()
  client.next_track()
  SBAR.exec("sleep " .. DELAY_TIME, function()
    client.update_album_art(albumart_updater)
    client.update_current_track(track_info_updater)
    client.stats(icon_updater)
  end)
end)
-- #endregion Event
