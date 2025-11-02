local utils = {}

--- Get the status label of an application and update the sketchybar item
--- @param CFBundleIdentifier string The bundle identifier of the application, this could be found in `XXX.app/Contents/Info.plist`
--- @param item table The sketchybar item object to update with the status label
utils.get_app_status = function(CFBundleIdentifier, item)
  SBAR.exec("lsappinfo info -only StatusLabel " .. CFBundleIdentifier, function(result)
    local label_match = result:match('"label"="([^"]*)"')
    local label_prev = item:query().label.value

    if label_match and label_match ~= "" then
      if label_match ~= label_prev then -- only animate on change
        SBAR.animate("tanh", 15, function()
          item:set({ label = { drawing = true, string = label_match, y_offset = 5 } })
          item:set({ label = { drawing = true, string = label_match, y_offset = 0 } })
        end)
      else
        item:set({ label = { drawing = true, string = label_match } })
      end
    else
      item:set({ label = { drawing = false } })
    end
  end)
end

return utils
