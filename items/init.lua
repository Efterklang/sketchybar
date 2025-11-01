require("items.logo.apple")
require("items.menus.menus")
require("items.spaces.spaces")
require("items.front_app.front_app")

-- right
require("items.calendar.calendar")
require("items.battery.battery")
require("items.monitor.wifi")
require("items.volume.volume")
require("items.chat.qq_wechat")
require("items.brew.brew")

require("items.toggle_stats.toggle_stats")

require("items.monitor.netspeed")
require("items.monitor.cpu")
require("items.monitor.mem")
require("items.music.music")

SBAR.add("bracket", "stats_bracket", {
    "battery",
    "brew"
}, {
    background = {
        color = COLORS.base,
        border_color = COLORS.surface0,
        border_width = 2
    }
})
