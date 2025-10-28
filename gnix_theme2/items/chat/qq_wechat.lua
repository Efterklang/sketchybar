local function get_app_status(app_name)
    SBAR.exec(
        "lsappinfo info -only StatusLabel " .. app_name,
        function(result)
            local label_match = result:match('"label"="([^"]*)"')

            if label_match and label_match ~= "" then
                SBAR.animate("tanh", 15, function()
                    SBAR.set(app_name, { label = { string = label_match, y_offset = 5 } })
                    SBAR.set(app_name, { label = { string = label_match, y_offset = 0 } })
                end)
            else
                SBAR.set(app_name, { label = { drawing = false } })
            end
        end)
end

local qq = SBAR.add("item", "QQ", {
    position = "right",
    icon = {
        string = ICONS.qq,
        font = {
            style = FONT.style_map["Regular"],
            size = 16.0,
        },
        color = COLORS.blue,
    },
    update_freq = 10,
    click_script = 'open -a QQ',
})

qq:subscribe("routine", function()
    get_app_status("QQ")
end)

local wechat = SBAR.add("item", "wechat", {
    position = "right",
    icon = {
        string = ICONS.wechat,
        font = {
            style = FONT.style_map["Regular"],
            size = 20.0,
        },
        color = COLORS.green,
    },
    update_freq = 10,
    click_script = 'open -a WeChat',
})

wechat:subscribe("routine", function()
    get_app_status("wechat")
end)

-- Init status on sketchybar launch
get_app_status("QQ")
get_app_status("wechat")
