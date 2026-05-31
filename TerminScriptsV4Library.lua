-- Decompiled from MoonSec V3 disassembly
-- (best-effort; control flow may need minor manual cleanup)
-- By ZeroVector101
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local localPlayer = Players.LocalPlayer
local config = {}
config.Primary = Color3.fromRGB(0, 191, 255)
config.PrimaryHover = Color3.fromRGB(10, 201, 255)
config.PrimaryGlow = Color3.fromRGB(30, 220, 255)
config.Secondary = Color3.fromRGB(138, 43, 226)
config.SecondaryHover = Color3.fromRGB(148, 53, 236)
config.SecondaryGlow = Color3.fromRGB(158, 63, 246)
config.Accent = Color3.fromRGB(255, 20, 147)
config.AccentHover = Color3.fromRGB(255, 40, 167)
config.AccentGlow = Color3.fromRGB(255, 60, 187)
config.Success = Color3.fromRGB(0, 255, 127)
config.Warning = Color3.fromRGB(255, 215, 0)
config.Error = Color3.fromRGB(255, 69, 0)
config.Info = Color3.fromRGB(0, 206, 255)
config.Background = Color3.fromRGB(8, 8, 15)
config.BackgroundBlur = Color3.fromRGB(12, 12, 25)
config.Surface = Color3.fromRGB(18, 18, 35)
config.SurfaceElevated = Color3.fromRGB(25, 25, 45)
config.SurfaceHover = Color3.fromRGB(35, 35, 65)
config.Card = Color3.fromRGB(30, 30, 55)
config.CardElevated = Color3.fromRGB(40, 40, 75)
config.CardHover = Color3.fromRGB(50, 50, 95)
config.TextPrimary = Color3.fromRGB(255, 255, 255)
config.TextSecondary = Color3.fromRGB(200, 200, 230)
config.TextMuted = Color3.fromRGB(150, 150, 200)
config.TextDisabled = Color3.fromRGB(100, 100, 150)
config.Border = Color3.fromRGB(60, 60, 120)
config.BorderLight = Color3.fromRGB(80, 80, 150)
config.BorderGlow = Color3.fromRGB(0, 191, 255)   -- Changed to light blue
config.BorderHover = Color3.fromRGB(138, 43, 226)  -- Changed to purple
config.KeybindGrey = Color3.fromRGB(128, 128, 128)
config.GlassMain = 0.1
config.GlassSecondary = 0.2
config.GlassLight = 0.3
config.GlowStrength = 0.2
config.Shadow = Color3.fromRGB(0, 0, 0)
config.ShadowStrong = Color3.fromRGB(5, 5, 15)
config.Glow = Color3.fromRGB(0, 191, 255)         -- Changed to light blue
local config2 = {}
Color3.fromRGB(255, 0, 127)
Color3.fromRGB(255, 127, 0)
Color3.fromRGB(255, 255, 0)
Color3.fromRGB(127, 255, 0)
Color3.fromRGB(0, 255, 127)
Color3.fromRGB(0, 127, 255)
config.Rainbow = config2
local config3 = {}
config3.Lightning = TweenInfo.new(0.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
config3.UltraFast = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
config3.Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
config3.Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
config3.Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
config3.Bounce = TweenInfo.new(0.6, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
config3.Elastic = TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
config3.Back = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
config3.FadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
config3.FadeOut = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
config3.Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
config3.Sharp = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
config3.Breathe = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local config4 = {}
config4.BaseResolution = Vector2.new(1920, 1080)
config4.CurrentScale = 1
config4.MinScale = 0.4
config4.MaxScale = 2.5
config4.AdaptiveMode = true
config4.CalculateScale = function(p0)
    local v = workspace.CurrentCamera

    if not (v) then

        return 1

    end

    local v2 = v.ViewportSize

    if v2.X < 768 then
    else
        if v2.X < 1366 then
        end
    end

    local v3 = math.clamp(math.sqrt(v2.X / p0.BaseResolution.X * v2.Y / p0.BaseResolution.Y) * 1.2 * 1.1, p0.MinScale, p0.MaxScale)
    p0.CurrentScale = v3

    return v3
end
config4.GetScaledValue = function(p0, p1)
    return p1 * p0.CurrentScale
end
config4.GetScaledUDim2 = function(p0, p1)
    -- [14] TailCall: return R2(R3, R4, R5, R6)

    return UDim2.new
end
local config5 = {}
config5.isTouchDevice = UserInputService.TouchEnabled
config5.isDragging = false
config5.dragObject = nil
config5.dragStart = nil
config5.startPos = nil
config5.EnableDrag = function(p0, p1, p2)
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_3 (Fix manually)
    local v = p1

    if v.Name ~= "TitleContainer" and v.Parent then

        if v.Parent.Name ~= "TitleContainer" then

            return

        end

        local v2 = false
        local v3 = nil
        local v4 = nil
        v.InputBegan:Connect(function(p0)
            if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

                if p0.UserInputType == Enum.UserInputType.Touch then
                    func_f0a28b99(p0)
                end

                return

            end
        end)
        v.InputChanged:Connect(function(p0)
            if p0.UserInputType ~= Enum.UserInputType.MouseMovement then

                if p0.UserInputType == Enum.UserInputType.Touch then
                    func_dc4a0688(p0)
                end

                return

            end
        end)
        v.InputEnded:Connect(function(p0)
            if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

                if p0.UserInputType == Enum.UserInputType.Touch then
                    func_7364c343()
                end

                return

            end
        end)
        UserInputService.InputChanged:Connect(function(p0)
            if p0.UserInputType ~= Enum.UserInputType.MouseMovement then

                if p0.UserInputType == Enum.UserInputType.Touch then
                    func_dc4a0688(p0)
                end

                return

            end
        end)
        UserInputService.InputEnded:Connect(function(p0)
            if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

                if p0.UserInputType == Enum.UserInputType.Touch then
                    func_7364c343()
                end

                return

            end
        end)

        return

    end
end
local config6 = {}
local config7 = {}
config6.bindings = config7
local config8 = {}
config6.toggleBindings = config8
local config9 = {}
config6.toggleStates = config9
config6.listening = false
config6.currentCallback = nil
config6.listeningFrame = nil
local config10 = {}
config6.listeningConnections = config10
local config11 = {}
config6.activeListeners = config11
local config12 = {}
config6.touchTools = config12
config6.bind = function(p0, p1, p2)
    if p0.bindings[p1] then
        p0.bindings[p1]:Disconnect()
    end

    p0.bindings[p1] = UserInputService.InputBegan:Connect(function(p0, p1)
        if not (p1) and p0.KeyCode == p1 then
            local v, v2 = pcall(p2)

            if not (v) then
                warn("Keybind callback error:", v2)
            end
        end
    end)
end
config6.BindToggle = function(p0, p1, p2, p3)
    if p0.toggleBindings[p1] then
        p0.toggleBindings[p1]:Disconnect()
    end

    if p0.toggleStates[p1] == nil then
        p0.toggleStates[p1] = false
    end

    p0.toggleBindings[p1] = UserInputService.InputBegan:Connect(function(p0, p1)
        if not (p1) and p0.KeyCode == p1 then
            p0.toggleStates[p1] = not p0.toggleStates[p1]

            if p2 and typeof(p2.SetValue) == "function" then
                local v, v2 = pcall(p2.SetValue, p2, p0.toggleStates[p1])

                if not (v) then
                    warn("Toggle keybind setValue error:", v2)
                end
            end

            if p3 then
                local v3, v4 = pcall(p3, p0.toggleStates[p1])

                if not (v3) then
                    warn("Toggle keybind callback error:", v4)
                end
            end
        end
    end)
end
config6.StartListening = function(p0, p1, p2)
    if p0.listening then
        p0:StopListening()
    end

    p0.listening = true
    p0.currentCallback = p1
    p0.listeningFrame = p2

    if p2 then
        p2.Text = "Press any key..."
        p2.TextColor3 = config.Primary
    end

    p0:ClearConnections()
    table.insert(p0.listeningConnections, UserInputService.InputBegan:Connect(function(p0, p1)
        if not (p1) and p0.UserInputType == Enum.UserInputType.Keyboard then
            p0:FinishListening(p0.KeyCode)
        end
    end))
    table.insert(p0.listeningConnections, UserInputService.InputBegan:Connect(function(p0, p1)
        if not (p1) then
            local v = p0.UserInputType

            if v ~= Enum.UserInputType.MouseButton1 and v ~= Enum.UserInputType.MouseButton2 then

                if v == Enum.UserInputType.MouseButton3 then
                    p0:FinishListening(v)
                end

                return

            end
        end
    end))
end
config6.FinishListening = function(p0, p1)
    p0.listening = false
    p0:ClearConnections()

    if p0.listeningFrame then

        if p1 then
            p0.listeningFrame.Text = tostring(p1):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
        else
            p0.listeningFrame.Text = "None"
        end

        p0.listeningFrame.TextColor3 = config.TextPrimary
    end

    if p0.currentCallback and p1 then
        local v, v2 = pcall(p0.currentCallback, p1)

        if not (v) then
            warn("Keybind listener callback error:", v2)
        end
    end

    p0:cleanup()
end
config6.StopListening = function(p0)
    p0.listening = false
    p0:ClearConnections()

    if p0.listeningFrame then
        p0.listeningFrame.Text = "None"
        p0.listeningFrame.TextColor3 = config.TextMuted
    end

    p0:cleanup()
end
config6.ClearConnections = function(p0)
    for v, v2 in pairs(p0.listeningConnections) do

        if v2 and v2.Connected then
            v2:Disconnect()
        end
    end

    local config = {}
    p0.listeningConnections = config
end
config6.cleanup = function(p0)
    p0.currentCallback = nil
    p0.listeningFrame = nil
end
config6.unbind = function(p0, p1)
    if p0.bindings[p1] then
        p0.bindings[p1]:Disconnect()
        p0.bindings[p1] = nil
    end

    if p0.toggleBindings[p1] then
        p0.toggleBindings[p1]:Disconnect()
        p0.toggleBindings[p1] = nil
    end

    if p0.toggleStates[p1] then
        p0.toggleStates[p1] = nil
    end
end
config6.unbindAll = function(p0)
    for v, v2 in pairs(p0.bindings) do
        v2:Disconnect()
    end

    for v3, v4 in pairs(p0.toggleBindings) do
        v4:Disconnect()
    end

    local config = {}
    p0.bindings = config
    local config2 = {}
    p0.toggleBindings = config2
    local config3 = {}
    p0.toggleStates = config3
    p0:StopListening()
end
local config13 = {}
config13.OpenDropdown = nil
local config14 = {}
config13.allDropdowns = config14
config13.register = function(p0, p1)
    table.insert(p0.allDropdowns, p1)
end
config13.CloseAll = function(p0)
    for v, v2 in pairs(p0.allDropdowns) do

        if v2 and v2.close then
            v2.close()
        end
    end

    p0.OpenDropdown = nil
end
config13.SetOpen = function(p0, p1)
    p0:CloseAll()
    p0.OpenDropdown = p1
end
local config15 = {}
config15.__index = config15
config15.new = function(p0, p1)
    local config = {}
    local v = setmetatable(config, config15)

    if not (p1) then
        local config2 = {}
        local v2 = config2
    end

    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_11 (Fix manually)
    v.title = "Termin Scripts"

    v.VersionText = "v3.0.0 - (Game Name) - discord.gg/KkzMrTzSF4"

    v.Theme = "default"

    v.GlowEffects = true

    v.Animations = true

    v.KeybindToggle = Enum.KeyCode.RightControl
    config4:CalculateScale()
    local config3 = {}
    v.tabs = config3
    v.currentTab = nil
    v.isVisible = true
    v.isMinimized = false
    v.isMaximized = false
    v.originalSize = nil
    v.originalPosition = nil
    v.isDragging = false
    v:CreateMainGui()
    v:SetupControls()
    v:SetupDragging()
    v:SetupKeybinds()
    v:SetupScaling()

    return v
end
local _upv1 = localPlayer:WaitForChild("PlayerGui")
config15.CreateMainGui = function(p0)
    local v = config4.CurrentScale
    local screenGui = Instance.new("ScreenGui")
    p0.ScreenGui = screenGui
    p0.ScreenGui.Name = "TerminScriptsV3"
    p0.ScreenGui.Parent = _upv1
    p0.ScreenGui.ResetOnSpawn = false
    p0.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    p0.ScreenGui.IgnoreGuiInset = true
    local v2 = 950 * v
    local v3 = 750 * v
    local frame = Instance.new("Frame")
    p0.MainFrame = frame
    p0.MainFrame.Name = "MainContainer"
    p0.MainFrame.Size = UDim2.new(0, v2, 0, v3)
    p0.MainFrame.Position = UDim2.new(0.5, -v2 / 2, 0.5, -v3 / 2)
    p0.MainFrame.BackgroundColor3 = config.Background
    p0.MainFrame.BackgroundTransparency = config.GlassMain
    p0.MainFrame.BorderSizePixel = 0
    p0.MainFrame.ClipsDescendants = true
    p0.MainFrame.Parent = p0.ScreenGui
    p0.originalSize = p0.MainFrame.Size
    p0.originalPosition = p0.MainFrame.Position
    func_b40028aa(p0.MainFrame, 30 * v)
    func_022841c4(p0.MainFrame, 2 * v, config.BorderGlow, 0.2)
    p0:CreateHeader()
    p0:CreateContentArea()
end
config15.CreateHeader = function(p0)
    local v = config4.CurrentScale
    local frame = Instance.new("Frame")
    p0.Header = frame
    p0.Header.Name = "Header"
    p0.Header.Size = UDim2.new(1, 0, 0, 90 * v)
    p0.Header.BackgroundColor3 = config.Surface
    p0.Header.BackgroundTransparency = config.GlassSecondary
    p0.Header.BorderSizePixel = 0
    p0.Header.Parent = p0.MainFrame
    func_b40028aa(p0.Header, 30 * v)
    func_022841c4(p0.Header, 1 * v, config.BorderLight, 0.4)
    local config = {}
    ColorSequenceKeypoint.new(0, config.Primary)
    ColorSequenceKeypoint.new(0.25, config.Secondary)
    ColorSequenceKeypoint.new(0.5, config.Accent)
    ColorSequenceKeypoint.new(0.75, config.Secondary)
    local config2 = {}
    NumberSequenceKeypoint.new(0, 0.1)
    NumberSequenceKeypoint.new(0.5, 0.3)

    if p0.Animations then
        func_3e08ce32(func_96d4a870(p0.Header, ColorSequence.new(config), 45, NumberSequence.new(config2)), TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 405,
        }):Play()
    end

    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(0, 70 * v, 0, 70 * v)
    frame2.Position = UDim2.new(0, 25 * v, 0, 10 * v)
    frame2.BackgroundColor3 = config.Card
    frame2.BackgroundTransparency = 0.1
    frame2.BorderSizePixel = 0
    frame2.Parent = p0.Header
    func_b40028aa(frame2, 20 * v)
    func_022841c4(frame2, 2 * v, config.Primary, 0.3)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, -8 * v, 1, -8 * v)
    imageLabel.Position = UDim2.new(0, 4 * v, 0, 4 * v)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. localPlayer.UserId .. "&width=420&height=420&format=png"
    imageLabel.Parent = frame2
    func_b40028aa(imageLabel, 18 * v)
    local frame3 = Instance.new("Frame")
    frame3.Name = "TitleContainer"
    frame3.Size = UDim2.new(1, -320 * v, 1, 0)
    frame3.Position = UDim2.new(0, 110 * v, 0, 0)
    frame3.BackgroundTransparency = 1
    frame3.Parent = p0.Header
    config5:EnableDrag(p0.MainFrame, frame3)
    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Padding = UDim.new(0, 5 * v)
    uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uIListLayout.Parent = frame3
    local textLabel = Instance.new("TextLabel")
    p0.TitleLabel = textLabel
    p0.TitleLabel.Size = UDim2.new(1, 0, 0, 35 * v)
    p0.TitleLabel.BackgroundTransparency = 1
    p0.TitleLabel.Text = p0.title
    p0.TitleLabel.TextColor3 = config.TextPrimary
    p0.TitleLabel.TextSize = 28 * v
    p0.TitleLabel.Font = Enum.Font.GothamBold
    p0.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    p0.TitleLabel.LayoutOrder = 1
    p0.TitleLabel.Parent = frame3
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(1, 0, 0, 20 * v)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = p0.VersionText
    textLabel2.TextColor3 = config.TextSecondary
    textLabel2.TextSize = 14 * v
    textLabel2.Font = Enum.Font.Gotham
    textLabel2.TextXAlignment = Enum.TextXAlignment.Left
    textLabel2.LayoutOrder = 2
    textLabel2.Parent = frame3
    local textLabel3 = Instance.new("TextLabel")
    textLabel3.Size = UDim2.new(1, 0, 0, 16 * v)
    textLabel3.BackgroundTransparency = 1
    textLabel3.Text = "Online - " .. localPlayer.Name
    textLabel3.TextColor3 = config.Success
    textLabel3.TextSize = 12 * v
    textLabel3.Font = Enum.Font.GothamMedium
    textLabel3.TextXAlignment = Enum.TextXAlignment.Left
    textLabel3.LayoutOrder = 3
    textLabel3.Parent = frame3
    p0:CreateControlButtons()
