--// Relab | esp

local RunService = game:GetService("RunService")
local Camera     = workspace.CurrentCamera

local Config = _G.Relab.Config
local U      = _G.Relab.Utils
local Players= U.Players

local ESP = {}

local function create(plr)
    local d = {}
    d.Box = Drawing.new("Square")
    d.Box.Thickness, d.Box.Filled, d.Box.Transparency = 1, false, 1
    d.Box.Color = Config.UI.Accent

    d.Name = Drawing.new("Text")
    d.Name.Size, d.Name.Center, d.Name.Outline = 14, true, true
    d.Name.Color = Color3.fromRGB(255, 255, 255)

    d.HealthBG = Drawing.new("Square")
    d.HealthBG.Filled, d.HealthBG.Transparency = true, 0.6
    d.HealthBG.Color = Color3.new(0, 0, 0)

    d.Health = Drawing.new("Square")
    d.Health.Filled = true

    d.Distance = Drawing.new("Text")
    d.Distance.Size, d.Distance.Center, d.Distance.Outline = 13, true, true
    d.Distance.Color = Color3.fromRGB(210, 210, 210)

    d.Tracer = Drawing.new("Line")
    d.Tracer.Thickness = 1
    d.Tracer.Color = Config.UI.Accent

    ESP[plr] = d
end

local function remove(plr)
    local d = ESP[plr]
    if not d then return end
    for _, o in pairs(d) do pcall(function() o:Remove() end) end
    ESP[plr] = nil
end

for _, p in ipairs(Players:GetPlayers()) do create(p) end
Players.PlayerAdded:Connect(create)
Players.PlayerRemoving:Connect(remove)

RunService.RenderStepped:Connect(function()
    for plr, d in pairs(ESP) do
        local char = plr.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        local valid = Config.ESP.Enabled and U.isEnemy(plr) and U.isAlive(plr)
                      and hrp and head and hum

        if not valid then
            for _, o in pairs(d) do if o.Visible ~= nil then o.Visible = false end end
        else
            local sp1, on1 = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.7, 0))
            local sp2, on2 = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.0, 0))
            local dist     = (hrp.Position - Camera.CFrame.Position).Magnitude
            local visible  = on1 and on2 and dist <= Config.ESP.MaxDistance

            local h = math.abs(sp2.Y - sp1.Y)
            local w = h * 0.55
            local x = sp1.X - w / 2
            local y = sp1.Y

            d.Box.Visible  = visible and Config.ESP.Box
            d.Box.Size     = Vector2.new(w, h)
            d.Box.Position = Vector2.new(x, y)

            local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            d.HealthBG.Visible  = visible and Config.ESP.Health
            d.HealthBG.Size     = Vector2.new(3, h)
            d.HealthBG.Position = Vector2.new(x - 6, y)

            d.Health.Visible  = visible and Config.ESP.Health
            d.Health.Size     = Vector2.new(3, h * ratio)
            d.Health.Position = Vector2.new(x - 6, y + h * (1 - ratio))
            d.Health.Color    = Color3.fromRGB(
                math.floor(255 * (1 - ratio)),
                math.floor(255 * ratio), 0)

            d.Name.Visible  = visible and Config.ESP.Name
            d.Name.Text     = plr.Name
            d.Name.Position = Vector2.new(x + w / 2, y - 16)

            d.Distance.Visible  = visible and Config.ESP.Distance
            d.Distance.Text     = string.format("[%d]", math.floor(dist))
            d.Distance.Position = Vector2.new(x + w / 2, y + h + 2)

            d.Tracer.Visible = visible and Config.ESP.Tracer
            d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            d.Tracer.To   = Vector2.new(x + w / 2, y + h)
        end
    end
end)

_G.Relab.ESP = ESP
_G.Relab.RemoveESP = function()
    for plr in pairs(ESP) do remove(plr) end
end
