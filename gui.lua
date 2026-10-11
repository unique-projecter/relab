--// Relab | gui

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")

local Config = _G.Relab.Config

local C = Config.UI
local ACCENT, ACCENT_DARK = C.Accent, C.AccentDark
local BG, BG_ALT, LINE    = C.BG, C.BGAlt, C.Line
local TEXT, TEXT_DIM      = C.Text, C.TextDim

local function make(inst, props)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local parentGui = (gethui and gethui()) or CoreGui

local ScreenGui = make(Instance.new("ScreenGui"), {
    Name = "RelabScript",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parentGui,
})

--// ── main window ──
local Main = make(Instance.new("Frame"), {
    Name = "Main", Parent = ScreenGui,
    BackgroundColor3 = BG,
    Size = UDim2.fromOffset(520, 380),
    Position = UDim2.new(0.5, -260, 0.5, -190),
    BorderSizePixel = 0, ClipsDescendants = true,
})
make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 10), Parent = Main})
make(Instance.new("UIStroke"), {Color = ACCENT, Thickness = 1, Transparency = 0.4, Parent = Main})
make(Instance.new("UIGradient"), {
    Rotation = 45,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 38)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 22)),
    },
    Parent = Main,
})

--// title bar
local TitleBar = make(Instance.new("Frame"), {
    Parent = Main, BackgroundColor3 = BG_ALT,
    Size = UDim2.new(1, 0, 0, 40), BorderSizePixel = 0,
})
make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 10), Parent = TitleBar})
make(Instance.new("Frame"), {
    Parent = TitleBar, BackgroundColor3 = BG_ALT,
    Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
    BorderSizePixel = 0,
})
make(Instance.new("Frame"), {
    Parent = Main, BackgroundColor3 = LINE,
    Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 40),
    BorderSizePixel = 0,
})

local AccentBar = make(Instance.new("Frame"), {
    Parent = TitleBar, BackgroundColor3 = ACCENT,
    Size = UDim2.new(0, 3, 0, 22),
    Position = UDim2.new(0, 14, 0.5, -11), BorderSizePixel = 0,
})
make(Instance.new("UICorner"), {CornerRadius = UDim.new(1, 0), Parent = AccentBar})
make(Instance.new("UIGradient"), {
    Rotation = 90, Color = ColorSequence.new(ACCENT, ACCENT_DARK),
    Parent = AccentBar,
})

make(Instance.new("TextLabel"), {
    Parent = TitleBar, BackgroundTransparency = 1,
    Size = UDim2.new(0, 260, 1, 0), Position = UDim2.new(0, 28, 0, 0),
    Font = Enum.Font.GothamBold, Text = "RELAB",
    TextColor3 = TEXT, TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})
make(Instance.new("TextLabel"), {
    Parent = TitleBar, BackgroundTransparency = 1,
    Size = UDim2.new(0, 260, 1, 0), Position = UDim2.new(0, 76, 0, 0),
    Font = Enum.Font.Gotham, Text = "SCRIPT",
    TextColor3 = ACCENT, TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})
make(Instance.new("TextLabel"), {
    Parent = TitleBar, BackgroundTransparency = 1,
    Size = UDim2.new(0, 160, 1, 0), Position = UDim2.new(1, -180, 0, 0),
    Font = Enum.Font.Gotham, Text = "toggle · " .. tostring(C.ToggleKey.Name),
    TextColor3 = TEXT_DIM, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Right,
})