end
config15.CreateControlButtons = function(p0)
    local v = config4.CurrentScale
    local v2 = 35 * v
    local v3 = 10 * v
    p0.MinimizeBtn = p0:CreateControlButton("��", config.Warning, UDim2.new(1, -v2 * 3 + v3 * 2 + 25 * v, 0.5, -v2 / 2), v2)
    p0.MaximizeBtn = p0:CreateControlButton("��", config.Info, UDim2.new(1, -v2 * 2 + v3 + 25 * v, 0.5, -v2 / 2), v2)
    p0.CloseBtn = p0:CreateControlButton("�", config.Error, UDim2.new(1, -v2 + 25 * v, 0.5, -v2 / 2), v2)
end
config15.CreateControlButton = function(p0, p1, p2, p3, p4)
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, p4, 0, p4)
    textButton.Position = p3
    textButton.BackgroundColor3 = p2
    textButton.BackgroundTransparency = 0.2
    textButton.BorderSizePixel = 0
    textButton.Text = p1
    textButton.TextColor3 = config.TextPrimary
    textButton.Font = Enum.Font.GothamBold
    textButton.TextSize = p4 * 0.5
    textButton.ZIndex = 10
    textButton.Parent = p0.Header
    func_b40028aa(textButton, p4 * 0.3)
    func_022841c4(textButton, 1, p2:lerp(config.TextPrimary, 0.3), 0.3)
    textButton.MouseEnter:Connect(function()
        func_3e08ce32(textButton, config3.Fast, {
            BackgroundColor3 = p2:lerp(config.TextPrimary, 0.15),
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, p4 * 1.05, 0, p4 * 1.05),
        }):Play()
    end)
    textButton.MouseLeave:Connect(function()
        func_3e08ce32(textButton, config3.Fast, {
            BackgroundColor3 = p2,
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, p4, 0, p4),
        }):Play()
    end)
    textButton.MouseButton1Down:Connect(function()
        func_c29bd3e3(textButton)
    end)

    return textButton
end
config15.CreateContentArea = function(p0)
    local v = config4.CurrentScale
    local frame = Instance.new("Frame")
    p0.ContentArea = frame
    p0.ContentArea.Size = UDim2.new(1, -50 * v, 1, -140 * v)
    p0.ContentArea.Position = UDim2.new(0, 25 * v, 0, 115 * v)
    p0.ContentArea.BackgroundTransparency = 1
    p0.ContentArea.Parent = p0.MainFrame
    p0:CreateTabNavigation()
    local frame2 = Instance.new("Frame")
    p0.PageContainer = frame2
    p0.PageContainer.Size = UDim2.new(1, 0, 1, -80 * v)
    p0.PageContainer.Position = UDim2.new(0, 0, 0, 75 * v)
    p0.PageContainer.BackgroundTransparency = 1
    p0.PageContainer.Parent = p0.ContentArea
