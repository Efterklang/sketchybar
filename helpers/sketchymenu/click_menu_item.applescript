#!/usr/bin/env osascript

-- Click a menu item by its path (e.g., "1/3/2" for File -> 4th item -> 3rd subitem)
on run argv
    if (count of argv) < 2 then
        return "Usage: click_menu_item.applescript <app_name> <path>"
    end if
    
    set appName to item 1 of argv
    set pathString to item 2 of argv
    
    return clickMenuPath(appName, pathString)
end run

on clickMenuPath(appName, pathString)
    set AppleScript's text item delimiters to "/"
    set pathParts to text items of pathString
    
    if (count of pathParts) < 1 then
        return "Error: Invalid path"
    end if
    
    tell application "System Events"
        tell process appName
            -- First, get the menu bar item
            set menuBarIndex to (item 1 of pathParts as integer) + 1
            set currentMenuItem to menu bar item menuBarIndex of menu bar 1
            
            -- Click to open the menu
            click currentMenuItem
            delay 0.1
            
            -- Navigate through the path
            if (count of pathParts) > 1 then
                set currentMenu to menu 1 of currentMenuItem
                
                repeat with i from 2 to (count of pathParts)
                    set itemIndex to (item i of pathParts as integer) + 1
                    set currentMenuItem to menu item itemIndex of currentMenu
                    
                    -- If this is not the last item and it has a submenu, open it
                    if i < (count of pathParts) then
                        try
                            -- Hover to open submenu
                            set position of currentMenuItem to position of currentMenuItem
                            delay 0.1
                            set currentMenu to menu 1 of currentMenuItem
                        on error
                            -- This item doesn't have a submenu
                            click currentMenuItem
                            return "Clicked: " & (name of currentMenuItem)
                        end try
                    else
                        -- This is the final item, click it
                        click currentMenuItem
                        try
                            return "Clicked: " & (name of currentMenuItem)
                        on error
                            return "Clicked item at path: " & pathString
                        end try
                    end if
                end repeat
            end if
            
            return "Success"
        end tell
    end tell
end clickMenuPath