local CloseBtn = make(Instance.new("TextButton"), {
    Parent = TitleBar, BackgroundColor3 = Color3.fromRGB(40, 30, 40),
    Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -34, 0.5, -12),
    Text = "×", Font = Enum.Font.GothamBold,
    TextColor3 = TEXT, TextSize = 16,
    AutoButtonColor = false, BorderSizePixel = 0,
})
make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 6), Parent = CloseBtn})
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15),
        {BackgroundColor3 = Color3.fromRGB(180, 60, 60)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15),
        {BackgroundColor3 = Color3.fromRGB(40, 30, 40)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

--// sidebar
local Sidebar = make(Instance.new("Frame"), {
    Parent = Main, BackgroundColor3 = BG_ALT,
    Size = UDim2.new(0, 130, 1, -40),
    Position = UDim2.new(0, 0, 0, 40), BorderSizePixel = 0,
})
make(Instance.new("Frame"), {
    Parent = Sidebar, BackgroundColor3 = LINE,
    Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
    BorderSizePixel = 0,
})

local Pages, TabButtons = {}, {}
local function makeTab(name, order)
    local btn = make(Instance.new("TextButton"), {
        Parent = Sidebar, BackgroundTransparency = 1,
        Size = UDim2.new(1, -16, 0, 34),
        Position = UDim2.new(0, 8, 0, 10 + (order - 1) * 38),
        Text = "", AutoButtonColor = false,
    })
    local accent = make(Instance.new("Frame"), {
        Parent = btn, BackgroundColor3 = ACCENT,
        Size = UDim2.new(0, 3, 0, 18),
        Position = UDim2.new(0, 0, 0.5, -9),
        BorderSizePixel = 0, Visible = false,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(1, 0), Parent = accent})
    local lbl = make(Instance.new("TextLabel"), {
        Parent = btn, BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 16, 0, 0),
        Font = Enum.Font.GothamMedium, Text = name,
        TextColor3 = TEXT_DIM, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local page = make(Instance.new("ScrollingFrame"), {
        Parent = Main, BackgroundTransparency = 1,
        Size = UDim2.new(1, -146, 1, -56),
        Position = UDim2.new(0, 140, 0, 48),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2, ScrollBarImageColor3 = ACCENT,
        BorderSizePixel = 0, Visible = false,
    })
    make(Instance.new("UIListLayout"), {
        Parent = page, Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    make(Instance.new("UIPadding"), {Parent = page, PaddingRight = UDim.new(0, 8)})
    Pages[name] = page
    TabButtons[name] = { btn = btn, accent = accent, lbl = lbl }

    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = (n == name) end
        for n, t in pairs(TabButtons) do
            t.accent.Visible = (n == name)
            t.lbl.TextColor3 = (n == name) and TEXT or TEXT_DIM
        end
    end)
    return page
end

local EspPage  = makeTab("ESP", 1)
local AimPage  = makeTab("Aimbot", 2)
local SetPage  = makeTab("Settings", 3)

TabButtons["ESP"].accent.Visible = true
TabButtons["ESP"].lbl.TextColor3 = TEXT
EspPage.Visible = true

--// components
local function makeSection(page, text, order)
    make(Instance.new("TextLabel"), {
        Parent = page, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        Font = Enum.Font.GothamBold, Text = text,
        TextColor3 = ACCENT, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = order,
    })
end

local function makeToggle(page, text, state, callback, order)
    local row = make(Instance.new("Frame"), {
        Parent = page, BackgroundColor3 = BG_ALT,
        Size = UDim2.new(1, 0, 0, 38),
        BorderSizePixel = 0, LayoutOrder = order,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 8), Parent = row})
    make(Instance.new("UIStroke"), {Color = LINE, Thickness = 1, Parent = row})
    make(Instance.new("TextLabel"), {
        Parent = row, BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 14, 0, 0),
        Font = Enum.Font.GothamMedium, Text = text,
        TextColor3 = TEXT, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local sw = make(Instance.new("TextButton"), {
        Parent = row,
        BackgroundColor3 = state and ACCENT or Color3.fromRGB(40,40,52),
        Size = UDim2.fromOffset(42, 20),
        Position = UDim2.new(1, -56, 0.5, -10),
        Text = "", AutoButtonColor = false, BorderSizePixel = 0,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(1, 0), Parent = sw})
    local knob = make(Instance.new("Frame"), {
        Parent = sw, BackgroundColor3 = Color3.fromRGB(245,245,255),
        Size = UDim2.fromOffset(16, 16),
        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BorderSizePixel = 0,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(1, 0), Parent = knob})

    sw.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(sw, TweenInfo.new(0.15),
            {BackgroundColor3 = state and ACCENT or Color3.fromRGB(40,40,52)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15),
            {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        callback(state)
    end)
end

local function makeSlider(page, text, min, max, default, callback, order)
    local row = make(Instance.new("Frame"), {
        Parent = page, BackgroundColor3 = BG_ALT,
        Size = UDim2.new(1, 0, 0, 56),
        BorderSizePixel = 0, LayoutOrder = order,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 8), Parent = row})
    make(Instance.new("UIStroke"), {Color = LINE, Thickness = 1, Parent = row})

    make(Instance.new("TextLabel"), {
        Parent = row, BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 0, 22), Position = UDim2.new(0, 14, 0, 6),
        Font = Enum.Font.GothamMedium, Text = text,
        TextColor3 = TEXT, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local valLbl = make(Instance.new("TextLabel"), {
        Parent = row, BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 0, 22), Position = UDim2.new(1, -74, 0, 6),
        Font = Enum.Font.GothamBold, Text = tostring(default),
        TextColor3 = ACCENT, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local track = make(Instance.new("Frame"), {
        Parent = row, BackgroundColor3 = Color3.fromRGB(36,36,48),
        Size = UDim2.new(1, -28, 0, 6),
        Position = UDim2.new(0, 14, 0, 36), BorderSizePixel = 0,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(1, 0), Parent = track})
    local fill = make(Instance.new("Frame"), {
        Parent = track, BackgroundColor3 = ACCENT,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BorderSizePixel = 0,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(1, 0), Parent = fill})
    local knob = make(Instance.new("Frame"), {
        Parent = track, BackgroundColor3 = Color3.fromRGB(245,245,255),
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7),
        BorderSizePixel = 0, ZIndex = 2,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(1, 0), Parent = knob})

    local dragging = false
    local function set(input)
        local pos = math.clamp(
            (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pos
        if max <= 2 then val = math.floor(val * 100) / 100
        else val = math.floor(val) end
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -7, 0.5, -7)
        valLbl.Text = tostring(val)
        callback(val)
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; set(i) end
    end)
    track.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then set(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local function makeDropdown(page, text, options, default, callback, order)
    local open = false
    local row = make(Instance.new("Frame"), {
        Parent = page, BackgroundColor3 = BG_ALT,
        Size = UDim2.new(1, 0, 0, 38),
        BorderSizePixel = 0, LayoutOrder = order,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 8), Parent = row})
    make(Instance.new("UIStroke"), {Color = LINE, Thickness = 1, Parent = row})

    make(Instance.new("TextLabel"), {
        Parent = row, BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 14, 0, 0),
        Font = Enum.Font.GothamMedium, Text = text,
        TextColor3 = TEXT, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local btn = make(Instance.new("TextButton"), {
        Parent = row, BackgroundColor3 = Color3.fromRGB(36,36,48),
        Size = UDim2.fromOffset(90, 26),
        Position = UDim2.new(1, -100, 0.5, -13),
        Text = default, Font = Enum.Font.GothamMedium,
        TextColor3 = ACCENT, TextSize = 12,
        AutoButtonColor = false, BorderSizePixel = 0,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 6), Parent = btn})

    local list = make(Instance.new("Frame"), {
        Parent = row, BackgroundColor3 = BG,
        Size = UDim2.new(0, 90, 0, #options * 24),
        Position = UDim2.new(1, -100, 1, 4),
        Visible = false, ZIndex = 5, BorderSizePixel = 0,
    })
    make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 6), Parent = list})
    make(Instance.new("UIStroke"), {Color = ACCENT, Thickness = 1, Transparency = 0.4, Parent = list})
    make(Instance.new("UIListLayout"), {Parent = list, SortOrder = Enum.SortOrder.LayoutOrder})

    for i, opt in ipairs(options) do
        local o = make(Instance.new("TextButton"), {
            Parent = list, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24),
            Text = opt, Font = Enum.Font.Gotham, TextColor3 = TEXT,
            TextSize = 12, AutoButtonColor = false, LayoutOrder = i,
        })
        o.MouseEnter:Connect(function() o.TextColor3 = ACCENT end)
        o.MouseLeave:Connect(function() o.TextColor3 = TEXT end)
        o.MouseButton1Click:Connect(function()
            btn.Text = opt
            list.Visible = false
            open = false
            callback(opt)
        end)
    end

    btn.MouseButton1Click:Connect(function()
        open = not open
        list.Visible = open
    end)
end

--// build: ESP
makeSection(EspPage, "MASTER", 1)
makeToggle(EspPage, "Enable ESP", Config.ESP.Enabled,
    function(v) Config.ESP.Enabled = v end, 2)
makeSection(EspPage, "ELEMENTS", 3)
makeToggle(EspPage, "Box", Config.ESP.Box,
    function(v) Config.ESP.Box = v end, 4)
makeToggle(EspPage, "Name", Config.ESP.Name,
    function(v) Config.ESP.Name = v end, 5)
makeToggle(EspPage, "Health Bar", Config.ESP.Health,
    function(v) Config.ESP.Health = v end, 6)
makeToggle(EspPage, "Distance", Config.ESP.Distance,
    function(v) Config.ESP.Distance = v end, 7)
makeToggle(EspPage, "Tracer", Config.ESP.Tracer,
    function(v) Config.ESP.Tracer = v end, 8)
makeSection(EspPage, "FILTERS", 9)
makeToggle(EspPage, "Team Check", Config.ESP.TeamCheck,
    function(v) Config.ESP.TeamCheck = v end, 10)
makeSlider(EspPage, "Max Distance", 100, 5000, Config.ESP.MaxDistance,
    function(v) Config.ESP.MaxDistance = v end, 11)

--// build: Aimbot
makeSection(AimPage, "MASTER", 1)
makeToggle(AimPage, "Enable Aimbot", Config.Aimbot.Enabled,
    function(v) Config.Aimbot.Enabled = v end, 2)
makeSection(AimPage, "TUNING", 3)
makeSlider(AimPage, "FOV Radius", 10, 500, Config.Aimbot.FOV,
    function(v) Config.Aimbot.FOV = v end, 4)
makeSlider(AimPage, "Smoothness", 0.01, 1, Config.Aimbot.Smoothness,
    function(v) Config.Aimbot.Smoothness = v end, 5)
makeSection(AimPage, "FILTERS", 6)
makeToggle(AimPage, "Team Check", Config.Aimbot.TeamCheck,
    function(v) Config.Aimbot.TeamCheck = v end, 7)
makeToggle(AimPage, "Wall Check", Config.Aimbot.WallCheck,
    function(v) Config.Aimbot.WallCheck = v end, 8)
makeToggle(AimPage, "Show FOV Circle", Config.Aimbot.ShowFOV,
    function(v) Config.Aimbot.ShowFOV = v end, 9)
makeSection(AimPage, "TARGET", 10)
makeDropdown(AimPage, "Hitbox", {"Head", "HumanoidRootPart", "Torso"},
    Config.Aimbot.TargetPart,
    function(v) Config.Aimbot.TargetPart = v end, 11)

--// build: Settings
makeSection(SetPage, "INFO", 1)
local info = make(Instance.new("TextLabel"), {
    Parent = SetPage, BackgroundColor3 = BG_ALT,
    Size = UDim2.new(1, 0, 0, 90),
    Font = Enum.Font.Gotham, TextColor3 = TEXT_DIM,
    TextSize = 12, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    LayoutOrder = 2, BorderSizePixel = 0,
    Text = "  Relab Script — Rivals\n  toggle: " .. tostring(C.ToggleKey.Name)
        .. "\n  aim hold: RMB\n  drag: title bar",
})
make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 8), Parent = info})
make(Instance.new("UIPadding"), {
    Parent = info, PaddingLeft = UDim.new(0, 12),
    PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 12),
})