end
config15.CreateTabNavigation = function(p0)
    local v = config4.CurrentScale
    local frame = Instance.new("Frame")
    p0.TabNav = frame
    p0.TabNav.Size = UDim2.new(1, 0, 0, 70 * v)
    p0.TabNav.BackgroundColor3 = config.Card
    p0.TabNav.BackgroundTransparency = config.GlassSecondary
    p0.TabNav.BorderSizePixel = 0
    p0.TabNav.Parent = p0.ContentArea
    func_b40028aa(p0.TabNav, 20 * v)
    func_022841c4(p0.TabNav, 1 * v, config.BorderLight, 0.4)
    local scrollingFrame = Instance.new("ScrollingFrame")
    p0.TabContainer = scrollingFrame
    p0.TabContainer.Size = UDim2.new(1, -20 * v, 1, -10 * v)
    p0.TabContainer.Position = UDim2.new(0, 10 * v, 0, 5 * v)
    p0.TabContainer.BackgroundTransparency = 1
    p0.TabContainer.BorderSizePixel = 0
    p0.TabContainer.ScrollBarThickness = 0
    p0.TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    p0.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    p0.TabContainer.Parent = p0.TabNav
    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.FillDirection = Enum.FillDirection.Horizontal
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Padding = UDim.new(0, 15 * v)
    uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uIListLayout.Parent = p0.TabContainer
    uIListLayout.Changed:Connect(function()
        p0.TabContainer.CanvasSize = UDim2.new(0, uIListLayout.AbsoluteContentSize.X + 30 * v, 0, 0)
    end)
end
config15.CreateTab = function(p0, p1, p2, p3)
    if not (p3) then
        local config = {}
    end

    local v = config4.CurrentScale
    local config2 = {}
    config2.name = p1
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_11 (Fix manually)
    config2.icon = "�����"
    config2.config = config
    config2.button = nil
    config2.page = nil
    local config3 = {}
    config2.sections = config3
    config2.active = false
    config2.layoutOrder = #p0.tabs + 1
    config2.gui = p0
    local v2 = TextService:GetTextSize(p1, 16 * v, Enum.Font.GothamSemibold, Vector2.new(1000, 1000))

    if p2 then

        local textButton = Instance.new("TextButton")
        config2.button = textButton
        config2.button.Name = p1 .. "Tab"
        config2.button.Size = UDim2.new(0, v2.X + 40 * v, 0, 60 * v)
        config2.button.BackgroundColor3 = config.Surface
        config2.button.BackgroundTransparency = 0.3
        config2.button.BorderSizePixel = 0
        config2.button.Text = ""
        config2.button.LayoutOrder = config2.layoutOrder
        config2.button.Parent = p0.TabContainer
        func_b40028aa(config2.button, 15 * v)
        func_022841c4(config2.button, 1 * v, config.Border, 0.5)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20 * v, 1, -10 * v)
        frame.Position = UDim2.new(0, 10 * v, 0, 5 * v)
        frame.BackgroundTransparency = 1
        frame.Parent = config2.button
        local uIListLayout = Instance.new("UIListLayout")
        uIListLayout.FillDirection = Enum.FillDirection.Horizontal
        uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uIListLayout.Padding = UDim.new(0, 8 * v)
        uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uIListLayout.Parent = frame

        if p2 then
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(0, 24 * v, 0, 24 * v)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = p2
            textLabel.TextColor3 = config.TextSecondary
            textLabel.TextSize = 18 * v
            textLabel.Font = Enum.Font.GothamBold
            textLabel.LayoutOrder = 1
            textLabel.Parent = frame
        end

        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(0, v2.X, 0, 24 * v)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = p1
        textLabel2.TextColor3 = config.TextSecondary
        textLabel2.TextSize = 16 * v
        textLabel2.Font = Enum.Font.GothamSemibold
        textLabel2.LayoutOrder = 2
        textLabel2.Parent = frame
        local scrollingFrame = Instance.new("ScrollingFrame")
        config2.page = scrollingFrame
        config2.page.Name = p1 .. "Page"
        config2.page.Size = UDim2.new(1, 0, 1, 0)
        config2.page.BackgroundTransparency = 1
        config2.page.BorderSizePixel = 0
        config2.page.ScrollBarThickness = 8 * v
        config2.page.ScrollBarImageColor3 = config.Primary
        config2.page.ScrollBarImageTransparency = 0.3
        config2.page.CanvasSize = UDim2.new(0, 0, 0, 0)
        config2.page.Visible = false
        config2.page.Parent = p0.PageContainer
        local uIListLayout2 = Instance.new("UIListLayout")
        uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        uIListLayout2.Padding = UDim.new(0, 20 * v)
        uIListLayout2.Parent = config2.page
        uIListLayout2.Changed:Connect(function()
            config2.page.CanvasSize = UDim2.new(0, 0, 0, uIListLayout2.AbsoluteContentSize.Y + 40 * v)
        end)
        config2.button.MouseEnter:Connect(function()
            if not (config2.active) then
                func_3e08ce32(config2.button, config3.Fast, {
                    BackgroundColor3 = config.CardHover,
                    BackgroundTransparency = 0.1,
                }):Play()
                func_3e08ce32(textLabel2, config3.Fast, {
                    TextColor3 = config.TextPrimary,
                }):Play()

                if p2 then
                    local config3 = {}
                    config3.TextColor3 = config.Primary
                    func_3e08ce32(frame:FindFirstChild("TextLabel"), config3.Fast, config3):Play()
                end
            end
        end)
        config2.button.MouseLeave:Connect(function()
            if not (config2.active) then
                func_3e08ce32(config2.button, config3.Fast, {
                    BackgroundColor3 = config.Surface,
                    BackgroundTransparency = 0.3,
                }):Play()
                func_3e08ce32(textLabel2, config3.Fast, {
                    TextColor3 = config.TextSecondary,
                }):Play()

                if p2 then
                    local config3 = {}
                    config3.TextColor3 = config.TextSecondary
                    func_3e08ce32(frame:FindFirstChild("TextLabel"), config3.Fast, config3):Play()
                end
            end
        end)
        config2.button.MouseButton1Click:Connect(function()
            func_c29bd3e3(config2.button)
            p0:SwitchTab(config2)
        end)
        config2.CreateSection = function(p0, p1, p2, p3)
            -- [6] TailCall: return R4(R5, R6, R7, R8, R9)

            return p0.gui:CreateSection
        end
        config2.TSButton = function(p0, p1)
            -- [14] TailCall: return R3(R4, R5, R6)

            return p0.gui:TSButton
        end
        config2.TSToggle = function(p0, p1)
            -- [14] TailCall: return R3(R4, R5, R6)

            return p0.gui:TSToggle
        end
        config2.TSKeyBind = function(p0, p1)
            -- [14] TailCall: return R3(R4, R5, R6)

            return p0.gui:TSKeyBind
        end
        config2.TSDropdown = function(p0, p1)
            -- [14] TailCall: return R3(R4, R5, R6)

            return p0.gui:TSDropdown
        end
        config2.TSColorPicker = function(p0, p1)
            -- [14] TailCall: return R3(R4, R5, R6)

            return p0.gui:TSColorPicker
        end
        config2.TSSlider = function(p0, p1)
            -- [14] TailCall: return R3(R4, R5, R6)

            return p0.gui:TSSlider
        end
        config2.TSTextBox = function(p0, p1)
            -- [14] TailCall: return R3(R4, R5, R6)

            return p0.gui:TSTextBox
        end
        table.insert(p0.tabs, config2)

        if #p0.tabs == 1 then
            p0:SwitchTab(config2)
        end

        return config2

    end
end
config15.SwitchTab = function(p0, p1)
    for v, v2 in pairs(p0.tabs) do

        if v2 == p1 then
            v2.active = true
            v2.page.Visible = true
            func_3e08ce32(v2.button, config3.Fast, {
                BackgroundColor3 = config.Primary,
                BackgroundTransparency = 0.1,
            }):Play()
            local v3 = v2.button:FindFirstChild("UIStroke")

            if v3 then
            end
        end

        v2.active = false
        v2.page.Visible = false
        local config3 = {}
        config3.BackgroundColor3 = config.Surface
        config3.BackgroundTransparency = 0.3
        func_3e08ce32(v2.button, config3.Fast, config3):Play()
        local v4 = v2.button:FindFirstChild("UIStroke")

        if v4 then
            func_3e08ce32(v4, config3.Fast, {
                Color = config.Border,
                Transparency = 0.5,
            }):Play()
        end
    end

    p0.currentTab = p1
end
config15.CreateSection = function(p0, p1, p2, p3, p4)
    if not (p4) then
        local config = {}
    end

    local v = config4.CurrentScale
    local {
        Color = config.PrimaryGlow,
        Transparency = 0.2,
    } = {}
    config2.name = p2
    config2.description = p3
    config2.config = config
    config2.frame = nil
    local config3 = {}
    config2.elements = config3
    config2.expanded = true
    config2.layoutOrder = #p1.sections + 1
    config2.tab = p1
    local frame = Instance.new("Frame")
    config2.frame = frame
    config2.frame.Name = p2 .. "Section"
    config2.frame.Size = UDim2.new(1, 0, 0, 80 * v)
    config2.frame.BackgroundColor3 = config.Card
    config2.frame.BackgroundTransparency = config.GlassLight
    config2.frame.BorderSizePixel = 0
    config2.frame.LayoutOrder = config2.layoutOrder
    config2.frame.Parent = p1.page
    func_b40028aa(config2.frame, 20 * v)
    func_022841c4(config2.frame, 1 * v, config.BorderLight, 0.4)
    local frame2 = Instance.new("Frame")
    frame2.Name = "Header"
    frame2.Size = UDim2.new(1, 0, 0, 80 * v)
    frame2.BackgroundTransparency = 1
    frame2.Parent = config2.frame
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -100 * v, 0, 30 * v)
    textLabel.Position = UDim2.new(0, 25 * v, 0, 15 * v)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = p2
    textLabel.TextColor3 = config.TextPrimary
    textLabel.TextSize = 18 * v
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame2

    if p3 then
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(1, -100 * v, 0, 20 * v)
        textLabel2.Position = UDim2.new(0, 25 * v, 0, 45 * v)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = p3
        textLabel2.TextColor3 = config.TextSecondary
        textLabel2.TextSize = 14 * v
        textLabel2.Font = Enum.Font.Gotham
        textLabel2.TextXAlignment = Enum.TextXAlignment.Left
        textLabel2.Parent = frame2
    end

    local frame3 = Instance.new("Frame")
    frame3.Name = "ContentContainer"
    frame3.Size = UDim2.new(1, -50 * v, 0, 200 * v)
    frame3.Position = UDim2.new(0, 25 * v, 0, 90 * v)
    frame3.BackgroundTransparency = 1
    frame3.Visible = true
    frame3.Parent = config2.frame
    config2.contentContainer = frame3
    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Padding = UDim.new(0, 15 * v)
    uIListLayout.Parent = frame3
    uIListLayout.Changed:Connect(func_52ef21c7)

    spawn(function()
        wait(0.1)
        func_52ef21c7()
    end)
    func_2893d23c(config2.frame, config.CardHover, config.Card)
    config2.TSButton = function(p0, p1)
        -- [5] TailCall: return R2(R3, R4, R5)

        return p0.tab.gui:TSButton
    end
    config2.TSToggle = function(p0, p1)
        -- [5] TailCall: return R2(R3, R4, R5)

        return p0.tab.gui:TSToggle
    end
    config2.TSKeyBind = function(p0, p1)
        -- [5] TailCall: return R2(R3, R4, R5)

        return p0.tab.gui:TSKeyBind
    end
    config2.TSDropdown = function(p0, p1)
        -- [5] TailCall: return R2(R3, R4, R5)

        return p0.tab.gui:TSDropdown
    end
    config2.TSColorPicker = function(p0, p1)
        -- [5] TailCall: return R2(R3, R4, R5)

        return p0.tab.gui:TSColorPicker
    end
    config2.TSSlider = function(p0, p1)
        -- [5] TailCall: return R2(R3, R4, R5)

        return p0.tab.gui:TSSlider
    end
    config2.TSTextBox = function(p0, p1)
        -- [5] TailCall: return R2(R3, R4, R5)

        return p0.tab.gui:TSTextBox
    end
    table.insert(p1.sections, config2)

    return config2
