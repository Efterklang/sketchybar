#!/usr/bin/env bash

# Fast SketchyBar App Menu with Submenu Support
# Loads submenus on-demand for speed

# Handle different commands
CMD="${1:-toggle}"
MENU_PATH="${2:-}"

HOST_ITEM="front_app"
MENU_PREFIX="$HOST_ITEM.menu"
SUB_PREFIX="$HOST_ITEM.sub"

echo "SketchyMenu - App Menu Helper" >> ~/.sketchymenu.log
echo "CMD is '$CMD', MENU_PATH is '$MENU_PATH'" >> ~/.sketchymenu.log

# Get plugin directory
PLUGIN_DIR="$HOME/.config/sketchybar/helpers"

clear_menu() {
    local popup_items
    popup_items=$(sketchybar --query "$HOST_ITEM" 2>/dev/null | jq -r '.popup.items[]?' 2>/dev/null || true)

    if [ -n "$popup_items" ]; then
        while read -r item; do
            [ -n "$item" ] && sketchybar --remove "$item" 2>/dev/null || true
        done <<< "$popup_items"
    fi
}

case "$CMD" in
    toggle)
        # Check state FIRST
        STATE=$(sketchybar --query "$HOST_ITEM" 2>/dev/null | jq -r '.popup.drawing // "off"')

        if [ "$STATE" = "on" ]; then
            # Close menu
            sketchybar --set "$HOST_ITEM" popup.drawing=off
            # Cleanup
            clear_menu
        else
            # Open menu and show top level
            sketchybar --set "$HOST_ITEM" popup.drawing=on
            "$0" load_top
        fi
        ;;

    load_top)
        # Clear existing items
    clear_menu

        # Get current app
        APP=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true')
        # APP=$(sketchybar --query "app" | jq '.label.value')

        # Get menu bar items fastest way I've found
        MENUS=$(osascript << EOF
tell application "System Events"
    tell process "$APP"
        set menuList to {}
        set idx to 0
        repeat with mb in menu bar items of menu bar 1
            try
                set menuName to name of mb
                set hasSubmenu to false
                try
                    set m to menu 1 of mb
                    set hasSubmenu to true
                end try
                if hasSubmenu then
                    set end of menuList to menuName & "|" & idx & "|Y"
                else
                    set end of menuList to menuName & "|" & idx & "|N"
                end if
            end try
            set idx to idx + 1
        end repeat
        return menuList
    end tell
end tell
EOF
)

        # Parse and add menu items
        i=0
        echo "$MENUS" | tr ',' '\n' | while read -r line; do
            # Parse: name|index|hasSubmenu
            IFS='|' read -r name idx has_sub <<< "$(echo "$line" | tr -d ' "')"

            if [ -n "$name" ] && [ "$name" != "missing" ]; then
                if [ "$has_sub" = "Y" ]; then
                    # Has submenu - add arrow
                    sketchybar --add item "$MENU_PREFIX.$i" popup.$HOST_ITEM \
                        --set "$MENU_PREFIX.$i" \
                            label="$name ▸" \
                            icon.drawing=off \
                            click_script="$PLUGIN_DIR/sketchymenu/app_menu.sh load_sub '$idx'"
                else
                    # No submenu
                    sketchybar --add item "$MENU_PREFIX.$i" popup.$HOST_ITEM \
                        --set "$MENU_PREFIX.$i" \
                            label="$name" \
                            icon.drawing=off \
                            click_script="echo 'Execute: $name'"
                fi
                i=$((i + 1))
            fi
        done
        ;;

    load_sub)
        # Load submenu items
        if [ -z "$MENU_PATH" ]; then exit 0; fi

        # Clear existing items
        clear_menu

        # Add back button
        sketchybar --add item "$MENU_PREFIX.back" popup.$HOST_ITEM \
            --set "$MENU_PREFIX.back" \
                label="‹ Back" \
                icon.drawing=off \
                click_script="$PLUGIN_DIR/sketchymenu/app_menu.sh load_top"

        # Add separator
        sketchybar --add item "$MENU_PREFIX.sep" popup.$HOST_ITEM \
            --set "$MENU_PREFIX.sep" \
                label="────────" \
                icon.drawing=off

        # Get submenu items for the selected menu
        APP=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true')
        MENU_INDEX=$((MENU_PATH + 1))

        ITEMS=$(osascript << EOF
tell application "System Events"
    tell process "$APP"
        try
            set menuBarItem to menu bar item $MENU_INDEX of menu bar 1
            set menuItems to menu items of menu 1 of menuBarItem
            set itemList to {}
            repeat with mi in menuItems
                try
                    set itemName to name of mi
                    set itemEnabled to enabled of mi
                    if itemName is missing value then
                        set end of itemList to "---"
                    else if itemEnabled then
                        set end of itemList to itemName
                    else
                        set end of itemList to "[" & itemName & "]"
                    end if
                end try
            end repeat
            return itemList
        on error
            return {}
        end try
    end tell
end tell
EOF
)

        # Add submenu items
        i=2
        echo "$ITEMS" | tr ',' '\n' | while read -r item; do
            item=$(echo "$item" | tr -d '"' | xargs)

            if [ "$item" = "---" ]; then
                # Separator
                sketchybar --add item "$SUB_PREFIX.$i" popup.$HOST_ITEM \
                    --set "$SUB_PREFIX.$i" \
                        label="────────" \
                        icon.drawing=off
            elif [ -n "$item" ]; then
                # Check if disabled (wrapped in brackets)
                if [[ "$item" == \[*\] ]]; then
                    # Disabled item
                    item=${item:1:-1}
                    sketchybar --add item "$SUB_PREFIX.$i" popup.$HOST_ITEM \
                        --set "$SUB_PREFIX.$i" \
                            label="$item" \
                            label.color=0xff888888 \
                            icon.drawing=off
                else
                    # Enabled item
                    sketchybar --add item "$SUB_PREFIX.$i" popup.$HOST_ITEM \
                        --set "$SUB_PREFIX.$i" \
                            label="$item" \
                            icon.drawing=off \
                            click_script="$PLUGIN_DIR/sketchymenu/click_menu_item.applescript '$APP' '$MENU_PATH/$((i-2))' && sketchybar --set $HOST_ITEM popup.drawing=off"
                fi
            fi
            i=$((i + 1))
            if [ $i -gt 30 ]; then break; fi
        done
        ;;
esac