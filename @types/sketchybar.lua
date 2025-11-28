---@meta sketchybar

-- #region SketchybarItem API

-- An item in Sketchybar, see https://felixkratz.github.io/SketchyBar/config/items for details
---@class SketchybarItem
---@field name string
local SketchybarItem = {}

---@param properties table
---@return SketchybarItem
function SketchybarItem:set(properties) end

---@param key? string
---@return table
function SketchybarItem:query(key) end

---where all regular sketchybar events are supported. Events can be supplied as a single string or alternatively as a table of events. The <lua_function> is called when the event occurs and receives one argument, which contains the typical sketchybar environment variables, e.g.
---@param event string|string[]
---@param callback fun(env: table)
function SketchybarItem:subscribe(event, callback) end

---@param values number[]
function SketchybarItem:push(values) end
-- #endregion SketchybarItem

-- #region Sketchybar API

-- This class provides the main interface to interact with Sketchybar
---@class Sketchybar
local Sketchybar = {}

--- Bundle the entire initial configuration into a single message to sketchybar. This improves startup times drastically.
function Sketchybar.begin_config() end

--- Bundle the entire initial configuration into a single message to sketchybar. This improves startup times drastically.
function Sketchybar.end_config() end

--- Run the event loop of the sketchybar module (without this there will be no callback functions executed in the lua module)
function Sketchybar.event_loop() end

--- Query information about the bar or items
---@overload fun(): table Query bar properties
---@overload fun(name: "bar"): table Query bar properties
---@overload fun(name: "defaults"): table Query default properties
---@overload fun(name: "events"): table Query all events
---@overload fun(name: "default_menu_items"): table Query names of available items for aliases
---@overload fun(name: string): table Query specific item properties by name
---@return table
function Sketchybar.query(name) end

--- Sets properties for the bar itself.
---@param properties table
function Sketchybar.bar(properties) end

--- Set global bar properties, see https://felixkratz.github.io/SketchyBar/config/bar
--- Example: Sketchybar.set("color=0xffff0000", "height=40")
---@param ... string Bar settings in format <setting>=<value>
function Sketchybar.set(...) end

--- Sets default properties for all subsequently created items.
---@param properties table
function Sketchybar.default(properties) end

--- Creates a new Sketchybar item.
--- The `name` is the identifier of the item, if no identifier is specified, it is generated automatically
---@overload fun(type: "item"|"space"|"alias", name?: string, properties: table): SketchybarItem
---@overload fun(type: "bracket", name?: string, members: table, properties: table): SketchybarItem
---@overload fun(type: "slider"|"graph", name?: string, width: number, properties: table): SketchybarItem
---@overload fun(type: "event", name: string, notification?: string): SketchybarItem
---@return SketchybarItem
function Sketchybar.add(type, ...) end

--- This function is truly async, which means that the command is executed without blocking the event thread
---@param command string The shell command to execute
---@param callback? fun(result: string|table, exit_code: number) Optional callback function that will receive the result of the command as the first argument. Additionally, should the result have a JSON structure, it will be parsed into a LUA table.
function Sketchybar.exec(command, callback) end

---@param event string
---@param env? table
function Sketchybar.trigger(event, env) end

---@param curve string
---@param duration number
---@param callback fun()
function Sketchybar.animate(curve, duration, callback) end

---@param bar_name string
function Sketchybar.set_bar_name(bar_name) end

return Sketchybar
-- #endregion SketchybarItem