end
config15.TSButton = function(p0, p1, p2)
    if not (p2) then
        local config = {}
        local v = config
    end

    local v2 = config4.CurrentScale

    if not (v.text) then
    end

    if not (v.callback) then
    end

    if not (v.color) then
        local v3 = config.Primary
    end

    local v4 = v.icon
    local frame = Instance.new("Frame")
    frame.Name = "TSButton"
    frame.Size = UDim2.new(1, 0, 0, 60 * v2)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = #p1.elements + 1
    frame.Parent = p1.contentContainer
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(1, 0, 1, 0)
    textButton.BackgroundColor3 = v3
    textButton.BackgroundTransparency = 0.1
    textButton.BorderSizePixel = 0
    textButton.Text = ""
    textButton.Parent = frame
    func_b40028aa(textButton, 15 * v2)
    func_022841c4(textButton, 2 * v2, v3:lerp(config.TextPrimary, 0.3), 0.3)
    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(1, -40 * v2, 1, 0)
    frame2.Position = UDim2.new(0, 20 * v2, 0, 0)
    frame2.BackgroundTransparency = 1
    frame2.Parent = textButton
    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.FillDirection = Enum.FillDirection.Horizontal
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Padding = UDim.new(0, 10 * v2)
    uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uIListLayout.Parent = frame2

    if v4 then
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, 24 * v2, 0, 24 * v2)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = v4
        textLabel.TextColor3 = config.TextPrimary
        textLabel.TextSize = 20 * v2
        textLabel.Font = Enum.Font.GothamBold
        textLabel.LayoutOrder = 1
        textLabel.Parent = frame2
    end

    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(0, 200 * v2, 0, 30 * v2)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "Button"
    textLabel2.TextColor3 = config.TextPrimary
    textLabel2.TextSize = 16 * v2
    textLabel2.Font = Enum.Font.GothamSemibold
    textLabel2.LayoutOrder = 2
    textLabel2.Parent = frame2
    textButton.MouseEnter:Connect(function(...)
        func_3e08ce32(textButton, config3.Fast, {
            BackgroundColor3 = v3:lerp(config.TextPrimary, 0.1),
            BackgroundTransparency = 0.05,
        }):Play()
    end)
    textButton.MouseLeave:Connect(function(...)
        func_3e08ce32(textButton, config3.Fast, {
            BackgroundColor3 = v3,
            BackgroundTransparency = 0.1,
        }):Play()
    end)
    textButton.MouseButton1Click:Connect(function(...)
        func_c29bd3e3(textButton)
        local v, v2 = pcall(func_05a75bf4)

        if not (v) then
            warn("Button callback error:", v2)
        end
    end)
    table.insert(p1.elements, frame)

    return {
        element = frame,
        SetText = function(p0)
            textLabel2.Text = p0
        end,
        SetColor = function(p0)
            v3 = p0
            textButton.BackgroundColor3 = p0
        end,
        SetCallback = function(p0)
            func_05a75bf4 = p0
        end,
    }
end
config15.TSToggle = function(p0, p1, p2)
    if not (p2) then
        local config = {}
        local v = config
    end

    local v2 = config4.CurrentScale

    local v3 = v.keybind
    local v4 = false
    local v5 = v3
    local frame = Instance.new("Frame")
    frame.Name = "TSToggle"
    frame.Size = UDim2.new(1, 0, 0, 60 * v2)
    frame.BackgroundColor3 = config.Surface
    frame.BackgroundTransparency = config.GlassLight
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #p1.elements + 1
    frame.Parent = p1.contentContainer
    func_b40028aa(frame, 15 * v2)
    func_022841c4(frame, 1 * v2, config.Border, 0.4)

    local v6 = true

    if v6 then

        if not (-180 * v2) then
            local v7 = -100 * v2
        end

        if v6 then

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -120 * v2, 1, 0)
            textLabel.Position = UDim2.new(0, 20 * v2, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Toggle"
            textLabel.TextColor3 = config.TextPrimary
            textLabel.TextSize = 16 * v2
            textLabel.Font = Enum.Font.GothamSemibold
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.Parent = frame

            if v6 then
                local textButton = Instance.new("TextButton")
                local v8 = textButton
                v8.Size = UDim2.new(0, 60 * v2, 0, 35 * v2)
                v8.Position = UDim2.new(1, -180 * v2, 0.5, -17.5 * v2)
                v8.BackgroundColor3 = config.KeybindGrey
                v8.BackgroundTransparency = 0.1
                v8.BorderSizePixel = 0
                v8.Text = ""
                v8.Parent = frame
                func_b40028aa(v8, 12 * v2)
                func_022841c4(v8, 2 * v2, config.Primary, 0.4)
                local config2 = {}
                ColorSequenceKeypoint.new(0, config.KeybindGrey)
                func_96d4a870(v8, ColorSequence.new(config2), 45)
                local textLabel2 = Instance.new("TextLabel")
                local v9 = textLabel2
                v9.Size = UDim2.new(1, 0, 1, 0)
                v9.BackgroundTransparency = 1

                if v5 then
                    local v10 = type(v5)

                    if v10 == "string" then
                        -- [!] UNRESOLVED BRANCH: TestSet logic failed here
                    else
                    end

                    v9.Text = "None"
                    v9.TextColor3 = Color3.fromRGB(255, 255, 255)
                    v9.TextSize = 10 * v2
                    v9.Font = Enum.Font.GothamBold
                    v9.TextScaled = true
                    v9.Parent = v8
                    local frame2 = Instance.new("Frame")
                    frame2.Size = UDim2.new(0, 80 * v2, 0, 40 * v2)
                    frame2.Position = UDim2.new(1, v7 + 40, 0.5, -20 * v2)

                    if v4 then

                        frame2.BackgroundColor3 = config.Card
                        frame2.BorderSizePixel = 0
                        frame2.Parent = frame
                        func_b40028aa(frame2, 20 * v2)

                        if v4 then

                            func_022841c4(frame2, 2 * v2, config.BorderLight, 0.3)
                            local frame3 = Instance.new("Frame")
                            frame3.Size = UDim2.new(0, 32 * v2, 0, 32 * v2)

                            if v4 then

                                frame3.Position = UDim2.new(0, 4 * v2, 0.5, -16 * v2)
                                frame3.BackgroundColor3 = config.TextPrimary
                                frame3.BorderSizePixel = 0
                                frame3.Parent = frame2
                                func_b40028aa(frame3, 16 * v2)
                                func_022841c4(frame3, 1 * v2, config.BorderLight, 0.2)
                                local textButton2 = Instance.new("TextButton")
                                textButton2.Size = UDim2.new(1, 0, 1, 0)
                                textButton2.BackgroundTransparency = 1
                                textButton2.Text = ""
                                textButton2.Parent = frame2
                                textButton2.MouseButton1Click:Connect(function(...)
                                    v4 = not v4
                                    func_fff6b171()
                                    func_c29bd3e3(frame2)
                                end)

                                if v6 then
                                    frame2.Position = UDim2.new(1, v7 + 93, 0.5, -20 * v2)
                                else
                                    frame2.Position = UDim2.new(1, v7, 0.5, -20 * v2)
                                end

                                if v6 then

                                    if v5 then
                                        config6:bind(v5, function(...)
                                            v4 = not v4
                                            func_fff6b171()
                                        end)
                                    end

                                    local _upv0 = false
                                    v8.MouseButton1Click:Connect(function(...)
                                        if _upv0 then

                                            return

                                        end

                                        _upv0 = true
                                        v9.Text = "..."
                                        v8.BackgroundColor3 = config.Primary
                                        local _upv7 = nil
                                    end)
                                end

                                textButton2.MouseEnter:Connect(function(...)
                                    local config = {}
                                    config.Size = UDim2.new(0, 36 * v2, 0, 36 * v2)

                                    if v4 then

                                        config.Position = UDim2.new(0, 2 * v2, 0.5, -18 * v2)
                                        func_3e08ce32(frame3, config3.Fast, config):Play()

                                        return

                                    end
                                end)
                                textButton2.MouseLeave:Connect(function(...)
                                    local config = {}
                                    config.Size = UDim2.new(0, 32 * v2, 0, 32 * v2)

                                    if v4 then

                                        config.Position = UDim2.new(0, 4 * v2, 0.5, -16 * v2)
                                        func_3e08ce32(frame3, config3.Fast, config):Play()

                                        return

                                    end
                                end)
                                func_2893d23c(frame, config.SurfaceHover, config.Surface)
                                table.insert(p1.elements, frame)

                                return {
                                    element = frame,
                                    getValue = function(...)
                                        return v4
                                    end,
                                    setValue = function(p0)
                                        v4 = p0
                                        func_fff6b171()
                                    end,
                                    toggle = function(...)
                                        v4 = not v4
                                        func_fff6b171()
                                    end,
                                    setCallback = function(p0)
                                        func_935fa701 = p0
                                    end,
                                }

                            end
                        end
                    end
                end
            end
        end
    end
end
config15.TSKeyBind = function(p0, p1, p2)
    if not (p2) then
        local config = {}
        local v = config
    end

    local v2 = config4.CurrentScale

    local v3 = v.default
    local frame = Instance.new("Frame")
    frame.Name = "TSKeyBind"
    frame.Size = UDim2.new(1, 0, 0, 60 * v2)
    frame.BackgroundColor3 = config.Surface
    frame.BackgroundTransparency = config.GlassLight
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #p1.elements + 1
    frame.Parent = p1.contentContainer
    func_b40028aa(frame, 15 * v2)
    func_022841c4(frame, 1 * v2, config.Border, 0.4)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -160 * v2, 1, 0)
    textLabel.Position = UDim2.new(0, 20 * v2, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "KeyBind"
    textLabel.TextColor3 = config.TextPrimary
    textLabel.TextSize = 16 * v2
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 92 * v2, 0, 40 * v2)
    textButton.Position = UDim2.new(1, -107 * v2, 0.5, -20 * v2)
    textButton.BackgroundColor3 = config.KeybindGrey
    textButton.BackgroundTransparency = 0.1
    textButton.BorderSizePixel = 0
    textButton.Text = ""
    textButton.Parent = frame
    func_b40028aa(textButton, 12 * v2)
    func_022841c4(textButton, 2 * v2, config.Primary, 0.4)
    local config2 = {}
    ColorSequenceKeypoint.new(0, config.KeybindGrey)
    func_96d4a870(textButton, ColorSequence.new(config2), 45)
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(1, 0, 1, 0)
    textLabel2.BackgroundTransparency = 1

    if v3 then

        textLabel2.Text = "None"
        textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel2.TextSize = 10 * v2
        textLabel2.Font = Enum.Font.GothamBold
        textLabel2.TextScaled = true
        textLabel2.Parent = textButton
        local v4 = false
        textButton.MouseButton1Click:Connect(function(...)
            if not (v4) then
                v4 = true
                func_3b02ae56()
                config6:StartListening(function(p0)
                    if v3 then
                        config6:unbind(v3)
                    end

                    v3 = p0

                    if v3 then
                        config6:bind(v3, func_f8a350a5)
                    end

                    v4 = false
                    func_3b02ae56()
                end, textButton)
                func_c29bd3e3(textButton)
            end
        end)
        textButton.MouseEnter:Connect(function(...)
            if not (v4) then
                func_3e08ce32(textButton, config3.Fast, {
                    BackgroundColor3 = config.CardHover,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                }):Play()
            end
        end)
        textButton.MouseLeave:Connect(function(...)
            if not (v4) then
                func_3e08ce32(textButton, config3.Fast, {
                    BackgroundColor3 = config.KeybindGrey,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                }):Play()
            end
        end)

        if v3 then
            config6:bind(v3, func_f8a350a5)
        end

        func_2893d23c(frame, config.SurfaceHover, config.Surface)
        table.insert(p1.elements, frame)

        return {
            element = frame,
            GetKeybind = function(...)
                return v3
            end,
            SetKeybind = function(p0)
                if v3 then
                    config6:unbind(v3)
                end

                v3 = p0

                if v3 then
                    config6:bind(v3, func_f8a350a5)
                end

                func_3b02ae56()
            end,
            SetCallback = function(p0)
                func_f8a350a5 = p0

                if v3 then
                    config6:unbind(v3)
                    config6:bind(v3, func_f8a350a5)
                end
            end,
        }

    end
