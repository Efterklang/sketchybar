-- 将日志写入到~/.cache/sbar.log

local logger = {}

local log_path = (os.getenv("HOME") or "~") .. "/.cache/sketchybar/sbar.log"

function logger.log(message)
  local file, err = io.open(log_path, "a")
  if not file then
    return nil, err
  end
  file:write(string.format("%s %s\n", os.date("%Y-%m-%d %H:%M:%S"), tostring(message)))
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

function logger.print_table(tbl)
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
