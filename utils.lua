local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local U = {}

function U.isAlive(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

function U.getPart(plr, name)
    local char = plr.Character
    if not char then return nil end
    return char:FindFirstChild(name) or char:FindFirstChild("HumanoidRootPart")
end

return U
