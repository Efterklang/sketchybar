local client = require("items.music.controller.mpc")

local MUSIC_FONT = "Maple Mono NF CN"
local POPUP_HEIGHT = 120
local IMAGE_SCALE = 0.15
local Y_OFFSET = -5

local music_anchor = SBAR.add("item", "music.anchor", {
    position = "right",
    update_freq = 1,
    icon = {
        string = "􁁒",
        font = {
            family = "SF Pro",
            style = FONT.style_map["Bold"],
            size = 20.0,
        },
        color = COLORS.lavender,
        y_offset = 2,
    },
    label = {
        font = {
            family = MUSIC_FONT,
            style = FONT.style_map["Bold"],
            size = 14.0,
        },
        padding_left = PADDINGS,
        y_offset = 2,
        color = COLORS.lavender,
    },
    popup = {
        horizontal = true,
        align = "center",
        height = POPUP_HEIGHT,
    }
})

local albumart = SBAR.add("item", "music.cover", {
    position = "popup." .. music_anchor.name,
    label = { drawing = false },
    icon = { drawing = false },
    padding_left = 12,
    padding_right = 10,
    background = {
        image = {
            string = "/tmp/music_cover.jpg",
            scale = 0.85,
        }
    }
})

local track_title = SBAR.add("item", "music.title", {
    position = "popup." .. music_anchor.name,
    icon = { drawing = false },
    padding_left = 0,
    padding_right = 0,
    width = 0,
    label = {
        font = {
            family = MUSIC_FONT,
            style = FONT.style_map["Bold"],
            size = 15.0,
        },
        max_chars = 20,
        color = COLORS.mauve,
    },
    y_offset = 50 + Y_OFFSET,
})

local track_artist = SBAR.add("item", "music.artist", {
    position = "popup." .. music_anchor.name,
    icon = { drawing = false },
    y_offset = 30 + Y_OFFSET,
    padding_left = 0,
    padding_right = 0,
    width = 0,
    label = {
        font = {
            family = MUSIC_FONT,
            style = FONT.style_map["Bold"],
            size = 14.0,
        },
        max_chars = 20,
        color = COLORS.lavender,
    }
})

local track_album = SBAR.add("item", "music.album", {
    position = "popup." .. music_anchor.name,
    icon = { drawing = false },
    padding_left = 0,
    padding_right = 0,
    y_offset = 15 + Y_OFFSET,
    width = 0,
    label = {
        font = {
            family = MUSIC_FONT,
            style = FONT.style_map["Regular"],
            size = 14.0,
        },
        max_chars = 20,
        color = COLORS.subtext1,
    }
})

-- #region Playback Controls
local CONTROLS_Y_OFFSET = -30 + Y_OFFSET

local music_shuffle = SBAR.add("item", "music.shuffle", {
    position = "popup." .. music_anchor.name,
    icon = {
        string = "􀊝",
        padding_left = 5,
        padding_right = 5,
        color = COLORS.grey,
        highlight_color = COLORS.lavender,
    },
    label = { drawing = false },
    y_offset = CONTROLS_Y_OFFSET
})

local music_prev = SBAR.add("item", "music.back", {
    position = "popup." .. music_anchor.name,
    icon = {
        string = "􀊎",
        padding_left = 5,
        padding_right = 5,
        color = COLORS.grey,
    },
    label = { drawing = false },
    y_offset = CONTROLS_Y_OFFSET
})

local music_play = SBAR.add("item", "music.play", {
    position = "popup." .. music_anchor.name,
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
        string = "􀊄",
        padding_left = 4,
        padding_right = 4,
        color = COLORS.red,
    },
    label = { drawing = false },
    y_offset = CONTROLS_Y_OFFSET,
})

local music_next = SBAR.add("item", "music.next", {
    position = "popup." .. music_anchor.name,
    icon = {
        string = "􀊐",
        padding_left = 5,
        padding_right = 5,
        color = COLORS.grey,
    },
    label = { drawing = false },
    y_offset = CONTROLS_Y_OFFSET
})

local music_repeat = SBAR.add("item", "music.repeat", {
    position = "popup." .. music_anchor.name,
    icon = {
        string = "􀊞",
        highlight_color = COLORS.lavender,
        padding_left = 5,
        padding_right = 10,
        color = COLORS.grey,
    },
    label = { drawing = false },
    y_offset = CONTROLS_Y_OFFSET
})

SBAR.add("item", "music.spacer", {
    position = "popup." .. music_anchor.name,
    width = 5,
})

SBAR.add("bracket", "music.controls", {
    music_shuffle.name,
    music_prev.name,
    music_play.name,
    music_next.name,
    music_repeat.name,
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
    track_artist:set({ label = artist })
    track_album:set({ label = album })
end

local albumart_updater = function()
    albumart:set({
        background = {
            image = {
                string = "/tmp/music_cover.jpg",
                scale = IMAGE_SCALE,
                drawing = true,
            },
            drawing = true,
        }
    })
end

local icon_updater = function(is_playing, is_repeat, is_shuffle)
    if is_playing then
        music_play:set({
            icon = { string = "􀊆", color = COLORS.green }
        })
    else
        music_play:set({
            icon = { string = "􀊄", color = COLORS.red }
        })
    end

    if is_shuffle then
        music_shuffle:set({ icon = { highlight = true } })
    else
        music_shuffle:set({ icon = { highlight = false } })
    end

    if is_repeat then
        music_repeat:set({ icon = { highlight = true } })
    else
        music_repeat:set({ icon = { highlight = false } })
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

music_play:subscribe("mouse.clicked", function()
    client.toggle_play()
    SBAR.delay(0.1, function()
        client.stats(icon_updater)
    end)
end)


music_shuffle:subscribe("mouse.clicked", function()
    client.toggle_shuffle()
    SBAR.delay(0.1, function()
        client.stats(icon_updater)
    end)
end)

music_repeat:subscribe("mouse.clicked", function()
    client.toggle_repeat()
    SBAR.delay(0.1, function()
        client.stats(icon_updater)
    end)
end)

music_prev:subscribe("mouse.clicked", function()
    client.prev_track()
    SBAR.delay(0.1, function()
        client.update_album_art(albumart_updater)
        client.update_current_track(track_info_updater)
        client.stats(icon_updater)
    end)
end)

music_next:subscribe("mouse.clicked", function()
    client.next_track()
    SBAR.delay(0.1, function()
        client.update_album_art(albumart_updater)
        client.update_current_track(track_info_updater)
        client.stats(icon_updater)
    end)
end)
-- #endregion Event


client.update_album_art(albumart_updater)
