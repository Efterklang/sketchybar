-- 🪫 text version: show percentage only
local battery = SBAR.add("item", "battery", {
    position = "right",
    update_freq = 180,
    icon = { drawing = false },
    label = {
        font = { style = FONT.style_map["Regular"], size = 14.0 },
        color = COLORS.text,
    },
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
    SBAR.exec("pmset -g batt", function(batt_info)
        local _, _, charge = batt_info:find("(%d+)%%")
        local charging = batt_info:find("AC Power")
        if charge then
            charge = tonumber(charge)
            local color = COLORS.green
            if charge <= 20 then
                color = COLORS.red
            elseif charge <= 40 then
                color = COLORS.peach
            end
            local symbol = charging and "󱐋" or "%"
            battery:set({ label = { string = charge .. symbol, color = color } })
        else
            battery:set({ label = { string = "N/A", color = COLORS.red } })
        end
    end)
end)
