--// Relab | aimbot

local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera           = workspace.CurrentCamera

local Config = _G.Relab.Config
local U      = _G.Relab.Utils
local Players= U.Players

local Aiming = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.NumSides = 1, 80
FOVCircle.Filled, FOVCircle.Transparency = false, 0.5
FOVCircle.Color = Config.UI.Accent

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function isVisible(target)
    if not Config.Aimbot.WallCheck then return true end
    local part = U.getPart(target, Config.Aimbot.TargetPart)
    if not part then return false end
    rayParams.FilterDescendantsInstances = { U.LocalPlayer.Character, Camera }
    local result = workspace:Raycast(Camera.CFrame.Position,
                                     part.Position - Camera.CFrame.Position, rayParams)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(target.Character)
    end
    return true
end

local function getClosestTarget()
    local best, bestDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if U.isEnemy(plr) and U.isAlive(plr) and isVisible(plr) then
            local part = U.getPart(plr, Config.Aimbot.TargetPart)
            if part then
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                    if d <= Config.Aimbot.FOV and d < bestDist then
                        best, bestDist = plr, d
                    end
                end
            end
        end
    end
    return best
end

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.UserInputType == Config.Aimbot.HoldKey then Aiming = true end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Config.Aimbot.HoldKey then Aiming = false end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius   = Config.Aimbot.FOV
    FOVCircle.Color    = Config.UI.Accent
    FOVCircle.Visible  = Config.Aimbot.ShowFOV and Config.Aimbot.Enabled

    if Aiming and Config.Aimbot.Enabled then
        local t = getClosestTarget()
        if t then
            local part = U.getPart(t, Config.Aimbot.TargetPart)
            if part then
                Camera.CFrame = Camera.CFrame:Lerp(
                    CFrame.new(Camera.CFrame.Position, part.Position),
                    Config.Aimbot.Smoothness)
            end
        end
    end
end)

_G.Relab.RemoveAimbot = function()
    pcall(function() FOVCircle:Remove() end)
end
