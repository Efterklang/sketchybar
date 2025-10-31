#!/usr/bin/env osascript -l JavaScript

// Get menu structure as JSON for a given application
ObjC.import('stdlib');

function run(argv) {
    const app = argv[0] || getCurrentApp();
    const menuData = getMenuStructure(app);
    return JSON.stringify(menuData, null, 2);
}

function getCurrentApp() {
    const sysEvents = Application('System Events');
    const frontProc = sysEvents.applicationProcesses.whose({frontmost: true})[0];
    return frontProc.name();
}

function getMenuStructure(appName) {
    const sysEvents = Application('System Events');
    const app = sysEvents.processes.byName(appName);
    const menuBar = app.menuBars[0];
    const menuBarItems = menuBar.menuBarItems;
    
    const result = [];
    
    for (let i = 0; i < menuBarItems.length; i++) {
        try {
            const item = menuBarItems[i];
            const name = item.name();
            
            // Skip Apple menu
            if (name === 'Apple') continue;
            
            const menuData = {
                name: name,
                index: i,
                path: String(i),
                type: 'menu_bar_item',
                items: []
            };
            
            // Get menu items if menu exists
            try {
                const menu = item.menus[0];
                menuData.items = getMenuItems(menu.menuItems, String(i));
            } catch (e) {
                // No submenu
            }
            
            result.push(menuData);
        } catch (e) {
            // Skip problematic items
        }
    }
    
    return result;
}

function getMenuItems(items, parentPath) {
    const result = [];
    
    for (let i = 0; i < items.length; i++) {
        try {
            const item = items[i];
            let name;
            let enabled = true;
            let isSeparator = false;
            
            try {
                name = item.name();
                if (!name) {
                    name = '---';
                    isSeparator = true;
                }
            } catch (e) {
                name = '---';
                isSeparator = true;
            }
            
            try {
                enabled = item.enabled();
            } catch (e) {
                // Default to true if can't determine
            }
            
            const fullPath = parentPath + '/' + i;
            
            const menuItem = {
                name: name,
                index: i,
                path: fullPath,
                enabled: enabled,
                separator: isSeparator,
                type: 'menu_item',
                items: []
            };
            
            // Check for keyboard shortcut
            try {
                const keyModifiers = item.properties()['AXMenuItemCmdModifiers'];
                const keyChar = item.properties()['AXMenuItemCmdChar'];
                if (keyChar) {
                    menuItem.shortcut = {
                        modifiers: keyModifiers || 0,
                        key: keyChar
                    };
                }
            } catch (e) {
                // No shortcut
            }
            
            // Check for checkmark
            try {
                const mark = item.properties()['AXMenuItemMarkChar'];
                if (mark) {
                    menuItem.checked = true;
                }
            } catch (e) {
                // Not checked
            }
            
            // Check for submenu
            if (!isSeparator) {
                try {
                    const subMenu = item.menus[0];
                    menuItem.items = getMenuItems(subMenu.menuItems, fullPath);
                    menuItem.hasSubmenu = true;
                } catch (e) {
                    menuItem.hasSubmenu = false;
                }
            }
            
            result.push(menuItem);
        } catch (e) {
            // Skip items that cause errors
        }
    }
    
    return result;
}