end
config15.TSDropdown = function(p0, p1, p2)
    if not (p2) then
        local config = {}
        local v = config
    end

    local v2 = config4.CurrentScale

    if not (v.text) then
        local v3 = "Dropdown"
    end

    if not (v.options) then
        local config2 = {"Option 1", "Option 2", "Option 3"}
    end

    if not (v.callback) then
    end

    if not (v.multi) then
    end

    local v4 = false

    if not (v.maxVisible) then
    end

    local v5 = v.default

    if not (v.autoUpdate) then
    end

    local config3 = {}

    if v5 then

        if v4 then

            if type(v5) == "table" then
                -- [!] UNRESOLVED BRANCH: TestSet logic failed here
            else
                local config4 = {v5}
            end
        else
            local config5 = {v5}
            local v6 = config5
        end
    end

    local frame = Instance.new("Frame")
    frame.Name = "TSDropdown"
    frame.Size = UDim2.new(1, 0, 0, 60 * v2)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = #p1.elements + 1
    frame.Parent = p1.contentContainer
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(1, 0, 0, 60 * v2)
    textButton.BackgroundColor3 = config.Surface
    textButton.BackgroundTransparency = config.GlassLight
    textButton.BorderSizePixel = 0
    textButton.Text = ""
    textButton.Active = true
    textButton.Selectable = true
    textButton.Parent = frame
    func_b40028aa(textButton, 15 * v2)
    func_022841c4(textButton, 1 * v2, config.Border, 0.4)
    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(1, -40 * v2, 1, 0)
    frame2.Position = UDim2.new(0, 20 * v2, 0, 0)
    frame2.BackgroundTransparency = 1
    frame2.Parent = textButton
    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.FillDirection = Enum.FillDirection.Horizontal
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uIListLayout.Parent = frame2
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -40 * v2, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = v3
    textLabel.TextColor3 = config.TextPrimary
    textLabel.TextSize = 16 * v2
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.LayoutOrder = 1
    textLabel.Parent = frame2
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(0, 150 * v2, 1, 0)
    textLabel2.BackgroundTransparency = 1

    if 0 < #v6 and v4 then

        if not (table.concat(v6, ", ")) and not (v6[1]) then
        end

        textLabel2.Text = "None"
        textLabel2.TextColor3 = config.TextSecondary
        textLabel2.TextSize = 14 * v2
        textLabel2.Font = Enum.Font.Gotham
        textLabel2.TextXAlignment = Enum.TextXAlignment.Right
        textLabel2.LayoutOrder = 2
        textLabel2.Parent = frame2
        local textLabel3 = Instance.new("TextLabel")
        textLabel3.Size = UDim2.new(0, 24 * v2, 0, 24 * v2)
        textLabel3.BackgroundTransparency = 1
        textLabel3.Text = "��"
        textLabel3.TextColor3 = config.TextSecondary
        textLabel3.TextSize = 14 * v2
        textLabel3.Font = Enum.Font.GothamBold
        textLabel3.LayoutOrder = 3
        textLabel3.Parent = frame2
        local v7 = nil
        local v8 = false
        local _upv3 = math.min(#config2, 5) * 45 * v2 + 10 * v2
        textButton.MouseButton1Click:Connect(function(...)
            func_c29bd3e3(textButton)

            if v8 then
                func_98e1eb94()
            else
                func_6f3a48ae()
            end
        end)
        func_2893d23c(textButton, config.SurfaceHover, config.Surface)

        if false then

            task.spawn(function()
                while true do
                    wait(3)
                    func_66de505e()
                end
            end)
        end

        config13:register({
            close = func_98e1eb94,
        })
        table.insert(p1.elements, frame)

        return {
            element = frame,
            GetSelected = function(...)
                if v4 then

                    if not (v6) then
                    end

                    return v6[1]

                end
            end,
            SetSelected = function(p0)
                if v4 then
                    local v = type(p0)

                    if v == "table" then
                        -- [!] UNRESOLVED BRANCH: TestSet logic failed here
                    else
                        local config = {p0}

                        if not (config) then
                            local config2 = {p0}
                        end
                    end

                    v6 = config2
                    func_cb554d64()

                    return

                end
            end,
            AddOption = function(p0)
                table.insert(config2, p0)
            end,
            close = func_98e1eb94,
        }

    end
end
config15.TSColorPicker = function(p0, p1, p2)
    if not (p2) then
        local config = {}
        local v = config
    end

    local v2 = config4.CurrentScale

    local v3 = Color3.fromRGB(255, 255, 255)
    local v4, v5, v6 = func_006720de(v3.R, v3.G, v3.B)
    local v7 = v6
    local v8 = v5
    local v9 = v4
    local frame = Instance.new("Frame")
    frame.Name = "TSColorPicker"
    frame.Size = UDim2.new(1, 0, 0, 60 * v2)
    frame.BackgroundColor3 = config.Surface
    frame.BackgroundTransparency = config.GlassLight
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #p1.elements + 1
    frame.Parent = p1.contentContainer
    func_b40028aa(frame, 15 * v2)
    func_022841c4(frame, 1 * v2, config.Border, 0.4)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -200 * v2, 1, 0)
    textLabel.Position = UDim2.new(0, 20 * v2, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Color Picker"
    textLabel.TextColor3 = config.TextPrimary
    textLabel.TextSize = 16 * v2
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(0, 80 * v2, 1, 0)
    textLabel2.Position = UDim2.new(1, -165 * v2, 0, 0)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = string.format("%d,%d,%d", v3.R * 255, v3.G * 255, v3.B * 255)
    textLabel2.TextColor3 = config.TextSecondary
    textLabel2.TextSize = 14 * v2
    textLabel2.Font = Enum.Font.Gotham
    textLabel2.TextXAlignment = Enum.TextXAlignment.Right
    textLabel2.Parent = frame
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 60 * v2, 0, 40 * v2)
    textButton.Position = UDim2.new(1, -75 * v2, 0.5, -20 * v2)
    textButton.BackgroundColor3 = v3
    textButton.BorderSizePixel = 0
    textButton.Text = ""
    textButton.Parent = frame
    func_b40028aa(textButton, 12 * v2)
    func_022841c4(textButton, 2 * v2, config.Primary, 0.4)
    local v10 = false
    local _upv0 = nil
    textButton.MouseButton1Click:Connect(function(...)
        if not (v10) then
            v10 = true
            func_19b28ce3()
        end

        func_c29bd3e3(textButton)
    end)
    textButton.MouseEnter:Connect(function(...)
        func_3e08ce32(textButton, config3.Fast, {
            Size = UDim2.new(0, 64 * v2, 0, 44 * v2),
            Position = UDim2.new(1, -77 * v2, 0.5, -22 * v2),
        }):Play()
    end)
    textButton.MouseLeave:Connect(function(...)
        func_3e08ce32(textButton, config3.Fast, {
            Size = UDim2.new(0, 60 * v2, 0, 40 * v2),
            Position = UDim2.new(1, -75 * v2, 0.5, -20 * v2),
        }):Play()
    end)
    func_2893d23c(frame, config.SurfaceHover, config.Surface)
    table.insert(p1.elements, frame)

    return {
        element = frame,
        GetColor = function(...)
            return v3
        end,
        SetColor = function(p0)
            v3 = p0
            local v, v2, v3 = func_006720de(p0.R, p0.G, p0.B)
            v7 = v3
            v8 = v2
            v9 = v
            func_4f9e56c4()
        end,
        SetCallback = function(p0)
            func_f261ee6c = p0
        end,
    }
