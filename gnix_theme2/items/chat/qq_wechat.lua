local function get_app_status(app_name)
    SBAR.exec(
        "lsappinfo -all list | rg " .. app_name .. " | rg -o '\"StatusLabel\"=\\{ \"label\"=\"?([^\"]*)\"? \\}' -r '$1'",
        function(result)
            if result == "\n" then
                result = "0"
            end

            SBAR.set(app_name, { label = result })
        end)
end

local qq = SBAR.add("item", "qq", {
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
    get_app_status("qq")
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
