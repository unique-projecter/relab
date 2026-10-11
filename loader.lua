--// Relab Script | loader
local BASE = "https://raw.githubusercontent.com/ТВОЙНИК/relab/main/"

local function fetch(name)
    local url = BASE .. name
    local src = game:HttpGet(url)
    local fn, err = loadstring(src, "@" .. name)
    if not fn then
        error("[Relab] ошибка в " .. name .. ": " .. tostring(err))
    end
    return fn()
end

-- порядок важен: config первый, gui последний
local Config = fetch("config.lua")
fetch("utils.lua")
fetch("esp.lua")
fetch("aimbot.lua")
fetch("gui.lua")

print("[Relab] всё загружено")