end
config15.TSSlider = function(p0, p1, p2)
    if not (p2) then
        local config = {}
        local v = config
    end

    local v2 = config4.CurrentScale

    if not (v.min) then
        local v3 = 0
    end

    if not (v.max) then
        local v4 = 100
    end

    if not (v.suffix) then
        local v5 = ""
    end

    local v6 = v3
    local frame = Instance.new("Frame")
    frame.Name = "TSSlider"
    frame.Size = UDim2.new(1, 0, 0, 80 * v2)
    frame.BackgroundColor3 = config.Surface
    frame.BackgroundTransparency = config.GlassLight
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #p1.elements + 1
    frame.Parent = p1.contentContainer
    func_b40028aa(frame, 15 * v2)
    func_022841c4(frame, 1 * v2, config.Border, 0.4)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -120 * v2, 0, 30 * v2)
    textLabel.Position = UDim2.new(0, 20 * v2, 0, 10 * v2)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Slider"
    textLabel.TextColor3 = config.TextPrimary
    textLabel.TextSize = 16 * v2
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(0, 80 * v2, 0, 30 * v2)
    textLabel2.Position = UDim2.new(1, -100 * v2, 0, 10 * v2)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = tostring(v6) .. v5
    textLabel2.TextColor3 = config.TextSecondary
    textLabel2.TextSize = 14 * v2
    textLabel2.Font = Enum.Font.GothamBold
    textLabel2.TextXAlignment = Enum.TextXAlignment.Right
    textLabel2.Parent = frame
    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(1, -40 * v2, 0, 8 * v2)
    frame2.Position = UDim2.new(0, 20 * v2, 0, 50 * v2)
    frame2.BackgroundColor3 = config.Card
    frame2.BorderSizePixel = 0
    frame2.Parent = frame
    func_b40028aa(frame2, 4 * v2)
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(v6 - v3 / v4 - v3, 0, 1, 0)
    frame3.BackgroundColor3 = config.Primary
    frame3.BorderSizePixel = 0
    frame3.Parent = frame2
    func_b40028aa(frame3, 4 * v2)
    local frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new(0, 20 * v2, 0, 20 * v2)
    frame4.Position = UDim2.new(v6 - v3 / v4 - v3, -10 * v2, 0.5, -10 * v2)
    frame4.BackgroundColor3 = config.TextPrimary
    frame4.BorderSizePixel = 0
    frame4.Parent = frame2
    frame4.ZIndex = frame2.ZIndex + 5
    func_b40028aa(frame4, 10 * v2)
    func_022841c4(frame4, 2 * v2, config.Primary, 0.3)
    local v7 = false
    local v8 = nil
    local _upv7 = 1
    frame2.InputBegan:Connect(func_d5438391)
    frame4.InputBegan:Connect(func_d5438391)
    UserInputService.InputEnded:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

            if p0.UserInputType == Enum.UserInputType.Touch and v7 then
                v7 = false

                if v8 then
                    v8:Disconnect()
                    v8 = nil
                end
            end

            return

        end
    end)
    frame4.MouseEnter:Connect(function(...)
        func_3e08ce32(frame4, config3.Fast, {
            Size = UDim2.new(0, 24 * v2, 0, 24 * v2),
            Position = UDim2.new(v6 - v3 / v4 - v3, -12 * v2, 0.5, -12 * v2),
        }):Play()
    end)
    frame4.MouseLeave:Connect(function(...)
        if not (v7) then
            func_3e08ce32(frame4, config3.Fast, {
                Size = UDim2.new(0, 20 * v2, 0, 20 * v2),
                Position = UDim2.new(v6 - v3 / v4 - v3, -10 * v2, 0.5, -10 * v2),
            }):Play()
        end
    end)
    func_2893d23c(frame, config.SurfaceHover, config.Surface)
    table.insert(p1.elements, frame)

    return {
        element = frame,
        GetValue = function(...)
            return v6
        end,
        SetValue = function(p0)
            v6 = math.clamp(p0, v3, v4)
            func_f3df5f51()
        end,
        SetRange = function(p0, p1)
            v3 = p0
            v4 = p1
            v6 = math.clamp(v6, v3, v4)
            func_f3df5f51()
        end,
    }
end
config15.TSTextBox = function(p0, p1, p2)
    if not (p2) then
        local config = {}
        local v = config
    end

    local v2 = config4.CurrentScale

    if not (v.multiline) then
        local v3 = false
    end

    local frame = Instance.new("Frame")
    frame.Name = "TSTextBox"

    if v3 then

        frame.Size = UDim2.new(1, 0, 0, 60 * v2)
        frame.BackgroundColor3 = config.Surface
        frame.BackgroundTransparency = config.GlassLight
        frame.BorderSizePixel = 0
        frame.LayoutOrder = #p1.elements + 1
        frame.Parent = p1.contentContainer
        func_b40028aa(frame, 15 * v2)
        func_022841c4(frame, 1 * v2, config.Border, 0.4)
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -40 * v2, 0, 25 * v2)
        textLabel.Position = UDim2.new(0, 20 * v2, 0, 5 * v2)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "TextBox"
        textLabel.TextColor3 = config.TextPrimary
        textLabel.TextSize = 14 * v2
        textLabel.Font = Enum.Font.GothamSemibold
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = frame
        local textBox = Instance.new("TextBox")

        if v3 then

            if not (60 * v2) then
            end

            textBox.Size = UDim2.new(1, -40 * v2, 0, 25 * v2)

            if v3 then

                if not (30 * v2) then
                end

                textBox.Position = UDim2.new(0, 20 * v2, 0, 30 * v2)
                textBox.BackgroundColor3 = config.Card
                textBox.BackgroundTransparency = 0.2
                textBox.BorderSizePixel = 0
                textBox.Text = ""
                textBox.PlaceholderText = "Enter text..."
                textBox.TextColor3 = config.TextPrimary
                textBox.PlaceholderColor3 = config.TextMuted
                textBox.TextSize = 14 * v2
                textBox.Font = Enum.Font.Gotham
                textBox.TextXAlignment = Enum.TextXAlignment.Left

                if v3 then

                    if not (Enum.TextYAlignment.Top) then
                    end

                    textBox.TextYAlignment = Enum.TextYAlignment.Center
                    textBox.MultiLine = v3
                    textBox.TextWrapped = v3
                    textBox.Parent = frame
                    func_b40028aa(textBox, 10 * v2)
                    func_022841c4(textBox, 1 * v2, config.BorderLight, 0.5)
                    textBox.Focused:Connect(function()
                        func_3e08ce32(textBox, config3.Fast, {
                            BackgroundColor3 = config.CardElevated,
                            BackgroundTransparency = 0.1,
                        }):Play()
                        func_3e08ce32(textBox.UIStroke, config3.Fast, {
                            Color = config.Primary,
                            Transparency = 0.2,
                        }):Play()
                    end)
                    textBox.FocusLost:Connect(function(...)
                        func_3e08ce32(textBox, config3.Fast, {
                            BackgroundColor3 = config.Card,
                            BackgroundTransparency = 0.2,
                        }):Play()
                        func_3e08ce32(textBox.UIStroke, config3.Fast, {
                            Color = config.BorderLight,
                            Transparency = 0.5,
                        }):Play()
                        local v, v2 = pcall(function()
                        end, textBox.Text)

                        if not (v) then
                            warn("TextBox callback error:", v2)
                        end
                    end)

                    if false then
                        textBox.Changed:Connect(function(p0)
                            if p0 == "Text" then
                                local v = textBox.Text:gsub("[^%d%.%-]", "")

                                if v ~= textBox.Text then
                                    textBox.Text = v
                                end
                            end
                        end)
                    end

                    func_2893d23c(frame, config.SurfaceHover, config.Surface)
                    table.insert(p1.elements, frame)

                    return {
                        element = frame,
                        getText = function()
                            return textBox.Text
                        end,
                        SetText = function(p0)
                            textBox.Text = p0
                        end,
                        focus = function()
                            textBox:CaptureFocus()
                        end,
                        clearText = function()
                            textBox.Text = ""
                        end,
                    }

                end
            end
        end
    end
end
config15.SetupControls = function(p0)
    p0.MinimizeBtn.MouseButton1Click:Connect(function()
        p0:minimize()
    end)
    p0.MaximizeBtn.MouseButton1Click:Connect(function()
        p0:maximize()
    end)
    p0.CloseBtn.MouseButton1Click:Connect(function()
        p0:destroy()
    end)
end
config15.SetupDragging = function(p0)
    local v = false
    p0.Header.InputBegan:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

            if p0.UserInputType == Enum.UserInputType.Touch and not (p0.isMaximized) then
                v = true
                v1 = p0.Position
                v2 = p0.MainFrame.Position
            end

            return

        end
    end)
    UserInputService.InputChanged:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseMovement then

            if p0.UserInputType == Enum.UserInputType.Touch and v then
                local v = p0.Position - v1
                p0.MainFrame.Position = UDim2.new(v2.X.Scale, v2.X.Offset + v.X, v2.Y.Scale, v2.Y.Offset + v.Y)
            end

            return

        end
    end)
    UserInputService.InputEnded:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

            if p0.UserInputType == Enum.UserInputType.Touch then
                v = false
            end

            return

        end
    end)
end
config15.SetupKeybinds = function(p0)
    config6:bind(p0.KeybindToggle, function()
        p0:toggle()
    end)
end
config15.SetupScaling = function(p0)
    p0.scaleConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        config4:CalculateScale()
        p0:UpdateScaling()
    end)
end
config15.UpdateScaling = function(p0)
end
config15.minimize = function(p0)
    p0.isMinimized = not p0.isMinimized

    if p0.isMinimized then

        if not (UDim2.new(0, 350 * config4.CurrentScale, 0, 90 * config4.CurrentScale)) then
        end

        if p0.isMinimized then

            if not (0.7) then
            end

            func_3e08ce32(p0.MainFrame, config3.Elastic, {
                Size = p0.originalSize,
                BackgroundTransparency = config.GlassMain,
            }):Play()
            p0.ContentArea.Visible = not p0.isMinimized

            if p0.isMinimized then

                if not ("+") then
                end

                p0.MinimizeBtn.Text = "��"

                return

            end
        end
    end
end
config15.maximize = function(p0)
    p0.isMaximized = not p0.isMaximized
    local v = workspace.CurrentCamera.ViewportSize
    local v2 = config4.CurrentScale

    if p0.isMaximized then

        func_3e08ce32(p0.MainFrame, config3.Back, {
            Size = p0.originalSize,
            Position = p0.originalPosition,
        }):Play()

        if p0.isMaximized then

            p0.MaximizeBtn.Text = "��"

            return

        end
    end
