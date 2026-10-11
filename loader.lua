--// Relab | loader
local BASE = "https://raw.githubusercontent.com/unique-projecter/relab/main/"

_G.Relab = _G.Relab or {}

local function fetch(name)
    local src = game:HttpGet(BASE .. name)
    local fn, err = loadstring(src, "@" .. name)
    if not fn then
        error("[Relab] ошибка в " .. name .. " → " .. tostring(err))
    end
    return fn()
end

_G.Relab.Config = fetch("config.lua")
_G.Relab.Utils  = fetch("utils.lua")
               fetch("esp.lua")
               fetch("aimbot.lua")
               fetch("gui.lua")

print("[Relab] всё загружено")
