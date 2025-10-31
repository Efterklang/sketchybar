#!/usr/bin/env bash

# Example: Working with Menu JSON
# This shows how to get menu structure as JSON and click on items

echo "Menu JSON Tools - Examples"
echo "=========================="
echo ""

# 1. Get menu structure for current app as JSON
echo "1. Getting menu structure for Finder as JSON:"
echo "   ./get_menu_json.js Finder"
echo ""

# 2. Example JSON output structure
cat << 'EOF'
Example JSON structure:
[
  {
    "name": "File",
    "index": 1,
    "path": "1",
    "items": [
      {
        "name": "New Finder Window",
        "index": 0,
        "path": "1/0",
        "enabled": true,
        "separator": false,
        "hasSubmenu": false,
        "items": []
      },
      {
        "name": "New Folder",
        "index": 1,
        "path": "1/1",
        "enabled": true,
        "separator": false,
        "hasSubmenu": false,
        "items": []
      },
      {
        "name": "Open With",
        "index": 9,
        "path": "1/9",
        "enabled": false,
        "separator": false,
        "hasSubmenu": true,
        "items": [
          {
            "name": "Other...",
            "index": 0,
            "path": "1/9/0",
            "enabled": false,
            "separator": false,
            "hasSubmenu": false,
            "items": []
          }
        ]
      }
    ]
  }
]
EOF

echo ""
echo "3. Using the path to click menu items:"
echo "   ./click_menu_item.applescript Finder \"1/0\"  # Clicks File -> New Finder Window"
echo "   ./click_menu_item.applescript Finder \"1/9/0\" # Clicks File -> Open With -> Other..."
echo ""

echo "4. Integration with SketchyBar:"
echo "   The path field in JSON is what you pass to click_menu_item.applescript"
echo "   This preserves the full hierarchy for navigation and clicking"
echo ""

echo "Key benefits of JSON approach:"
echo "- Clean, parseable structure"
echo "- Preserves full menu hierarchy"
echo "- Each item has a unique path for clicking"
echo "- Includes metadata (enabled, separator, hasSubmenu)"
echo "- Can be cached for performance"
echo ""

echo "Testing the scripts:"
echo "-------------------"

# Test getting JSON for current app
CURRENT_APP=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true')
echo "Current app: $CURRENT_APP"
echo ""

echo "Getting menu structure (first 50 lines)..."
./get_menu_json.js "$CURRENT_APP" | head -50

echo ""
echo "To see full output: ./get_menu_json.js \"$CURRENT_APP\" | jq ."
echo ""
echo "To click a specific menu item:"
echo "1. Find its path in the JSON (e.g., \"1/3\" for File menu, 4th item)"
echo "2. Run: ./click_menu_item.applescript \"$CURRENT_APP\" \"1/3\""