end
config15.toggle = function(p0)
    p0.isVisible = not p0.isVisible
    p0.ScreenGui.Enabled = p0.isVisible
end
config15.destroy = function(p0)
    config6:unbindAll()

    if p0.scaleConnection then
        p0.scaleConnection:Disconnect()
    end

    config13:CloseAll()

    if p0.ScreenGui then
        local v = func_3e08ce32(p0.MainFrame, config3.FadeOut, {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
        })
        v:Play()
        v.Completed:Connect(function()
            p0.ScreenGui:Destroy()
        end)
    end
end

local function func_d5438391(p0)

    if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

        if p0.UserInputType == Enum.UserInputType.Touch then
            v7 = true
            v8 = UserInputService.InputChanged:Connect(function(p0)
                if p0.UserInputType ~= Enum.UserInputType.MouseMovement then

                    if p0.UserInputType == Enum.UserInputType.Touch and v7 then
                        v6 = math.floor(v3 + v4 - v3 * math.clamp(p0.Position.X - frame2.AbsolutePosition.X / frame2.AbsoluteSize.X, 0, 1) / _upv7 + 0.5) * _upv7
                        v6 = math.clamp(v6, v3, v4)
                        func_f3df5f51()
                    end

                    return

                end
            end)
        end

        return

    end
end

local function func_f3df5f51(...)
    local v = v6 - v3 / v4 - v3
    func_3e08ce32(frame3, config3.Fast, {
        Size = UDim2.new(v, 0, 1, 0),
    }):Play()
    func_3e08ce32(frame4, config3.Fast, {
        Position = UDim2.new(v, -10 * v2, 0.5, -10 * v2),
    }):Play()
    textLabel2.Text = tostring(v6) .. v5
    local v2, v3 = pcall(function()
    end, v6)

    if not (v2) then
        warn("Slider callback error:", v3)
    end

    return

end

local function func_f261ee6c()

    return

end

local function func_006720de(p0, p1, p2)
    local v = math.max(p0, p1, p2)
    local v2 = v - math.min(p0, p1, p2)

    if 0 < v2 then

        if v == p0 then
        else
            if v == p1 then
            else
            end
        end
    end

    if v == 0 then

        return p0 - p1 / v2 + 4 / 6, v2 / v, v

    end
end

local function func_4f9e56c4(...)
    v3 = func_656cd8bc(v9, v8, v7)
    textButton.BackgroundColor3 = v3
    textLabel2.Text = string.format("%d,%d,%d", math.floor(v3.R * 255), math.floor(v3.G * 255), math.floor(v3.B * 255))
    local v, v2 = pcall(func_f261ee6c, v3)

    if not (v) then
        warn("Color picker callback error:", v2)
    end

    return

end

local function func_656cd8bc(p0, p1, p2)
    local v = p2 * p1
    local v2 = v * 1 - math.abs(p0 * 6 % 2 - 1)
    local v3 = p2 - v

    if p0 < 0.16666666666666666 then
    else
        if p0 < 0.3333333333333333 then
        else
            if p0 < 0.5 then
            else
                if p0 < 0.6666666666666666 then
                else
                    if p0 < 0.8333333333333334 then
                    else
                    end
                end
            end
        end
    end

    -- [63] TailCall: return R9(R10, R11, R12)

    return Color3.new

end

local function func_19b28ce3(...)

    if _upv0 then

        return

    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.ZIndex = 999
    frame.Active = true
    frame.Parent = p0.ScreenGui
    local frame2 = Instance.new("Frame")
    _upv0 = frame2
    _upv0.Size = UDim2.new(0, 300 * v2, 0, 350 * v2)
    _upv0.Position = UDim2.new(0.5, -150 * v2, 0.5, -175 * v2)
    _upv0.BackgroundColor3 = config.Card
    _upv0.BackgroundTransparency = 0.05
    _upv0.BorderSizePixel = 0
    _upv0.ZIndex = 1000
    _upv0.Parent = frame
    func_b40028aa(_upv0, 20 * v2)
    func_022841c4(_upv0, 2 * v2, config.Primary, 0.3)
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, -40 * v2, 0, 200 * v2)
    frame3.Position = UDim2.new(0, 20 * v2, 0, 20 * v2)
    frame3.BackgroundColor3 = func_656cd8bc(v9, 1, 1)
    frame3.BorderSizePixel = 0
    frame3.Parent = _upv0
    func_b40028aa(frame3, 10 * v2)
    local uIGradient = Instance.new("UIGradient")
    local config = {}
    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1))
    uIGradient.Color = ColorSequence.new(config)
    local config2 = {}
    NumberSequenceKeypoint.new(0, 0)
    uIGradient.Transparency = NumberSequence.new(config2)
    uIGradient.Rotation = 0
    uIGradient.Parent = frame3
    local frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new(1, 0, 1, 0)
    frame4.BackgroundColor3 = Color3.new(0, 0, 0)
    frame4.BorderSizePixel = 0
    frame4.Parent = frame3
    local uIGradient2 = Instance.new("UIGradient")
    local config3 = {}
    NumberSequenceKeypoint.new(0, 1)
    uIGradient2.Transparency = NumberSequence.new(config3)
    uIGradient2.Rotation = 90
    uIGradient2.Parent = frame4
    local frame5 = Instance.new("Frame")
    frame5.Size = UDim2.new(1, -40 * v2, 0, 30 * v2)
    frame5.Position = UDim2.new(0, 20 * v2, 0, 240 * v2)
    frame5.BorderSizePixel = 0
    frame5.Parent = _upv0
    func_b40028aa(frame5, 15 * v2)
    local config4 = {}
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0))
    ColorSequenceKeypoint.new(0.16666666666666666, Color3.fromRGB(255, 255, 0))
    ColorSequenceKeypoint.new(0.3333333333333333, Color3.fromRGB(0, 255, 0))
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255))
    ColorSequenceKeypoint.new(0.6666666666666666, Color3.fromRGB(0, 0, 255))
    ColorSequenceKeypoint.new(0.8333333333333334, Color3.fromRGB(255, 0, 255))
    local frame6 = Instance.new("Frame")
    frame6.Size = UDim2.new(0, 10 * v2, 0, 10 * v2)
    frame6.Position = UDim2.new(v8, -5 * v2, 1 - v7, -5 * v2)
    frame6.BackgroundColor3 = Color3.new(1, 1, 1)
    frame6.BorderSizePixel = 0
    frame6.ZIndex = frame3.ZIndex + 1
    frame6.Parent = frame3
    func_b40028aa(frame6, 5 * v2)
    func_022841c4(frame6, 2 * v2, Color3.new(0, 0, 0), 0)
    local frame7 = Instance.new("Frame")
    frame7.Size = UDim2.new(0, 6 * v2, 1, 0)
    frame7.Position = UDim2.new(v9, -3 * v2, 0, 0)
    frame7.BackgroundColor3 = Color3.new(1, 1, 1)
    frame7.BorderSizePixel = 0
    frame7.ZIndex = frame5.ZIndex + 1
    frame7.Parent = frame5
    func_b40028aa(frame7, 3 * v2)
    func_022841c4(frame7, 1 * v2, Color3.new(0, 0, 0), 0)
    local v = false
    local v2 = false
    frame3.InputBegan:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

            if p0.UserInputType == Enum.UserInputType.Touch then
                v = true
            end

            return

        end
    end)
    frame5.InputBegan:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

            if p0.UserInputType == Enum.UserInputType.Touch then
                v2 = true
            end

            return

        end
    end)
    UserInputService.InputChanged:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseMovement then

            if p0.UserInputType == Enum.UserInputType.Touch then

                if v then
                    local v = frame3.AbsolutePosition
                    local v2 = frame3.AbsoluteSize
                    local v3 = p0.Position
                    v8 = math.clamp(v3.X - v.X / v2.X, 0, 1)
                    v7 = 1 - math.clamp(v3.Y - v.Y / v2.Y, 0, 1)
                    frame6.Position = UDim2.new(v8, -5 * v2, 1 - v7, -5 * v2)
                    func_4f9e56c4()
                else
                    if v2 then
                        v9 = math.clamp(p0.Position.X - frame5.AbsolutePosition.X / frame5.AbsoluteSize.X, 0, 1)
                        frame7.Position = UDim2.new(v9, -3 * v2, 0, 0)
                        frame3.BackgroundColor3 = func_656cd8bc(v9, 1, 1)
                        func_4f9e56c4()
                    end
                end
            end

            return

        end
    end)
    UserInputService.InputEnded:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

            if p0.UserInputType == Enum.UserInputType.Touch then
                v = false
                v2 = false
            end

            return

        end
    end)
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 30 * v2, 0, 30 * v2)
    textButton.Position = UDim2.new(1, -40 * v2, 0, 10 * v2)
    textButton.BackgroundColor3 = config.Error
    textButton.BackgroundTransparency = 0.2
    textButton.BorderSizePixel = 0
    textButton.Text = "�"
    textButton.TextColor3 = config.TextPrimary
    textButton.TextSize = 18 * v2
    textButton.Font = Enum.Font.GothamBold
    textButton.Parent = _upv0
    func_b40028aa(textButton, 15 * v2)
    textButton.MouseButton1Click:Connect(function(...)
        frame:Destroy()
        _upv0 = nil
        v10 = false
    end)
    frame.MouseButton1Click:Connect(function(...)
        frame:Destroy()
        _upv0 = nil
        v10 = false
    end)

    return

end

local function func_3b02ae56(...)

    if v4 then
        textLabel2.Text = "Press any key..."
        textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        func_3e08ce32(textButton, config3.Breathe, {
            BackgroundColor3 = config.Warning:lerp(config.TextPrimary, 0.7),
        }):Play()
    else
        if v3 then

            textLabel2.Text = "None"
            textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
            textButton.BackgroundColor3 = config.KeybindGrey

            return

        end
    end
end

local function func_f8a350a5()

    return

end

local function func_fff6b171(...)

    if v4 then

        func_3e08ce32(frame2, config3.Fast, {
            BackgroundColor3 = config.Card,
        }):Play()
        func_3e08ce32(frame2.UIStroke, config3.Fast, {
            Color = config.BorderLight,
        }):Play()
        local config3 = {}
        config3.Position = UDim2.new(0, 4 * v2, 0.5, -16 * v2)
        func_3e08ce32(frame3, config3.Elastic, config3):Play()
        local v, v2 = pcall(func_935fa701, v4)

        if not (v) then
            warn("Toggle callback error:", v2)
        end

        return

    end
