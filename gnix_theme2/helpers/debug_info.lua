-- 将日志写入到~/.cache/sbar.log

LOG = {}

local log_path = (os.getenv("HOME") or "~") .. "/.cache/sbar.log"

function LOG.log(message)
    local file, err = io.open(log_path, "a")
    if not file then return nil, err end
    file:write(string.format("%s %s\n", os.date("%Y-%m-%d %H:%M:%S"), tostring(message)))
    file:close()
    return true
end
