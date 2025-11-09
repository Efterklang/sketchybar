-- 将日志写入到~/.cache/sbar.log

local logger = {}

local log_path = (os.getenv("HOME") or "~") .. "/.cache/sketchybar/sbar.log"

function logger:log(message, level)
  local file, err = io.open(log_path, "a")
  if not file then
    return nil, err
  end
  file:write(string.format("%s [%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), level or "INFO", tostring(message)))
  file:close()
  return true
end

function logger:info(message)
  self:log(message, "INFO")
end

function logger:warn(message)
  self:log(message, "WARN")
end

function logger:error(message)
  self:log(message, "ERROR")
end

--- Prints a variable's name, type, and value to the log file.
function logger:print_var(var_name, var_value)
  local file, err = io.open(log_path, "a")
  if not file then
    return nil, err
  end
  file:write(string.format("%s (%s): %s\n", var_name, type(var_value), tostring(var_value)))
  file:close()
  return true
end

local function collect_table_lines(tbl, indent, lines)
  indent = indent or 0
  lines = lines or {}
  local prefix = string.rep("  ", indent)

  if type(tbl) ~= "table" then
    table.insert(lines, prefix .. tostring(tbl))
    return lines
  end

  for k, v in pairs(tbl) do
    if type(v) == "table" then
      table.insert(lines, string.format("%s%s:", prefix, tostring(k)))
      collect_table_lines(v, indent + 1, lines)
    else
      table.insert(lines, string.format("%s%s: %s", prefix, tostring(k), tostring(v)))
    end
  end

  return lines
end

function logger:print_table(tbl)
  local lines = collect_table_lines(tbl)
  local content = table.concat(lines, "\n")

  local file, err = io.open(log_path, "a")
  if not file then
    return nil, err
  end
  file:write(string.format("%s\n%s\n", os.date("%Y-%m-%d %H:%M:%S"), content))
  file:close()
  return true
end

return logger
