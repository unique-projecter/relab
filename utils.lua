--// Relab | utils

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local U = {}

U.Players     = Players
U.LocalPlayer = LocalPlayer

function U.isAlive(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

function U.isEnemy(plr)
    if plr == LocalPlayer then return false end
    local Config = _G.Relab.Config
    if Config.ESP.TeamCheck and plr.Team and plr.Team == LocalPlayer.Team then
        return false
    end
    return true
end

function U.getPart(plr, name)
    local char = plr.Character
    if not char then return nil end
    return char:FindFirstChild(name) or char:FindFirstChild("HumanoidRootPart")
end

return U