makeSection(SetPage, "ACTIONS", 3)
local unload = make(Instance.new("TextButton"), {
    Parent = SetPage, BackgroundColor3 = Color3.fromRGB(60, 34, 44),
    Size = UDim2.new(1, 0, 0, 40),
    Font = Enum.Font.GothamBold, Text = "Unload Relab",
    TextColor3 = TEXT, TextSize = 13,
    AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = 4,
})
make(Instance.new("UICorner"), {CornerRadius = UDim.new(0, 8), Parent = unload})
unload.MouseButton1Click:Connect(function()
    if _G.Relab.RemoveESP    then _G.Relab.RemoveESP() end
    if _G.Relab.RemoveAimbot then _G.Relab.RemoveAimbot() end
    ScreenGui:Destroy()
end)

--// window drag
do
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, i.Position, Main.Position
        end
    end)
    TitleBar.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

--// toggle bind
UserInputService.InputBegan:Cot(function(input, gpe)
    if gpe then return end
    if input.KeyCode == C.ToggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
        if ScreenGui.Enabled then
            Main.Size = UDim2.fromOffset(520, 340)
            TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Back),
                {Size = UDim2.fromOffset(520, 380)}):Play()
        end
    end
end)

--// opening animation
Main.Size = UDim2.fromOffset(520, 340)
TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back),
    {Size = UDim2.fromOffset(520, 380)}):Play()

print("[Relab] gui загружен")