end

local function func_935fa701()

    return

end

local function func_1b2d3627(p0)

    if p0.UserInputType == Enum.UserInputType.Keyboard then

        if v5 then
            config6:unbind(v5)
        end

        v5 = p0.KeyCode
        v9.Text = p0.KeyCode.Name
        config6:bind(v5, function(...)
            v4 = not v4
            func_fff6b171()
        end)
        v8.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
        _upv0 = false
        _upv7:Disconnect()
    end

    return

end

local function func_3e08ce32(p0, p1, p2)
    -- [5] TailCall: return R3(R4, R5, R6, R7)

    return TweenService:Create

end

local function func_c29bd3e3(p0, p1)
    local frame = Instance.new("Frame")
    frame.Name = "RippleEffect"
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0, p1.X, 0, p1.Y)
    frame.BackgroundColor3 = config.Primary
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.ZIndex = p0.ZIndex + 10
    frame.ClipsDescendants = true
    frame.Parent = p0
    func_b40028aa(frame, 1000)
    local v = math.max(p0.AbsoluteSize.X, p0.AbsoluteSize.Y) * 2.5
    local v2 = func_3e08ce32(frame, config3.Normal, {
        Size = UDim2.new(0, v, 0, v),
        Position = UDim2.new(0, p1.X - v / 2, 0, p1.Y - v / 2),
        BackgroundTransparency = 1,
    })
    v2:Play()
    v2.Completed:Connect(function()
        frame:Destroy()
    end)

    return frame

end

local function func_05a75bf4()

    return

end

local function func_022841c4(p0, p1, p2, p3)
    local v = "UIStroke"
    local v2 = Instance.new(v)
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_10 (Fix manually)
    local v3 = config4:GetScaledValue(1)
    v2.Thickness = v3
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_15 (Fix manually)
    local v4 = config.Border
    v2.Color = v4
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_19 (Fix manually)
    v2.Transparency = 0
    v2.Parent = p0

    return v2

end

local function func_96d4a870(p0, p1, p2, p3)
    local v = "UIGradient"
    local v2 = Instance.new(v)
    v2.Color = p1
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_8 (Fix manually)
    v2.Rotation = 90

    if p3 then
        v2.Transparency = p3
    end

    v2.Parent = p0

    return v2

end

local function func_66de505e(...)

    if v7 then

        return

    end

    local imageButton = Instance.new("ImageButton")
    imageButton.Size = UDim2.new(1, 0, 1, 0)
    imageButton.Position = UDim2.new(0, 0, 0, 0)
    imageButton.BackgroundColor3 = Color3.new(0, 0, 0)
    imageButton.BackgroundTransparency = 0.5
    imageButton.BorderSizePixel = 0
    imageButton.ZIndex = 999
    imageButton.AutoButtonColor = false
    imageButton.Parent = p0.ScreenGui
    local frame = Instance.new("Frame")
    v7 = frame
    v7.Size = UDim2.new(0, 300 * v2, 0, math.min(_upv3 + 80 * v2, 400 * v2))
    v7.Position = UDim2.new(0.5, -150 * v2, 0.5, -200 * v2)
    v7.BackgroundColor3 = config.Card
    v7.BackgroundTransparency = 0.05
    v7.BorderSizePixel = 0
    v7.ZIndex = 1000
    v7.Parent = imageButton
    func_b40028aa(v7, 20 * v2)
    func_022841c4(v7, 2 * v2, config.Primary, 0.3)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -60 * v2, 0, 40 * v2)
    textLabel.Position = UDim2.new(0, 20 * v2, 0, 10 * v2)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = v3
    textLabel.TextColor3 = config.TextPrimary
    textLabel.TextSize = 18 * v2
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = v7
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 30 * v2, 0, 30 * v2)
    textButton.Position = UDim2.new(1, -40 * v2, 0, 15 * v2)
    textButton.BackgroundColor3 = config.Error
    textButton.BackgroundTransparency = 0.2
    textButton.BorderSizePixel = 0
    textButton.Text = "�"
    textButton.TextColor3 = config.TextPrimary
    textButton.TextSize = 18 * v2
    textButton.Font = Enum.Font.GothamBold
    textButton.Parent = v7
    func_b40028aa(textButton, 15 * v2)
    textButton.MouseButton1Click:Connect(function(...)
        imageButton:Destroy()
        v7 = nil
        v8 = false
    end)
    imageButton.MouseButton1Click:Connect(function(...)
        imageButton:Destroy()
        v7 = nil
        v8 = false
    end)
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -20 * v2, 1, -70 * v2)
    scrollingFrame.Position = UDim2.new(0, 10 * v2, 0, 60 * v2)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6 * v2
    scrollingFrame.ScrollBarImageColor3 = config.Primary
    local v = v2
    local v2 = #config2 * 50 * v
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v2)
    scrollingFrame.Parent = v7
    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Padding = UDim.new(0, 2 * v2)
    uIListLayout.Parent = scrollingFrame

    for v3, v4 in ipairs(config2) do
        local textButton2 = Instance.new("TextButton")
        textButton2.Size = UDim2.new(1, -10 * v2, 0, 45 * v2)
        local v5 = v2
        textButton2.Position = UDim2.new(0, 5 * v2, 0, v3 - 1 * 50 * v5)
        textButton2.BackgroundColor3 = config.Surface
        textButton2.BackgroundTransparency = 0.3
        textButton2.BorderSizePixel = 0
        textButton2.Text = v4
        textButton2.TextColor3 = config.TextPrimary
        textButton2.TextSize = 16 * v2
        textButton2.Font = Enum.Font.GothamMedium
        textButton2.Parent = scrollingFrame
        func_b40028aa(textButton2, 12 * v2)

        for v6, v7 in ipairs(v6) do

            if v7 == v4 then
            else
            end
        end

        if true then
            textButton2.BackgroundColor3 = config.Primary
            textButton2.BackgroundTransparency = 0.1
        end

        textButton2.MouseButton1Click:Connect(function(...)
            if v4 then

                for v, v2 in ipairs(v6) do

                    if v2 == v4 then
                        local v3 = table.remove
                        v3(v6, v)
                    else
                    end
                end

                if not (true) then
                    table.insert(v6, v4)
                end

                for v4, v5 in ipairs(v6) do

                    if v5 == v4 then
                        local v6 = true
                    else
                    end
                end

                if v6 then

                    if not (config.Primary) then
                    end

                    textButton2.BackgroundColor3 = config.Surface

                    if v6 then

                        if not (0.1) then
                        end

                        textButton2.BackgroundTransparency = 0.3
                    else
                        local config = {v4}
                        v6 = config
                        imageButton:Destroy()
                        v7 = nil
                        v8 = false
                    end

                    func_cb554d64()

                    if v4 then

                        if not (v6) then
                        end

                        local v7, v8 = pcall(function()
                        end, v6[1])

                        if not (v7) then
                            warn("Dropdown callback error:", v8)
                        end

                        return

                    end
                end
            end
        end)
        func_2893d23c(textButton2, config.SurfaceHover, config.Surface)
    end

    return

end

local function func_98e1eb94(...)

    if not (v8) then

        return

    end

    v8 = false

    if v7 then
        v7.Parent:Destroy()
        v7 = nil
    end

    func_3e08ce32(textLabel3, config3.Fast, {
        Rotation = 0,
        TextColor3 = config.TextSecondary,
    }):Play()

    return

end

local function func_cb554d64(...)

    if 0 < #v6 then

        if v4 then

            if not (table.concat(v6, ", ")) then
            end

            textLabel2.Text = v6[1]
            textLabel2.TextColor3 = config.TextPrimary
        else
            textLabel2.Text = "None"
            textLabel2.TextColor3 = config.TextMuted
        end

        return

    end
end

local function func_6f3a48ae(...)

    if v8 then

        return

    end

    v8 = true
    func_66de505e()
    func_3e08ce32(textLabel3, config3.Fast, {
        Rotation = 180,
        TextColor3 = config.Primary,
    }):Play()

    return

end

local function func_2893d23c(p0, p1, p2)
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_3 (Fix manually)
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_7 (Fix manually)
    local _upv3 = config.SurfaceHover
    p0.MouseEnter:Connect(function()
        func_3e08ce32(p0, config3.Fast, {
            BackgroundColor3 = _upv3,
        }):Play()
    end)
    local _upv3 = p0.BackgroundColor3
    p0.MouseLeave:Connect(function()
        func_3e08ce32(p0, config3.Fast, {
            BackgroundColor3 = _upv3,
        }):Play()
    end)

    return

end

local function func_e4ab5107(p0, p1)
    p0.InputBegan:Connect(function(p0)
        if p0.UserInputType ~= Enum.UserInputType.MouseButton1 then

            if p0.UserInputType == Enum.UserInputType.Touch then
                func_c29bd3e3(p0, Vector2.new(p0.Position.X - p0.AbsolutePosition.X, p0.Position.Y - p0.AbsolutePosition.Y))

                if p1 then
                    local v, v2 = pcall(p1)

                    if not (v) then
                        warn("Click effect callback error:", v2)
                    end
                end
            end

            return

        end
    end)

    return

end

local function func_7364c343(...)
    v2 = false
    v3 = nil
    v4 = nil
    p0.isDragging = false
    p0.dragObject = nil

    return

end

local function func_f0a28b99(p0)
    v2 = true
    v3 = p0.Position
    v4 = p1.Position
    p0.isDragging = true
    p0.dragObject = p1

    return

end

local function func_dc4a0688(p0)

    if v2 and v3 then
        local v = p0.Position - v3
        p1.Position = UDim2.new(v4.X.Scale, v4.X.Offset + v.X, v4.Y.Scale, v4.Y.Offset + v.Y)
    end

    return

end

local function func_b40028aa(p0, p1)
    local uICorner = Instance.new("UICorner")
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_13 (Fix manually)
    uICorner.CornerRadius = UDim.new(0, config4:GetScaledValue(12))
    uICorner.Parent = p0

    return uICorner

end

local function func_52ef21c7()
    local v = uIListLayout.AbsoluteContentSize.Y + 50 * v
    config2.frame.Size = UDim2.new(1, 0, 0, 80 * v + v + 25 * v)
    frame3.Size = UDim2.new(1, -50 * v, 0, v)

    return

end

return config15
