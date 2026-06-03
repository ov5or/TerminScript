local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ThemePresets = {
    Emerald = {
        Primary = Color3.fromRGB(16, 185, 129),
        PrimaryHover = Color3.fromRGB(26, 195, 139),
        PrimaryGlow = Color3.fromRGB(52, 211, 153),
        Secondary = Color3.fromRGB(5, 150, 105),
        Accent = Color3.fromRGB(251, 191, 36),
        BorderGlow = Color3.fromRGB(16, 185, 129),
        Glow = Color3.fromRGB(16, 185, 129),
    },
    Neon = {
        Primary = Color3.fromRGB(139, 92, 246),
        PrimaryHover = Color3.fromRGB(155, 110, 255),
        PrimaryGlow = Color3.fromRGB(167, 139, 250),
        Secondary = Color3.fromRGB(109, 62, 216),
        Accent = Color3.fromRGB(236, 72, 153),
        BorderGlow = Color3.fromRGB(139, 92, 246),
        Glow = Color3.fromRGB(139, 92, 246),
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(234, 179, 8),
        PrimaryHover = Color3.fromRGB(250, 200, 20),
        PrimaryGlow = Color3.fromRGB(253, 224, 71),
        Secondary = Color3.fromRGB(190, 130, 0),
        Accent = Color3.fromRGB(239, 68, 68),
        BorderGlow = Color3.fromRGB(234, 179, 8),
        Glow = Color3.fromRGB(234, 179, 8),
    },
    Ocean = {
        Primary = Color3.fromRGB(6, 182, 212),
        PrimaryHover = Color3.fromRGB(22, 198, 228),
        PrimaryGlow = Color3.fromRGB(34, 211, 238),
        Secondary = Color3.fromRGB(2, 132, 199),
        Accent = Color3.fromRGB(99, 102, 241),
        BorderGlow = Color3.fromRGB(6, 182, 212),
        Glow = Color3.fromRGB(6, 182, 212),
    },
    Crimson = {
        Primary = Color3.fromRGB(239, 68, 68),
        PrimaryHover = Color3.fromRGB(255, 85, 85),
        PrimaryGlow = Color3.fromRGB(252, 129, 129),
        Secondary = Color3.fromRGB(185, 28, 28),
        Accent = Color3.fromRGB(251, 146, 60),
        BorderGlow = Color3.fromRGB(239, 68, 68),
        Glow = Color3.fromRGB(239, 68, 68),
    },
}

local Theme = {
    Primary = Color3.fromRGB(16, 185, 129),
    PrimaryHover = Color3.fromRGB(26, 195, 139),
    PrimaryGlow = Color3.fromRGB(52, 211, 153),
    Secondary = Color3.fromRGB(5, 150, 105),
    SecondaryHover = Color3.fromRGB(15, 160, 115),
    SecondaryGlow = Color3.fromRGB(25, 170, 125),
    Accent = Color3.fromRGB(251, 191, 36),
    AccentHover = Color3.fromRGB(255, 200, 56),
    AccentGlow = Color3.fromRGB(255, 215, 80),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(239, 68, 68),
    Info = Color3.fromRGB(96, 165, 250),
    Background = Color3.fromRGB(6, 10, 12),
    BackgroundBlur = Color3.fromRGB(8, 14, 18),
    Surface = Color3.fromRGB(12, 20, 28),
    SurfaceElevated = Color3.fromRGB(18, 28, 38),
    SurfaceHover = Color3.fromRGB(25, 40, 55),
    Card = Color3.fromRGB(18, 28, 38),
    CardElevated = Color3.fromRGB(24, 36, 50),
    CardHover = Color3.fromRGB(30, 46, 65),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 220, 210),
    TextMuted = Color3.fromRGB(150, 180, 165),
    TextDisabled = Color3.fromRGB(100, 130, 115),
    Border = Color3.fromRGB(30, 60, 50),
    BorderLight = Color3.fromRGB(50, 90, 75),
    BorderGlow = Color3.fromRGB(16, 185, 129),
    BorderHover = Color3.fromRGB(5, 150, 105),
    KeybindGrey = Color3.fromRGB(70, 80, 75),
    GlassMain = 0.08,
    GlassSecondary = 0.15,
    GlassLight = 0.25,
    GlowStrength = 0.2,
    Shadow = Color3.fromRGB(0, 0, 0),
    ShadowStrong = Color3.fromRGB(3, 8, 6),
    Glow = Color3.fromRGB(16, 185, 129),
}

local ThemeColorRegistry = {}
local ThemeGradientRegistry = {}

local function RegisterColor(Object, Property, ThemeKey)
    if not Object or not Property or not ThemeKey then return end
    table.insert(ThemeColorRegistry, {Object = Object, Property = Property, ThemeKey = ThemeKey})
end

local function RegisterGradient(Gradient, BuildFn)
    if not Gradient or not BuildFn then return end
    table.insert(ThemeGradientRegistry, {Gradient = Gradient, BuildFn = BuildFn})
end

local Animations = {
    Lightning = TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    UltraFast = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Fast = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.55, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Back = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    FadeIn = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    FadeOut = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    Sharp = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    Breathe = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    GlowPulse = TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    SlideIn = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Pop = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

local ScalingManager = {
    BaseResolution = Vector2.new(1920, 1080),
    CurrentScale = 1,
    MinScale = 0.4,
    MaxScale = 2.5,
    AdaptiveMode = true
}

function ScalingManager:CalculateScale()
    local Camera = workspace.CurrentCamera
    if not Camera then return 1 end
    local Viewport = Camera.ViewportSize
    local ScaleX = Viewport.X / self.BaseResolution.X
    local ScaleY = Viewport.Y / self.BaseResolution.Y
    local Scale = math.sqrt(ScaleX * ScaleY)
    if Viewport.X < 768 then Scale = Scale * 1.2
    elseif Viewport.X < 1366 then Scale = Scale * 1.1 end
    Scale = math.clamp(Scale, self.MinScale, self.MaxScale)
    self.CurrentScale = Scale
    return Scale
end

function ScalingManager:GetScaledValue(Value)
    return Value * self.CurrentScale
end

local TouchManager = {
    IsTouchDevice = UserInputService.TouchEnabled,
    IsDragging = false,
    DragObject = nil,
}

function TouchManager:EnableDrag(Frame, DragHandle)
    local Handle = DragHandle or Frame
    local Dragging = false
    local DragStartPos, StartPosition
    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStartPos = Input.Position
            StartPosition = Frame.Position
            self.IsDragging = true
        end
    end)
    local function UpdateDrag(Input)
        if Dragging and DragStartPos then
            local Delta = Input.Position - DragStartPos
            Frame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end
    Handle.InputChanged:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch then UpdateDrag(I) end end)
    UserInputService.InputChanged:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch then UpdateDrag(I) end end)
    local function EndDrag() Dragging = false DragStartPos = nil StartPosition = nil self.IsDragging = false end
    Handle.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then EndDrag() end end)
    UserInputService.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then EndDrag() end end)
end

local KeybindManager = {
    Bindings = {}, ToggleBindings = {}, ToggleStates = {},
    Listening = false, CurrentCallback = nil, ListeningFrame = nil,
    ListeningConnections = {}, ActiveListeners = {}
}

function KeybindManager:Bind(KeyCode, Callback)
    if self.Bindings[KeyCode] then self.Bindings[KeyCode]:Disconnect() end
    self.Bindings[KeyCode] = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.KeyCode == KeyCode then
            local Ok, Err = pcall(Callback)
            if not Ok then warn("Keybind error:", Err) end
        end
    end)
end

function KeybindManager:StartListening(Callback, Frame)
    if self.Listening then self:StopListening() end
    self.Listening = true
    self.CurrentCallback = Callback
    self.ListeningFrame = Frame
    if Frame then Frame.Text = "Press any key..." Frame.TextColor3 = Theme.Primary end
    self:ClearConnections()
    local KeyConn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.UserInputType == Enum.UserInputType.Keyboard then
            self:FinishListening(Input.KeyCode)
        end
    end)
    local MouseConn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed then
            local T = Input.UserInputType
            if T == Enum.UserInputType.MouseButton1 or T == Enum.UserInputType.MouseButton2 or T == Enum.UserInputType.MouseButton3 then
                self:FinishListening(T)
            end
        end
    end)
    table.insert(self.ListeningConnections, KeyConn)
    table.insert(self.ListeningConnections, MouseConn)
end

function KeybindManager:FinishListening(InputCode)
    self.Listening = false
    self:ClearConnections()
    if self.ListeningFrame then
        if InputCode then
            self.ListeningFrame.Text = tostring(InputCode):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
        else
            self.ListeningFrame.Text = "None"
        end
        self.ListeningFrame.TextColor3 = Theme.TextPrimary
    end
    if self.CurrentCallback and InputCode then
        local Ok, Err = pcall(self.CurrentCallback, InputCode)
        if not Ok then warn("Keybind listener error:", Err) end
    end
    self:Cleanup()
end

function KeybindManager:StopListening()
    self.Listening = false
    self:ClearConnections()
    if self.ListeningFrame then self.ListeningFrame.Text = "None" self.ListeningFrame.TextColor3 = Theme.TextMuted end
    self:Cleanup()
end

function KeybindManager:ClearConnections()
    for _, C in pairs(self.ListeningConnections) do if C and C.Connected then C:Disconnect() end end
    self.ListeningConnections = {}
end

function KeybindManager:Cleanup()
    self.CurrentCallback = nil
    self.ListeningFrame = nil
end

function KeybindManager:Unbind(KeyCode)
    if self.Bindings[KeyCode] then self.Bindings[KeyCode]:Disconnect() self.Bindings[KeyCode] = nil end
    if self.ToggleBindings[KeyCode] then self.ToggleBindings[KeyCode]:Disconnect() self.ToggleBindings[KeyCode] = nil end
end

function KeybindManager:UnbindAll()
    for _, C in pairs(self.Bindings) do C:Disconnect() end
    for _, C in pairs(self.ToggleBindings) do C:Disconnect() end
    self.Bindings = {} self.ToggleBindings = {} self.ToggleStates = {}
    self:StopListening()
end

local DropdownManager = { OpenDropdown = nil, AllDropdowns = {} }
function DropdownManager:Register(D) table.insert(self.AllDropdowns, D) end
function DropdownManager:CloseAll()
    for _, D in pairs(self.AllDropdowns) do if D and D.Close then D.Close() end end
    self.OpenDropdown = nil
end

local ActiveNotifications = {}

local function CreateTween(Object, Info, Props)
    return TweenService:Create(Object, Info, Props)
end

local function AddCorner(Frame, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius or ScalingManager:GetScaledValue(12))
    C.Parent = Frame
    return C
end

local function AddStroke(Frame, Thickness, Color, Transparency)
    local S = Instance.new("UIStroke")
    S.Thickness = Thickness or 1
    S.Color = Color or Theme.Border
    S.Transparency = Transparency or 0
    S.Parent = Frame
    return S
end

local function AddGradient(Frame, CS, Rotation, Transparency)
    local G = Instance.new("UIGradient")
    G.Color = CS
    G.Rotation = Rotation or 90
    if Transparency then G.Transparency = Transparency end
    G.Parent = Frame
    return G
end

local function CreateRipple(Frame, Position)
    local Ripple = Instance.new("Frame")
    Ripple.Name = "RippleEffect"
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0, Position.X, 0, Position.Y)
    Ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    Ripple.BackgroundTransparency = 0.78
    Ripple.BorderSizePixel = 0
    Ripple.ZIndex = Frame.ZIndex + 10
    Ripple.Parent = Frame
    AddCorner(Ripple, 1000)
    local MaxSize = math.max(Frame.AbsoluteSize.X, Frame.AbsoluteSize.Y) * 2.5
    local T = CreateTween(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, MaxSize, 0, MaxSize),
        Position = UDim2.new(0, Position.X - MaxSize / 2, 0, Position.Y - MaxSize / 2),
        BackgroundTransparency = 1
    })
    T:Play()
    T.Completed:Connect(function() Ripple:Destroy() end)
    return Ripple
end

local function AddHoverEffect(Frame, HoverColor, NormalColor)
    local NormalBg = NormalColor or Frame.BackgroundColor3
    local HoverBg = HoverColor or Theme.SurfaceHover
    Frame.MouseEnter:Connect(function() CreateTween(Frame, Animations.Fast, {BackgroundColor3 = HoverBg}):Play() end)
    Frame.MouseLeave:Connect(function() CreateTween(Frame, Animations.Fast, {BackgroundColor3 = NormalBg}):Play() end)
end

local function AddSubtleGlow(Stroke, BaseColor)
    local DimColor = BaseColor:lerp(Color3.fromRGB(30, 40, 35), 0.35)
    CreateTween(Stroke, Animations.GlowPulse, {Color = BaseColor, Transparency = 0.08}):Play()
    task.delay(Animations.GlowPulse.Time, function()
        if Stroke and Stroke.Parent then
            CreateTween(Stroke, Animations.GlowPulse, {Color = DimColor, Transparency = 0.45}):Play()
        end
    end)
end

local function StaggerIn(Elements, Delay)
    Delay = Delay or 0.055
    for I, El in ipairs(Elements) do
        if El and El.Parent then
            El.BackgroundTransparency = 1
        end
        task.delay(I * Delay, function()
            if El and El.Parent then
                CreateTween(El, Animations.Spring, {BackgroundTransparency = 0.25}):Play()
            end
        end)
    end
end

local function TypewriterEffect(Label, Text, Speed)
    Speed = Speed or 0.04
    Label.Text = ""
    for I = 1, #Text do
        task.delay(I * Speed, function()
            if Label and Label.Parent then
                Label.Text = string.sub(Text, 1, I)
            end
        end)
    end
end

local TerminScriptsLib = {}
TerminScriptsLib.__index = TerminScriptsLib

function TerminScriptsLib.new(Title, Config)
    local Self = setmetatable({}, TerminScriptsLib)
    Config = Config or {}
    Self.Title = Title or "Termin Scripts V3"
    Self.GlowEffects = Config.GlowEffects ~= false
    Self.Animations = Config.Animations ~= false
    Self.KeybindToggle = Config.KeybindToggle or Enum.KeyCode.RightControl
    Self.CurrentThemeName = "Emerald"
    ScalingManager:CalculateScale()
    Self.Tabs = {}
    Self.CurrentTab = nil
    Self.IsVisible = true
    Self.IsMinimized = false
    Self.IsMaximized = false
    Self.OriginalSize = nil
    Self.OriginalPosition = nil
    Self.StructuralRefs = {}
    Self:CreateMainGui()
    Self:SetupControls()
    Self:SetupDragging()
    Self:SetupKeybinds()
    Self:SetupScaling()
    Self:PlayEntranceAnimation()
    return Self
end

function TerminScriptsLib:PlayEntranceAnimation()
    local Frame = self.MainFrame
    local OrigSize = Frame.Size
    local OrigPos = Frame.Position
    Frame.Size = UDim2.new(0, OrigSize.X.Offset * 0.88, 0, OrigSize.Y.Offset * 0.88)
    Frame.Position = UDim2.new(OrigPos.X.Scale, OrigPos.X.Offset + OrigSize.X.Offset * 0.06, OrigPos.Y.Scale, OrigPos.Y.Offset + OrigSize.Y.Offset * 0.06)
    Frame.BackgroundTransparency = 1
    task.delay(0.06, function()
        CreateTween(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = OrigSize,
            Position = OrigPos,
            BackgroundTransparency = Theme.GlassMain
        }):Play()
    end)
end

function TerminScriptsLib:CreateMainGui()
    local Scale = ScalingManager.CurrentScale
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "TerminScriptsV3"
    self.ScreenGui.Parent = PlayerGui
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true

    local Width, Height = 950 * Scale, 750 * Scale
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainContainer"
    self.MainFrame.Size = UDim2.new(0, Width, 0, Height)
    self.MainFrame.Position = UDim2.new(0.5, -Width / 2, 0.5, -Height / 2)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BackgroundTransparency = Theme.GlassMain
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    self.OriginalSize = self.MainFrame.Size
    self.OriginalPosition = self.MainFrame.Position

    AddCorner(self.MainFrame, 24 * Scale)
    local MainStroke = AddStroke(self.MainFrame, 1.5 * Scale, Theme.BorderGlow, 0.3)
    self.StructuralRefs.MainStroke = MainStroke
    RegisterColor(MainStroke, "Color", "BorderGlow")

    local Bg = AddGradient(self.MainFrame, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Background),
        ColorSequenceKeypoint.new(0.6, Theme.Surface),
        ColorSequenceKeypoint.new(1, Theme.Background)
    }, 135)
    self.StructuralRefs.BgGradient = Bg
    RegisterGradient(Bg, function()
        return ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Background),
            ColorSequenceKeypoint.new(0.6, Theme.Surface),
            ColorSequenceKeypoint.new(1, Theme.Background)
        }
    end)

    self:CreateHeader()
    self:CreateContentArea()
end

function TerminScriptsLib:CreateHeader()
    local Scale = ScalingManager.CurrentScale
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 88 * Scale)
    self.Header.BackgroundColor3 = Theme.Surface
    self.Header.BackgroundTransparency = 0.05
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.MainFrame
    AddCorner(self.Header, 24 * Scale)

    local HeaderBottomLine = Instance.new("Frame")
    HeaderBottomLine.Size = UDim2.new(1, -40 * Scale, 0, 1 * Scale)
    HeaderBottomLine.Position = UDim2.new(0, 20 * Scale, 1, -1)
    HeaderBottomLine.BackgroundColor3 = Theme.Primary
    HeaderBottomLine.BackgroundTransparency = 0.55
    HeaderBottomLine.BorderSizePixel = 0
    HeaderBottomLine.Parent = self.Header
    RegisterColor(HeaderBottomLine, "BackgroundColor3", "Primary")

    local HeaderGrad = AddGradient(self.Header, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(0.45, Theme.Secondary),
        ColorSequenceKeypoint.new(1, Theme.Background)
    }, 90, NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.0),
        NumberSequenceKeypoint.new(0.7, 0.22),
        NumberSequenceKeypoint.new(1, 0.06)
    })
    self.StructuralRefs.HeaderGrad = HeaderGrad
    RegisterGradient(HeaderGrad, function()
        return ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(0.45, Theme.Secondary),
            ColorSequenceKeypoint.new(1, Theme.Background)
        }
    end)

    local AvatarContainer = Instance.new("Frame")
    AvatarContainer.Size = UDim2.new(0, 62 * Scale, 0, 62 * Scale)
    AvatarContainer.Position = UDim2.new(0, 20 * Scale, 0.5, -31 * Scale)
    AvatarContainer.BackgroundColor3 = Theme.Card
    AvatarContainer.BackgroundTransparency = 0.08
    AvatarContainer.BorderSizePixel = 0
    AvatarContainer.Parent = self.Header
    AddCorner(AvatarContainer, 16 * Scale)
    local AvStroke = AddStroke(AvatarContainer, 1.5 * Scale, Theme.Primary, 0.28)
    RegisterColor(AvStroke, "Color", "Primary")

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(1, -6 * Scale, 1, -6 * Scale)
    Avatar.Position = UDim2.new(0, 3 * Scale, 0, 3 * Scale)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png"
    Avatar.Parent = AvatarContainer
    AddCorner(Avatar, 14 * Scale)

    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(1, -300 * Scale, 1, 0)
    TitleContainer.Position = UDim2.new(0, 96 * Scale, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = self.Header
    TouchManager:EnableDrag(self.MainFrame, TitleContainer)

    local TitleLayout = Instance.new("UIListLayout")
    TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TitleLayout.Padding = UDim.new(0, 3 * Scale)
    TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TitleLayout.Parent = TitleContainer

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 30 * Scale)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Theme.TextPrimary
    self.TitleLabel.TextSize = 24 * Scale
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.LayoutOrder = 1
    self.TitleLabel.Parent = TitleContainer

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(1, 0, 0, 17 * Scale)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "v3.0.0  —  discord.gg/KkzMrTzSF4"
    VersionLabel.TextColor3 = Theme.TextSecondary
    VersionLabel.TextSize = 12 * Scale
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.LayoutOrder = 2
    VersionLabel.Parent = TitleContainer

    local StatusRow = Instance.new("Frame")
    StatusRow.Size = UDim2.new(1, 0, 0, 14 * Scale)
    StatusRow.BackgroundTransparency = 1
    StatusRow.LayoutOrder = 3
    StatusRow.Parent = TitleContainer

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 7 * Scale, 0, 7 * Scale)
    StatusDot.Position = UDim2.new(0, 0, 0.5, -3.5 * Scale)
    StatusDot.BackgroundColor3 = Theme.Success
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = StatusRow
    AddCorner(StatusDot, 4 * Scale)
    CreateTween(StatusDot, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.5}):Play()
    RegisterColor(StatusDot, "BackgroundColor3", "Primary")

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -12 * Scale, 1, 0)
    StatusText.Position = UDim2.new(0, 12 * Scale, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Online  —  " .. Player.Name
    StatusText.TextColor3 = Theme.TextMuted
    StatusText.TextSize = 11 * Scale
    StatusText.Font = Enum.Font.GothamMedium
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusRow

    self:CreateControlButtons()
end

function TerminScriptsLib:CreateControlButtons()
    local Scale = ScalingManager.CurrentScale
    local BtnSize = 28 * Scale
    local Gap = 8 * Scale
    self.CloseBtn = self:CreateControlButton("x", Theme.Error, UDim2.new(1, -(BtnSize + 18 * Scale), 0.5, -BtnSize / 2), BtnSize)
    self.MaximizeBtn = self:CreateControlButton("+", Theme.Info, UDim2.new(1, -(BtnSize * 2 + Gap + 18 * Scale), 0.5, -BtnSize / 2), BtnSize)
    self.MinimizeBtn = self:CreateControlButton("-", Theme.Warning, UDim2.new(1, -(BtnSize * 3 + Gap * 2 + 18 * Scale), 0.5, -BtnSize / 2), BtnSize)
end

function TerminScriptsLib:CreateControlButton(Text, Color, Position, Size)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, Size, 0, Size)
    Btn.Position = Position
    Btn.BackgroundColor3 = Color
    Btn.BackgroundTransparency = 0.3
    Btn.BorderSizePixel = 0
    Btn.Text = Text
    Btn.TextColor3 = Theme.TextPrimary
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = Size * 0.48
    Btn.ZIndex = 10
    Btn.Parent = self.Header
    AddCorner(Btn, Size * 0.5)
    AddStroke(Btn, 1, Color, 0.5)
    Btn.MouseEnter:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Color:lerp(Color3.new(1,1,1), 0.18),
            BackgroundTransparency = 0.05,
            Size = UDim2.new(0, Size * 1.1, 0, Size * 1.1)
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Color,
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, Size, 0, Size)
        }):Play()
    end)
    Btn.MouseButton1Down:Connect(function()
        CreateRipple(Btn, Vector2.new(Size / 2, Size / 2))
        CreateTween(Btn, Animations.Lightning, {Size = UDim2.new(0, Size * 0.9, 0, Size * 0.9)}):Play()
    end)
    Btn.MouseButton1Up:Connect(function()
        CreateTween(Btn, Animations.Spring, {Size = UDim2.new(0, Size, 0, Size)}):Play()
    end)
    return Btn
end

function TerminScriptsLib:CreateContentArea()
    local Scale = ScalingManager.CurrentScale
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -40 * Scale, 1, -130 * Scale)
    self.ContentArea.Position = UDim2.new(0, 20 * Scale, 0, 106 * Scale)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Parent = self.MainFrame
    self:CreateTabNavigation()
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Size = UDim2.new(1, 0, 1, -72 * Scale)
    self.PageContainer.Position = UDim2.new(0, 0, 0, 68 * Scale)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.ClipsDescendants = true
    self.PageContainer.Parent = self.ContentArea
end

function TerminScriptsLib:CreateTabNavigation()
    local Scale = ScalingManager.CurrentScale
    self.TabNav = Instance.new("Frame")
    self.TabNav.Size = UDim2.new(1, 0, 0, 60 * Scale)
    self.TabNav.BackgroundColor3 = Theme.Card
    self.TabNav.BackgroundTransparency = 0.28
    self.TabNav.BorderSizePixel = 0
    self.TabNav.Parent = self.ContentArea
    AddCorner(self.TabNav, 15 * Scale)
    local NavStroke = AddStroke(self.TabNav, 1 * Scale, Theme.Border, 0.5)
    RegisterColor(NavStroke, "Color", "Primary")

    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Size = UDim2.new(1, -16 * Scale, 1, -8 * Scale)
    self.TabContainer.Position = UDim2.new(0, 8 * Scale, 0, 4 * Scale)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.ScrollBarThickness = 0
    self.TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabContainer.Parent = self.TabNav
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8 * Scale)
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Parent = self.TabContainer
    TabLayout.Changed:Connect(function()
        self.TabContainer.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 20 * Scale, 0, 0)
    end)
end

function TerminScriptsLib:CreateTab(Name, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Tab = {
        Name = Name, Config = Config, Button = nil, Page = nil,
        Sections = {}, Active = false, LayoutOrder = #self.Tabs + 1, Gui = self
    }
    local TextSize = TextService:GetTextSize(Name, 14 * Scale, Enum.Font.GothamSemibold, Vector2.new(1000, 1000))
    local BtnWidth = TextSize.X + 32 * Scale
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Name .. "Tab"
    Tab.Button.Size = UDim2.new(0, BtnWidth, 0, 50 * Scale)
    Tab.Button.BackgroundColor3 = Theme.Surface
    Tab.Button.BackgroundTransparency = 0.5
    Tab.Button.BorderSizePixel = 0
    Tab.Button.Text = ""
    Tab.Button.LayoutOrder = Tab.LayoutOrder
    Tab.Button.Parent = self.TabContainer
    AddCorner(Tab.Button, 11 * Scale)
    local BtnStroke = AddStroke(Tab.Button, 1 * Scale, Theme.Border, 0.65)

    local TabText = Instance.new("TextLabel")
    TabText.Size = UDim2.new(1, -16 * Scale, 1, 0)
    TabText.Position = UDim2.new(0, 8 * Scale, 0, 0)
    TabText.BackgroundTransparency = 1
    TabText.Text = Name
    TabText.TextColor3 = Theme.TextMuted
    TabText.TextSize = 14 * Scale
    TabText.Font = Enum.Font.GothamSemibold
    TabText.TextXAlignment = Enum.TextXAlignment.Center
    TabText.Parent = Tab.Button

    local ActiveBar = Instance.new("Frame")
    ActiveBar.Size = UDim2.new(0, 0, 0, 2.5 * Scale)
    ActiveBar.Position = UDim2.new(0.5, 0, 1, -2.5 * Scale)
    ActiveBar.BackgroundColor3 = Theme.Primary
    ActiveBar.BorderSizePixel = 0
    ActiveBar.AnchorPoint = Vector2.new(0.5, 0)
    ActiveBar.Parent = Tab.Button
    AddCorner(ActiveBar, 2 * Scale)
    RegisterColor(ActiveBar, "BackgroundColor3", "Primary")

    Tab.Page = Instance.new("ScrollingFrame")
    Tab.Page.Name = Name .. "Page"
    Tab.Page.Size = UDim2.new(1, 0, 1, 0)
    Tab.Page.BackgroundTransparency = 1
    Tab.Page.BorderSizePixel = 0
    Tab.Page.ScrollBarThickness = 5 * Scale
    Tab.Page.ScrollBarImageColor3 = Theme.Primary
    Tab.Page.ScrollBarImageTransparency = 0.5
    Tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.Page.Visible = false
    Tab.Page.Parent = self.PageContainer
    RegisterColor(Tab.Page, "ScrollBarImageColor3", "Primary")
    local PL = Instance.new("UIListLayout")
    PL.SortOrder = Enum.SortOrder.LayoutOrder
    PL.Padding = UDim.new(0, 16 * Scale)
    PL.Parent = Tab.Page
    local PPad = Instance.new("UIPadding")
    PPad.PaddingTop = UDim.new(0, 10 * Scale)
    PPad.PaddingBottom = UDim.new(0, 16 * Scale)
    PPad.Parent = Tab.Page
    PL.Changed:Connect(function()
        Tab.Page.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 38 * Scale)
    end)

    Tab.Button.MouseEnter:Connect(function()
        if not Tab.Active then
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.SurfaceHover, BackgroundTransparency = 0.25}):Play()
            CreateTween(TabText, Animations.Fast, {TextColor3 = Theme.TextSecondary}):Play()
        end
    end)
    Tab.Button.MouseLeave:Connect(function()
        if not Tab.Active then
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.5}):Play()
            CreateTween(TabText, Animations.Fast, {TextColor3 = Theme.TextMuted}):Play()
        end
    end)
    Tab.Button.MouseButton1Click:Connect(function()
        CreateRipple(Tab.Button, Vector2.new(Tab.Button.AbsoluteSize.X / 2, Tab.Button.AbsoluteSize.Y / 2))
        self:SwitchTab(Tab)
    end)
    Tab._TabText = TabText
    Tab._BtnStroke = BtnStroke
    Tab._ActiveBar = ActiveBar

    local function MakeHelper(FnName)
        Tab[FnName] = function(TabSelf, Cfg)
            local Section = TabSelf.Sections[#TabSelf.Sections]
            if not Section then Section = TabSelf:CreateSection("Default") end
            return TabSelf.Gui[FnName](TabSelf.Gui, Section, Cfg)
        end
    end
    Tab.CreateSection = function(TabSelf, N, D, C) return TabSelf.Gui:CreateSection(TabSelf, N, D, C) end
    for _, N in ipairs({"TSButton","TSToggle","TSKeyBind","TSDropdown","TSColorPicker","TSSlider","TSTextBox","TSLabel","TSProgressBar","TSSeparator","TSMultiButton","TSBadgeRow"}) do
        MakeHelper(N)
    end

    table.insert(self.Tabs, Tab)
    if #self.Tabs == 1 then self:SwitchTab(Tab) end
    return Tab
end

function TerminScriptsLib:SwitchTab(TargetTab)
    local PrevTab = self.CurrentTab
    for _, Tab in pairs(self.Tabs) do
        if Tab == TargetTab then
            Tab.Active = true
            if PrevTab and PrevTab ~= Tab then
                Tab.Page.BackgroundTransparency = 1
                Tab.Page.Visible = true
                CreateTween(Tab.Page, Animations.FadeIn, {BackgroundTransparency = 1}):Play()
            else
                Tab.Page.Visible = true
            end
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.12}):Play()
            if Tab._BtnStroke then CreateTween(Tab._BtnStroke, Animations.Fast, {Color = Theme.PrimaryGlow, Transparency = 0.2}):Play() end
            if Tab._TabText then CreateTween(Tab._TabText, Animations.Fast, {TextColor3 = Theme.TextPrimary}):Play() end
            if Tab._ActiveBar then CreateTween(Tab._ActiveBar, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0.65, 0, 0, 2.5 * ScalingManager.CurrentScale)}):Play() end
        else
            Tab.Active = false
            Tab.Page.Visible = false
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.5}):Play()
            if Tab._BtnStroke then CreateTween(Tab._BtnStroke, Animations.Fast, {Color = Theme.Border, Transparency = 0.65}):Play() end
            if Tab._TabText then CreateTween(Tab._TabText, Animations.Fast, {TextColor3 = Theme.TextMuted}):Play() end
            if Tab._ActiveBar then CreateTween(Tab._ActiveBar, Animations.Fast, {Size = UDim2.new(0, 0, 0, 2.5 * ScalingManager.CurrentScale)}):Play() end
        end
    end
    self.CurrentTab = TargetTab
end

function TerminScriptsLib:CreateSection(Tab, Name, Description, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Section = {
        Name = Name, Description = Description, Config = Config, Frame = nil,
        Elements = {}, Expanded = true, LayoutOrder = #Tab.Sections + 1, Tab = Tab
    }
    Section.Frame = Instance.new("Frame")
    Section.Frame.Name = Name .. "Section"
    Section.Frame.Size = UDim2.new(1, 0, 0, 80 * Scale)
    Section.Frame.BackgroundColor3 = Theme.Card
    Section.Frame.BackgroundTransparency = 0.22
    Section.Frame.BorderSizePixel = 0
    Section.Frame.LayoutOrder = Section.LayoutOrder
    Section.Frame.Parent = Tab.Page
    AddCorner(Section.Frame, 16 * Scale)
    local SectionStroke = AddStroke(Section.Frame, 1 * Scale, Theme.BorderLight, 0.55)
    RegisterColor(SectionStroke, "Color", "Primary")

    local SectionGrad = AddGradient(Section.Frame, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Card),
        ColorSequenceKeypoint.new(1, Theme.Surface)
    }, 145)
    RegisterGradient(SectionGrad, function()
        return ColorSequence.new{ColorSequenceKeypoint.new(0, Theme.Card), ColorSequenceKeypoint.new(1, Theme.Surface)}
    end)

    local SectionHeader = Instance.new("Frame")
    SectionHeader.Name = "Header"
    SectionHeader.Size = UDim2.new(1, 0, 0, 68 * Scale)
    SectionHeader.BackgroundTransparency = 1
    SectionHeader.Parent = Section.Frame

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 2.5 * Scale, 0, 28 * Scale)
    AccentBar.Position = UDim2.new(0, 16 * Scale, 0.5, -14 * Scale)
    AccentBar.BackgroundColor3 = Theme.Primary
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = SectionHeader
    AddCorner(AccentBar, 2 * Scale)
    RegisterColor(AccentBar, "BackgroundColor3", "Primary")

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -90 * Scale, 0, 26 * Scale)
    SectionTitle.Position = UDim2.new(0, 26 * Scale, 0.5, -20 * Scale)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = Name
    SectionTitle.TextColor3 = Theme.TextPrimary
    SectionTitle.TextSize = 16 * Scale
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionHeader

    if Description then
        local SectionDesc = Instance.new("TextLabel")
        SectionDesc.Size = UDim2.new(1, -90 * Scale, 0, 16 * Scale)
        SectionDesc.Position = UDim2.new(0, 26 * Scale, 0.5, 8 * Scale)
        SectionDesc.BackgroundTransparency = 1
        SectionDesc.Text = Description
        SectionDesc.TextColor3 = Theme.TextMuted
        SectionDesc.TextSize = 11 * Scale
        SectionDesc.Font = Enum.Font.Gotham
        SectionDesc.TextXAlignment = Enum.TextXAlignment.Left
        SectionDesc.Parent = SectionHeader
    end

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0, 28 * Scale, 0, 28 * Scale)
    CollapseBtn.Position = UDim2.new(1, -42 * Scale, 0.5, -14 * Scale)
    CollapseBtn.BackgroundColor3 = Theme.Surface
    CollapseBtn.BackgroundTransparency = 0.3
    CollapseBtn.BorderSizePixel = 0
    CollapseBtn.Text = "v"
    CollapseBtn.TextColor3 = Theme.TextMuted
    CollapseBtn.TextSize = 12 * Scale
    CollapseBtn.Font = Enum.Font.GothamBold
    CollapseBtn.Parent = SectionHeader
    AddCorner(CollapseBtn, 8 * Scale)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -40 * Scale, 0, 0)
    ContentContainer.Position = UDim2.new(0, 20 * Scale, 0, 72 * Scale)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = Section.Frame
    Section.ContentContainer = ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10 * Scale)
    ContentLayout.Parent = ContentContainer

    local BottomPad = Instance.new("UIPadding")
    BottomPad.PaddingBottom = UDim.new(0, 14 * Scale)
    BottomPad.Parent = ContentContainer

    local function UpdateSectionSize()
        if not Section.Expanded then return end
        local CH = ContentLayout.AbsoluteContentSize.Y + 18 * Scale
        Section.Frame.Size = UDim2.new(1, 0, 0, 72 * Scale + CH)
        ContentContainer.Size = UDim2.new(1, -40 * Scale, 0, CH)
    end
    ContentLayout.Changed:Connect(UpdateSectionSize)
    task.delay(0.14, UpdateSectionSize)

    CollapseBtn.MouseButton1Click:Connect(function()
        Section.Expanded = not Section.Expanded
        if Section.Expanded then
            CollapseBtn.Text = "v"
            local CH = ContentLayout.AbsoluteContentSize.Y + 18 * Scale
            CreateTween(ContentContainer, Animations.Spring, {Size = UDim2.new(1, -40 * Scale, 0, CH)}):Play()
            CreateTween(Section.Frame, Animations.Spring, {Size = UDim2.new(1, 0, 0, 72 * Scale + CH)}):Play()
        else
            CollapseBtn.Text = ">"
            CreateTween(ContentContainer, Animations.Fast, {Size = UDim2.new(1, -40 * Scale, 0, 0)}):Play()
            CreateTween(Section.Frame, Animations.Fast, {Size = UDim2.new(1, 0, 0, 72 * Scale)}):Play()
        end
    end)

    local function MakeHelper(FnName)
        Section[FnName] = function(SecSelf, Cfg)
            return SecSelf.Tab.Gui[FnName](SecSelf.Tab.Gui, SecSelf, Cfg)
        end
    end
    for _, N in ipairs({"TSButton","TSToggle","TSKeyBind","TSDropdown","TSColorPicker","TSSlider","TSTextBox","TSLabel","TSProgressBar","TSSeparator","TSMultiButton","TSBadgeRow"}) do
        MakeHelper(N)
    end
    table.insert(Tab.Sections, Section)
    return Section
end

function TerminScriptsLib:TSButton(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Button"
    local Callback = Config.Callback or function() end
    local Color = Config.Color or Theme.Primary
    local Icon = Config.Icon
    local Style = Config.Style or "filled"

    local BtnFrame = Instance.new("Frame")
    BtnFrame.Name = "TSButton"
    BtnFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    BtnFrame.BackgroundTransparency = 1
    BtnFrame.LayoutOrder = #Section.Elements + 1
    BtnFrame.Parent = Section.ContentContainer

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = Style == "ghost" and Theme.Surface or Color
    Btn.BackgroundTransparency = Style == "ghost" and 0.5 or 0.1
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.Parent = BtnFrame
    AddCorner(Btn, 12 * Scale)
    local BtnStroke = AddStroke(Btn, Style == "ghost" and 1 * Scale or 1.5 * Scale, Style == "ghost" and Theme.BorderLight or Color, Style == "ghost" and 0.5 or 0.3)
    if Style == "filled" then
        AddGradient(Btn, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color:lerp(Color3.new(1,1,1), 0.06)),
            ColorSequenceKeypoint.new(1, Color:lerp(Color3.new(0,0,0), 0.08))
        }, 90)
    end

    local BtnContent = Instance.new("Frame")
    BtnContent.Size = UDim2.new(1, -32 * Scale, 1, 0)
    BtnContent.Position = UDim2.new(0, 16 * Scale, 0, 0)
    BtnContent.BackgroundTransparency = 1
    BtnContent.Parent = Btn
    local CL = Instance.new("UIListLayout")
    CL.FillDirection = Enum.FillDirection.Horizontal
    CL.Padding = UDim.new(0, 8 * Scale)
    CL.VerticalAlignment = Enum.VerticalAlignment.Center
    CL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CL.Parent = BtnContent

    if Icon then
        local IL = Instance.new("TextLabel")
        IL.Size = UDim2.new(0, 20 * Scale, 0, 20 * Scale)
        IL.BackgroundTransparency = 1
        IL.Text = Icon
        IL.TextColor3 = Theme.TextPrimary
        IL.TextSize = 16 * Scale
        IL.Font = Enum.Font.GothamBold
        IL.LayoutOrder = 1
        IL.Parent = BtnContent
    end

    local BtnText = Instance.new("TextLabel")
    BtnText.Size = UDim2.new(0, 200 * Scale, 0, 26 * Scale)
    BtnText.BackgroundTransparency = 1
    BtnText.Text = Text
    BtnText.TextColor3 = Theme.TextPrimary
    BtnText.TextSize = 14 * Scale
    BtnText.Font = Enum.Font.GothamSemibold
    BtnText.LayoutOrder = Icon and 2 or 1
    BtnText.Parent = BtnContent

    Btn.MouseEnter:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Style == "ghost" and Theme.SurfaceHover or Color:lerp(Color3.new(1,1,1), 0.1),
            BackgroundTransparency = Style == "ghost" and 0.25 or 0.02
        }):Play()
        CreateTween(BtnStroke, Animations.Fast, {Transparency = 0.1}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Style == "ghost" and Theme.Surface or Color,
            BackgroundTransparency = Style == "ghost" and 0.5 or 0.1
        }):Play()
        CreateTween(BtnStroke, Animations.Fast, {Transparency = Style == "ghost" and 0.5 or 0.3}):Play()
    end)
    Btn.MouseButton1Down:Connect(function()
        CreateTween(Btn, Animations.Lightning, {Size = UDim2.new(0.97, 0, 0.88, 0), Position = UDim2.new(0.015, 0, 0.06, 0)}):Play()
    end)
    Btn.MouseButton1Up:Connect(function()
        CreateTween(Btn, Animations.Spring, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        CreateRipple(Btn, Vector2.new(Btn.AbsoluteSize.X / 2, Btn.AbsoluteSize.Y / 2))
        local Ok, Err = pcall(Callback)
        if not Ok then warn("Button callback error:", Err) end
    end)

    table.insert(Section.Elements, BtnFrame)
    return {
        Element = BtnFrame,
        SetText = function(T) BtnText.Text = T end,
        SetColor = function(C) Color = C Btn.BackgroundColor3 = C end,
        SetCallback = function(C) Callback = C end,
        SetEnabled = function(E)
            Btn.Active = E
            CreateTween(Btn, Animations.Fast, {BackgroundTransparency = E and 0.1 or 0.65}):Play()
            CreateTween(BtnText, Animations.Fast, {TextTransparency = E and 0 or 0.55}):Play()
        end,
    }
end

function TerminScriptsLib:TSToggle(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Toggle"
    local Default = Config.Default or false
    local Callback = Config.Callback or function() end
    local Keybind = Config.Keybind
    local CurrentValue = Default
    local CurrentKeybind = Keybind

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "TSToggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    ToggleFrame.BackgroundColor3 = Theme.Surface
    ToggleFrame.BackgroundTransparency = 0.28
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.LayoutOrder = #Section.Elements + 1
    ToggleFrame.Parent = Section.ContentContainer
    AddCorner(ToggleFrame, 12 * Scale)
    AddStroke(ToggleFrame, 1 * Scale, Theme.Border, 0.55)

    local HasKeybind = Keybind ~= nil
    local RightOffset = HasKeybind and -178 * Scale or -100 * Scale
    local TextPad = HasKeybind and -200 * Scale or -122 * Scale

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(1, TextPad, 1, 0)
    ToggleText.Position = UDim2.new(0, 16 * Scale, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = Text
    ToggleText.TextColor3 = Theme.TextPrimary
    ToggleText.TextSize = 14 * Scale
    ToggleText.Font = Enum.Font.GothamSemibold
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame

    local KeybindBtn, KeybindText
    if HasKeybind then
        KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Size = UDim2.new(0, 56 * Scale, 0, 30 * Scale)
        KeybindBtn.Position = UDim2.new(1, -178 * Scale, 0.5, -15 * Scale)
        KeybindBtn.BackgroundColor3 = Theme.KeybindGrey
        KeybindBtn.BackgroundTransparency = 0.2
        KeybindBtn.BorderSizePixel = 0
        KeybindBtn.Text = ""
        KeybindBtn.Parent = ToggleFrame
        AddCorner(KeybindBtn, 9 * Scale)
        AddStroke(KeybindBtn, 1.5 * Scale, Theme.Primary, 0.4)
        KeybindText = Instance.new("TextLabel")
        KeybindText.Size = UDim2.new(1, 0, 1, 0)
        KeybindText.BackgroundTransparency = 1
        KeybindText.Text = CurrentKeybind and CurrentKeybind.Name or "None"
        KeybindText.TextColor3 = Color3.fromRGB(255,255,255)
        KeybindText.TextSize = 10 * Scale
        KeybindText.Font = Enum.Font.GothamBold
        KeybindText.TextScaled = true
        KeybindText.Parent = KeybindBtn
    end

    local SwitchW = 68 * Scale
    local SwitchH = 34 * Scale
    local KnobSize = 26 * Scale

    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Size = UDim2.new(0, SwitchW, 0, SwitchH)
    ToggleSwitch.BackgroundColor3 = CurrentValue and Theme.Primary or Theme.Card
    ToggleSwitch.BorderSizePixel = 0
    ToggleSwitch.Parent = ToggleFrame
    AddCorner(ToggleSwitch, SwitchH / 2)
    local SwitchStroke = AddStroke(ToggleSwitch, 1.5 * Scale, CurrentValue and Theme.PrimaryGlow or Theme.BorderLight, 0.35)

    if HasKeybind then
        ToggleSwitch.Position = UDim2.new(1, RightOffset + 84, 0.5, -SwitchH / 2)
    else
        ToggleSwitch.Position = UDim2.new(1, -SwitchW - 14 * Scale, 0.5, -SwitchH / 2)
    end

    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Size = UDim2.new(0, KnobSize, 0, KnobSize)
    ToggleKnob.Position = UDim2.new(0, CurrentValue and (SwitchW - KnobSize - 4 * Scale) or 4 * Scale, 0.5, -KnobSize / 2)
    ToggleKnob.BackgroundColor3 = Theme.TextPrimary
    ToggleKnob.BorderSizePixel = 0
    ToggleKnob.Parent = ToggleSwitch
    AddCorner(ToggleKnob, KnobSize / 2)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleSwitch

    local function UpdateToggle()
        local KP = CurrentValue and (SwitchW - KnobSize - 4 * Scale) or 4 * Scale
        CreateTween(ToggleSwitch, Animations.Fast, {BackgroundColor3 = CurrentValue and Theme.Primary or Theme.Card}):Play()
        CreateTween(SwitchStroke, Animations.Fast, {Color = CurrentValue and Theme.PrimaryGlow or Theme.BorderLight}):Play()
        CreateTween(ToggleKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, KP, 0.5, -KnobSize / 2)
        }):Play()
        local Ok, Err = pcall(Callback, CurrentValue)
        if not Ok then warn("Toggle callback error:", Err) end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        CurrentValue = not CurrentValue
        UpdateToggle()
        CreateRipple(ToggleSwitch, Vector2.new(SwitchW / 2, SwitchH / 2))
    end)
    ToggleBtn.MouseEnter:Connect(function()
        local HoverKP = CurrentValue and (SwitchW - KnobSize - 3 * Scale) or 3 * Scale
        CreateTween(ToggleKnob, Animations.Fast, {
            Size = UDim2.new(0, KnobSize + 2 * Scale, 0, KnobSize + 2 * Scale),
            Position = UDim2.new(0, HoverKP - 1 * Scale, 0.5, -(KnobSize / 2) - 1 * Scale)
        }):Play()
    end)
    ToggleBtn.MouseLeave:Connect(function()
        local KP = CurrentValue and (SwitchW - KnobSize - 4 * Scale) or 4 * Scale
        CreateTween(ToggleKnob, Animations.Fast, {
            Size = UDim2.new(0, KnobSize, 0, KnobSize),
            Position = UDim2.new(0, KP, 0.5, -KnobSize / 2)
        }):Play()
    end)
    AddHoverEffect(ToggleFrame, Theme.SurfaceHover, Theme.Surface)

    if HasKeybind then
        if CurrentKeybind then
            KeybindManager:Bind(CurrentKeybind, function() CurrentValue = not CurrentValue UpdateToggle() end)
        end
        KeybindBtn.MouseButton1Click:Connect(function()
            KeybindText.Text = "..." KeybindBtn.BackgroundColor3 = Theme.Primary
            local Conn
            Conn = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if CurrentKeybind then KeybindManager:Unbind(CurrentKeybind) end
                    CurrentKeybind = Input.KeyCode
                    KeybindText.Text = Input.KeyCode.Name
                    KeybindManager:Bind(CurrentKeybind, function() CurrentValue = not CurrentValue UpdateToggle() end)
                    KeybindBtn.BackgroundColor3 = Theme.KeybindGrey
                    Conn:Disconnect()
                end
            end)
        end)
    end

    table.insert(Section.Elements, ToggleFrame)
    return {
        Element = ToggleFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = V UpdateToggle() end,
        Toggle = function() CurrentValue = not CurrentValue UpdateToggle() end,
        SetCallback = function(C) Callback = C end,
    }
end

function TerminScriptsLib:TSKeyBind(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "KeyBind"
    local Default = Config.Default
    local Callback = Config.Callback or function() end
    local CurrentKeybind = Default

    local KBFrame = Instance.new("Frame")
    KBFrame.Name = "TSKeyBind"
    KBFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    KBFrame.BackgroundColor3 = Theme.Surface
    KBFrame.BackgroundTransparency = 0.28
    KBFrame.BorderSizePixel = 0
    KBFrame.LayoutOrder = #Section.Elements + 1
    KBFrame.Parent = Section.ContentContainer
    AddCorner(KBFrame, 12 * Scale)
    AddStroke(KBFrame, 1 * Scale, Theme.Border, 0.55)

    local KBLabel = Instance.new("TextLabel")
    KBLabel.Size = UDim2.new(1, -150 * Scale, 1, 0)
    KBLabel.Position = UDim2.new(0, 16 * Scale, 0, 0)
    KBLabel.BackgroundTransparency = 1
    KBLabel.Text = Text
    KBLabel.TextColor3 = Theme.TextPrimary
    KBLabel.TextSize = 14 * Scale
    KBLabel.Font = Enum.Font.GothamSemibold
    KBLabel.TextXAlignment = Enum.TextXAlignment.Left
    KBLabel.Parent = KBFrame

    local KBBtn = Instance.new("TextButton")
    KBBtn.Size = UDim2.new(0, 88 * Scale, 0, 34 * Scale)
    KBBtn.Position = UDim2.new(1, -102 * Scale, 0.5, -17 * Scale)
    KBBtn.BackgroundColor3 = Theme.KeybindGrey
    KBBtn.BackgroundTransparency = 0.2
    KBBtn.BorderSizePixel = 0
    KBBtn.Text = ""
    KBBtn.Parent = KBFrame
    AddCorner(KBBtn, 9 * Scale)
    local KBStroke = AddStroke(KBBtn, 1.5 * Scale, Theme.Primary, 0.4)

    local KBBtnText = Instance.new("TextLabel")
    KBBtnText.Size = UDim2.new(1, 0, 1, 0)
    KBBtnText.BackgroundTransparency = 1
    KBBtnText.Text = CurrentKeybind and tostring(CurrentKeybind):gsub("Enum.KeyCode.",""):gsub("Enum.UserInputType.","") or "None"
    KBBtnText.TextColor3 = Color3.fromRGB(255,255,255)
    KBBtnText.TextSize = 10 * Scale
    KBBtnText.Font = Enum.Font.GothamBold
    KBBtnText.TextScaled = true
    KBBtnText.Parent = KBBtn

    local Listening = false
    local ListenConn = nil
    local function UpdateDisplay()
        if Listening then
            KBBtnText.Text = "..."
            CreateTween(KBBtn, Animations.Fast, {BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.08}):Play()
            CreateTween(KBStroke, Animations.Fast, {Color = Theme.PrimaryGlow, Transparency = 0.1}):Play()
        else
            KBBtnText.Text = CurrentKeybind and tostring(CurrentKeybind):gsub("Enum.KeyCode.",""):gsub("Enum.UserInputType.","") or "None"
            CreateTween(KBBtn, Animations.Fast, {BackgroundColor3 = Theme.KeybindGrey, BackgroundTransparency = 0.2}):Play()
            CreateTween(KBStroke, Animations.Fast, {Color = Theme.Primary, Transparency = 0.4}):Play()
        end
    end

    KBBtn.MouseButton1Click:Connect(function()
        if Listening then return end
        Listening = true
        UpdateDisplay()
        CreateRipple(KBBtn, Vector2.new(KBBtn.AbsoluteSize.X / 2, KBBtn.AbsoluteSize.Y / 2))
        if ListenConn then ListenConn:Disconnect() end
        ListenConn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
            if GameProcessed then return end
            if Input.UserInputType == Enum.UserInputType.Keyboard then
                if CurrentKeybind then KeybindManager:Unbind(CurrentKeybind) end
                CurrentKeybind = Input.KeyCode
                if CurrentKeybind then
                    KeybindManager:Bind(CurrentKeybind, function()
                        local Ok, Err = pcall(Callback, CurrentKeybind)
                        if not Ok then warn("KeyBind press error:", Err) end
                    end)
                    local Ok, Err = pcall(Callback, CurrentKeybind)
                    if not Ok then warn("KeyBind change error:", Err) end
                end
                Listening = false
                UpdateDisplay()
                ListenConn:Disconnect()
                ListenConn = nil
            end
        end)
    end)
    KBBtn.MouseEnter:Connect(function() if not Listening then CreateTween(KBBtn, Animations.Fast, {BackgroundColor3 = Theme.SurfaceHover}):Play() end end)
    KBBtn.MouseLeave:Connect(function() if not Listening then CreateTween(KBBtn, Animations.Fast, {BackgroundColor3 = Theme.KeybindGrey}):Play() end end)

    if CurrentKeybind then
        KeybindManager:Bind(CurrentKeybind, function()
            local Ok, Err = pcall(Callback, CurrentKeybind)
            if not Ok then warn("KeyBind press error:", Err) end
        end)
    end
    AddHoverEffect(KBFrame, Theme.SurfaceHover, Theme.Surface)
    table.insert(Section.Elements, KBFrame)
    return {
        Element = KBFrame,
        GetKeybind = function() return CurrentKeybind end,
        SetKeybind = function(KC)
            if CurrentKeybind then KeybindManager:Unbind(CurrentKeybind) end
            CurrentKeybind = KC
            if CurrentKeybind then
                KeybindManager:Bind(CurrentKeybind, function()
                    local Ok, Err = pcall(Callback, CurrentKeybind)
                    if not Ok then warn("KeyBind press error:", Err) end
                end)
            end
            UpdateDisplay()
        end,
        SetCallback = function(C) Callback = C
            if CurrentKeybind then
                KeybindManager:Unbind(CurrentKeybind)
                KeybindManager:Bind(CurrentKeybind, function()
                    local Ok, Err = pcall(Callback, CurrentKeybind)
                    if not Ok then warn("KeyBind press error:", Err) end
                end)
            end
        end,
    }
end

function TerminScriptsLib:TSDropdown(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Dropdown"
    local Options = Config.Options or {"Option 1","Option 2","Option 3"}
    local Callback = Config.Callback or function() end
    local MultiSelect = Config.MultiSelect or false
    local Default = Config.Default
    local SelectedOptions = {}
    if Default then SelectedOptions = MultiSelect and (type(Default) == "table" and Default or {Default}) or {Default} end

    local DDFrame = Instance.new("Frame")
    DDFrame.Name = "TSDropdown"
    DDFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    DDFrame.BackgroundTransparency = 1
    DDFrame.LayoutOrder = #Section.Elements + 1
    DDFrame.Parent = Section.ContentContainer

    local DDBtn = Instance.new("TextButton")
    DDBtn.Size = UDim2.new(1, 0, 0, 52 * Scale)
    DDBtn.BackgroundColor3 = Theme.Surface
    DDBtn.BackgroundTransparency = 0.28
    DDBtn.BorderSizePixel = 0
    DDBtn.Text = ""
    DDBtn.Active = true
    DDBtn.Parent = DDFrame
    AddCorner(DDBtn, 12 * Scale)
    AddStroke(DDBtn, 1 * Scale, Theme.Border, 0.55)

    local DDContent = Instance.new("Frame")
    DDContent.Size = UDim2.new(1, -32 * Scale, 1, 0)
    DDContent.Position = UDim2.new(0, 16 * Scale, 0, 0)
    DDContent.BackgroundTransparency = 1
    DDContent.Parent = DDBtn
    local DCL = Instance.new("UIListLayout")
    DCL.FillDirection = Enum.FillDirection.Horizontal
    DCL.VerticalAlignment = Enum.VerticalAlignment.Center
    DCL.Parent = DDContent

    local DDText = Instance.new("TextLabel")
    DDText.Size = UDim2.new(1, -130 * Scale, 1, 0)
    DDText.BackgroundTransparency = 1
    DDText.Text = Text
    DDText.TextColor3 = Theme.TextPrimary
    DDText.TextSize = 14 * Scale
    DDText.Font = Enum.Font.GothamSemibold
    DDText.TextXAlignment = Enum.TextXAlignment.Left
    DDText.LayoutOrder = 1
    DDText.Parent = DDContent

    local ValDisplay = Instance.new("TextLabel")
    ValDisplay.Size = UDim2.new(0, 100 * Scale, 1, 0)
    ValDisplay.BackgroundTransparency = 1
    ValDisplay.Text = #SelectedOptions > 0 and (MultiSelect and table.concat(SelectedOptions, ", ") or SelectedOptions[1]) or "None"
    ValDisplay.TextColor3 = Theme.TextSecondary
    ValDisplay.TextSize = 13 * Scale
    ValDisplay.Font = Enum.Font.Gotham
    ValDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValDisplay.LayoutOrder = 2
    ValDisplay.Parent = DDContent

    local DDArrow = Instance.new("TextLabel")
    DDArrow.Size = UDim2.new(0, 18 * Scale, 1, 0)
    DDArrow.BackgroundTransparency = 1
    DDArrow.Text = "v"
    DDArrow.TextColor3 = Theme.TextMuted
    DDArrow.TextSize = 12 * Scale
    DDArrow.Font = Enum.Font.GothamBold
    DDArrow.LayoutOrder = 3
    DDArrow.Parent = DDContent

    local DropdownList = nil
    local DropdownOpen = false

    local function UpdateDisplay()
        if #SelectedOptions > 0 then
            ValDisplay.Text = MultiSelect and table.concat(SelectedOptions, ", ") or SelectedOptions[1]
            ValDisplay.TextColor3 = Theme.Primary
        else
            ValDisplay.Text = "None"
            ValDisplay.TextColor3 = Theme.TextMuted
        end
    end

    local function CreateOptions()
        if DropdownList then return end
        local Blocker = Instance.new("ImageButton")
        Blocker.Size = UDim2.new(1, 0, 1, 0)
        Blocker.BackgroundColor3 = Color3.new(0,0,0)
        Blocker.BackgroundTransparency = 0.65
        Blocker.BorderSizePixel = 0
        Blocker.ZIndex = 999
        Blocker.AutoButtonColor = false
        Blocker.Parent = self.ScreenGui

        DropdownList = Instance.new("Frame")
        DropdownList.Size = UDim2.new(0, 0, 0, 0)
        DropdownList.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropdownList.AnchorPoint = Vector2.new(0.5, 0.5)
        DropdownList.BackgroundColor3 = Theme.Card
        DropdownList.BackgroundTransparency = 0.03
        DropdownList.BorderSizePixel = 0
        DropdownList.ZIndex = 1000
        DropdownList.Parent = Blocker
        AddCorner(DropdownList, 16 * Scale)
        AddStroke(DropdownList, 1.5 * Scale, Theme.Primary, 0.3)

        local TargetW = 290 * Scale
        local TargetH = math.min(#Options * 46 * Scale + 72 * Scale, 380 * Scale)
        CreateTween(DropdownList, Animations.Pop, {
            Size = UDim2.new(0, TargetW, 0, TargetH),
            Position = UDim2.new(0.5, -TargetW / 2, 0.5, -TargetH / 2),
        }):Play()

        local TitleL = Instance.new("TextLabel")
        TitleL.Size = UDim2.new(1, -50 * Scale, 0, 35 * Scale)
        TitleL.Position = UDim2.new(0, 16 * Scale, 0, 8 * Scale)
        TitleL.BackgroundTransparency = 1
        TitleL.Text = Text
        TitleL.TextColor3 = Theme.TextPrimary
        TitleL.TextSize = 15 * Scale
        TitleL.Font = Enum.Font.GothamBold
        TitleL.TextXAlignment = Enum.TextXAlignment.Left
        TitleL.ZIndex = 1001
        TitleL.Parent = DropdownList

        local CloseB = Instance.new("TextButton")
        CloseB.Size = UDim2.new(0, 26 * Scale, 0, 26 * Scale)
        CloseB.Position = UDim2.new(1, -36 * Scale, 0, 12 * Scale)
        CloseB.BackgroundColor3 = Theme.Error
        CloseB.BackgroundTransparency = 0.3
        CloseB.BorderSizePixel = 0
        CloseB.Text = "x"
        CloseB.TextColor3 = Theme.TextPrimary
        CloseB.TextSize = 13 * Scale
        CloseB.Font = Enum.Font.GothamBold
        CloseB.ZIndex = 1001
        CloseB.Parent = DropdownList
        AddCorner(CloseB, 13 * Scale)
        local function CloseModal() if Blocker and Blocker.Parent then Blocker:Destroy() end DropdownList = nil DropdownOpen = false end
        CloseB.MouseButton1Click:Connect(CloseModal)
        Blocker.MouseButton1Click:Connect(CloseModal)

        local ListScroll = Instance.new("ScrollingFrame")
        ListScroll.Size = UDim2.new(1, -14 * Scale, 1, -54 * Scale)
        ListScroll.Position = UDim2.new(0, 7 * Scale, 0, 50 * Scale)
        ListScroll.BackgroundTransparency = 1
        ListScroll.BorderSizePixel = 0
        ListScroll.ScrollBarThickness = 4 * Scale
        ListScroll.ScrollBarImageColor3 = Theme.Primary
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, #Options * 48 * Scale)
        ListScroll.ZIndex = 1001
        ListScroll.Parent = DropdownList

        local LL = Instance.new("UIListLayout")
        LL.SortOrder = Enum.SortOrder.LayoutOrder
        LL.Padding = UDim.new(0, 4 * Scale)
        LL.Parent = ListScroll

        for I, Opt in ipairs(Options) do
            local OBtn = Instance.new("TextButton")
            OBtn.Size = UDim2.new(1, -4 * Scale, 0, 40 * Scale)
            OBtn.BackgroundColor3 = Theme.Surface
            OBtn.BackgroundTransparency = 0.35
            OBtn.BorderSizePixel = 0
            OBtn.Text = Opt
            OBtn.TextColor3 = Theme.TextPrimary
            OBtn.TextSize = 13 * Scale
            OBtn.Font = Enum.Font.GothamMedium
            OBtn.ZIndex = 1002
            OBtn.LayoutOrder = I
            OBtn.Parent = ListScroll
            AddCorner(OBtn, 9 * Scale)
            local IsSel = false
            for _, S in ipairs(SelectedOptions) do if S == Opt then IsSel = true break end end
            if IsSel then
                OBtn.BackgroundColor3 = Theme.Primary
                OBtn.BackgroundTransparency = 0.12
            end

            OBtn.MouseEnter:Connect(function()
                local IsSelNow = false
                for _, S in ipairs(SelectedOptions) do if S == Opt then IsSelNow = true break end end
                if not IsSelNow then CreateTween(OBtn, Animations.Fast, {BackgroundColor3 = Theme.SurfaceHover, BackgroundTransparency = 0.18}):Play() end
            end)
            OBtn.MouseLeave:Connect(function()
                local IsSelNow = false
                for _, S in ipairs(SelectedOptions) do if S == Opt then IsSelNow = true break end end
                if not IsSelNow then CreateTween(OBtn, Animations.Fast, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.35}):Play() end
            end)
            OBtn.MouseButton1Click:Connect(function()
                CreateRipple(OBtn, Vector2.new(OBtn.AbsoluteSize.X / 2, OBtn.AbsoluteSize.Y / 2))
                if MultiSelect then
                    local Found = false
                    for J, S in ipairs(SelectedOptions) do if S == Opt then table.remove(SelectedOptions, J) Found = true break end end
                    if not Found then table.insert(SelectedOptions, Opt) end
                    local IsNow = false
                    for _, S in ipairs(SelectedOptions) do if S == Opt then IsNow = true break end end
                    CreateTween(OBtn, Animations.Fast, {BackgroundColor3 = IsNow and Theme.Primary or Theme.Surface, BackgroundTransparency = IsNow and 0.12 or 0.35}):Play()
                else
                    SelectedOptions = {Opt}
                    CloseModal()
                end
                UpdateDisplay()
                local Ok, Err = pcall(Callback, MultiSelect and SelectedOptions or SelectedOptions[1])
                if not Ok then warn("Dropdown callback error:", Err) end
            end)
        end
    end

    local function OpenDD()
        if DropdownOpen then return end
        DropdownOpen = true
        CreateOptions()
        CreateTween(DDArrow, Animations.Fast, {Rotation = 180, TextColor3 = Theme.Primary}):Play()
    end
    local function CloseDD()
        if not DropdownOpen then return end
        DropdownOpen = false
        if DropdownList and DropdownList.Parent then DropdownList.Parent:Destroy() end
        DropdownList = nil
        CreateTween(DDArrow, Animations.Fast, {Rotation = 0, TextColor3 = Theme.TextMuted}):Play()
    end

    DDBtn.MouseButton1Click:Connect(function()
        CreateRipple(DDBtn, Vector2.new(DDBtn.AbsoluteSize.X / 2, DDBtn.AbsoluteSize.Y / 2))
        if DropdownOpen then CloseDD() else OpenDD() end
    end)
    AddHoverEffect(DDBtn, Theme.SurfaceHover, Theme.Surface)
    DropdownManager:Register({Close = CloseDD})
    table.insert(Section.Elements, DDFrame)
    return {
        Element = DDFrame,
        GetSelected = function() return MultiSelect and SelectedOptions or SelectedOptions[1] end,
        SetSelected = function(V) SelectedOptions = MultiSelect and (type(V) == "table" and V or {V}) or {V} UpdateDisplay() end,
        AddOption = function(O) table.insert(Options, O) end,
        SetOptions = function(Opts) Options = Opts SelectedOptions = {} UpdateDisplay() end,
        Close = CloseDD,
    }
end

function TerminScriptsLib:TSColorPicker(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Color Picker"
    local Default = Config.Default or Color3.fromRGB(255, 255, 255)
    local Callback = Config.Callback or function() end
    local CurrentColor = Default
    local CurrentHue, CurrentSat, CurrentVal = 0, 1, 1

    local function RgbToHsv(R, G, B)
        local Max = math.max(R, G, B) local Min = math.min(R, G, B) local D = Max - Min
        local H = 0
        if D > 0 then
            if Max == R then H = ((G - B) / D) % 6
            elseif Max == G then H = (B - R) / D + 2
            elseif Max == B then H = (R - G) / D + 4 end
            H = H / 6
        end
        return H, Max == 0 and 0 or D / Max, Max
    end

    local function HsvToRgb(H, S, V)
        local C = V * S local X = C * (1 - math.abs((H * 6) % 2 - 1)) local M = V - C
        local R, G, B = 0, 0, 0
        if H < 1/6 then R,G,B = C,X,0
        elseif H < 2/6 then R,G,B = X,C,0
        elseif H < 3/6 then R,G,B = 0,C,X
        elseif H < 4/6 then R,G,B = 0,X,C
        elseif H < 5/6 then R,G,B = X,0,C
        else R,G,B = C,0,X end
        return Color3.new(R+M, G+M, B+M)
    end

    CurrentHue, CurrentSat, CurrentVal = RgbToHsv(CurrentColor.R, CurrentColor.G, CurrentColor.B)

    local CFrame = Instance.new("Frame")
    CFrame.Name = "TSColorPicker"
    CFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    CFrame.BackgroundColor3 = Theme.Surface
    CFrame.BackgroundTransparency = 0.28
    CFrame.BorderSizePixel = 0
    CFrame.LayoutOrder = #Section.Elements + 1
    CFrame.Parent = Section.ContentContainer
    AddCorner(CFrame, 12 * Scale)
    AddStroke(CFrame, 1 * Scale, Theme.Border, 0.55)

    local CText = Instance.new("TextLabel")
    CText.Size = UDim2.new(1, -185 * Scale, 1, 0)
    CText.Position = UDim2.new(0, 16 * Scale, 0, 0)
    CText.BackgroundTransparency = 1
    CText.Text = Text
    CText.TextColor3 = Theme.TextPrimary
    CText.TextSize = 14 * Scale
    CText.Font = Enum.Font.GothamSemibold
    CText.TextXAlignment = Enum.TextXAlignment.Left
    CText.Parent = CFrame

    local CVLabel = Instance.new("TextLabel")
    CVLabel.Size = UDim2.new(0, 80 * Scale, 1, 0)
    CVLabel.Position = UDim2.new(1, -148 * Scale, 0, 0)
    CVLabel.BackgroundTransparency = 1
    CVLabel.Text = string.format("%d, %d, %d", math.floor(CurrentColor.R*255), math.floor(CurrentColor.G*255), math.floor(CurrentColor.B*255))
    CVLabel.TextColor3 = Theme.TextMuted
    CVLabel.TextSize = 11 * Scale
    CVLabel.Font = Enum.Font.Gotham
    CVLabel.TextXAlignment = Enum.TextXAlignment.Right
    CVLabel.Parent = CFrame

    local CBtn = Instance.new("TextButton")
    CBtn.Size = UDim2.new(0, 52 * Scale, 0, 34 * Scale)
    CBtn.Position = UDim2.new(1, -66 * Scale, 0.5, -17 * Scale)
    CBtn.BackgroundColor3 = CurrentColor
    CBtn.BorderSizePixel = 0
    CBtn.Text = ""
    CBtn.Parent = CFrame
    AddCorner(CBtn, 10 * Scale)
    AddStroke(CBtn, 1.5 * Scale, Theme.Primary, 0.4)

    local CPFrame = nil
    local PickerOpen = false

    local function UpdateColor()
        CurrentColor = HsvToRgb(CurrentHue, CurrentSat, CurrentVal)
        CBtn.BackgroundColor3 = CurrentColor
        CVLabel.Text = string.format("%d, %d, %d", math.floor(CurrentColor.R*255), math.floor(CurrentColor.G*255), math.floor(CurrentColor.B*255))
        local Ok, Err = pcall(Callback, CurrentColor)
        if not Ok then warn("Color picker error:", Err) end
    end

    local function CreatePicker()
        if CPFrame then return end
        local Blocker = Instance.new("Frame")
        Blocker.Size = UDim2.new(1,0,1,0)
        Blocker.BackgroundColor3 = Color3.new(0,0,0)
        Blocker.BackgroundTransparency = 0.6
        Blocker.BorderSizePixel = 0
        Blocker.ZIndex = 999
        Blocker.Active = true
        Blocker.Parent = self.ScreenGui
        CPFrame = Instance.new("Frame")
        CPFrame.Size = UDim2.new(0, 0, 0, 0)
        CPFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        CPFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        CPFrame.BackgroundColor3 = Theme.Card
        CPFrame.BackgroundTransparency = 0.03
        CPFrame.BorderSizePixel = 0
        CPFrame.ZIndex = 1000
        CPFrame.Parent = Blocker
        AddCorner(CPFrame, 16 * Scale)
        AddStroke(CPFrame, 1.5 * Scale, Theme.Primary, 0.3)
        local TW = 290 * Scale local TH = 340 * Scale
        CreateTween(CPFrame, Animations.Pop, {Size = UDim2.new(0, TW, 0, TH), Position = UDim2.new(0.5, -TW/2, 0.5, -TH/2)}):Play()

        local TitlePick = Instance.new("TextLabel")
        TitlePick.Size = UDim2.new(1, -50 * Scale, 0, 32 * Scale)
        TitlePick.Position = UDim2.new(0, 16 * Scale, 0, 8 * Scale)
        TitlePick.BackgroundTransparency = 1
        TitlePick.Text = Text
        TitlePick.TextColor3 = Theme.TextPrimary
        TitlePick.TextSize = 15 * Scale
        TitlePick.Font = Enum.Font.GothamBold
        TitlePick.TextXAlignment = Enum.TextXAlignment.Left
        TitlePick.ZIndex = 1001
        TitlePick.Parent = CPFrame

        local SVPicker = Instance.new("Frame")
        SVPicker.Size = UDim2.new(1, -32 * Scale, 0, 175 * Scale)
        SVPicker.Position = UDim2.new(0, 16 * Scale, 0, 46 * Scale)
        SVPicker.BackgroundColor3 = HsvToRgb(CurrentHue, 1, 1)
        SVPicker.BorderSizePixel = 0
        SVPicker.ZIndex = 1001
        SVPicker.Parent = CPFrame
        AddCorner(SVPicker, 8 * Scale)
        local WG = Instance.new("UIGradient")
        WG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}
        WG.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}
        WG.Parent = SVPicker
        local BO = Instance.new("Frame")
        BO.Size = UDim2.new(1,0,1,0)
        BO.BackgroundColor3 = Color3.new(0,0,0)
        BO.BorderSizePixel = 0
        BO.ZIndex = 1002
        BO.Parent = SVPicker
        AddCorner(BO, 8 * Scale)
        local BG = Instance.new("UIGradient")
        BG.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}
        BG.Rotation = 90
        BG.Parent = BO

        local HueBar = Instance.new("Frame")
        HueBar.Size = UDim2.new(1, -32 * Scale, 0, 24 * Scale)
        HueBar.Position = UDim2.new(0, 16 * Scale, 0, 232 * Scale)
        HueBar.BorderSizePixel = 0
        HueBar.ZIndex = 1001
        HueBar.Parent = CPFrame
        AddCorner(HueBar, 12 * Scale)
        AddGradient(HueBar, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
        }, 0)

        local PreviewBox = Instance.new("Frame")
        PreviewBox.Size = UDim2.new(1, -32 * Scale, 0, 30 * Scale)
        PreviewBox.Position = UDim2.new(0, 16 * Scale, 0, 268 * Scale)
        PreviewBox.BackgroundColor3 = CurrentColor
        PreviewBox.BorderSizePixel = 0
        PreviewBox.ZIndex = 1001
        PreviewBox.Parent = CPFrame
        AddCorner(PreviewBox, 8 * Scale)
        AddStroke(PreviewBox, 1 * Scale, Theme.BorderLight, 0.4)

        local SVSel = Instance.new("Frame")
        SVSel.Size = UDim2.new(0, 10*Scale, 0, 10*Scale)
        SVSel.Position = UDim2.new(CurrentSat, -5*Scale, 1-CurrentVal, -5*Scale)
        SVSel.BackgroundColor3 = Color3.new(1,1,1)
        SVSel.BorderSizePixel = 0
        SVSel.ZIndex = 1004
        SVSel.Parent = SVPicker
        AddCorner(SVSel, 5*Scale)
        AddStroke(SVSel, 2*Scale, Color3.new(0,0,0), 0.1)

        local HueSel = Instance.new("Frame")
        HueSel.Size = UDim2.new(0, 4*Scale, 1, 4*Scale)
        HueSel.Position = UDim2.new(CurrentHue, -2*Scale, 0, -2*Scale)
        HueSel.BackgroundColor3 = Color3.new(1,1,1)
        HueSel.BorderSizePixel = 0
        HueSel.ZIndex = 1002
        HueSel.Parent = HueBar
        AddCorner(HueSel, 3*Scale)
        AddStroke(HueSel, 1*Scale, Color3.new(0,0,0), 0.1)

        local SVDrag, HueDrag = false, false
        SVPicker.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then SVDrag = true end end)
        HueBar.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then HueDrag = true end end)
        UserInputService.InputChanged:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch then
                if SVDrag then
                    local P = SVPicker.AbsolutePosition local S = SVPicker.AbsoluteSize local MP = I.Position
                    CurrentSat = math.clamp((MP.X - P.X) / S.X, 0, 1)
                    CurrentVal = 1 - math.clamp((MP.Y - P.Y) / S.Y, 0, 1)
                    SVSel.Position = UDim2.new(CurrentSat, -5*Scale, 1-CurrentVal, -5*Scale)
                    UpdateColor()
                    PreviewBox.BackgroundColor3 = CurrentColor
                elseif HueDrag then
                    local P = HueBar.AbsolutePosition local S = HueBar.AbsoluteSize local MP = I.Position
                    CurrentHue = math.clamp((MP.X - P.X) / S.X, 0, 1)
                    HueSel.Position = UDim2.new(CurrentHue, -2*Scale, 0, -2*Scale)
                    SVPicker.BackgroundColor3 = HsvToRgb(CurrentHue, 1, 1)
                    UpdateColor()
                    PreviewBox.BackgroundColor3 = CurrentColor
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then SVDrag = false HueDrag = false end
        end)

        local CClose = Instance.new("TextButton")
        CClose.Size = UDim2.new(0, 26*Scale, 0, 26*Scale)
        CClose.Position = UDim2.new(1, -36*Scale, 0, 10*Scale)
        CClose.BackgroundColor3 = Theme.Error
        CClose.BackgroundTransparency = 0.3
        CClose.BorderSizePixel = 0
        CClose.Text = "x"
        CClose.TextColor3 = Theme.TextPrimary
        CClose.TextSize = 13*Scale
        CClose.Font = Enum.Font.GothamBold
        CClose.ZIndex = 1001
        CClose.Parent = CPFrame
        AddCorner(CClose, 13*Scale)
        local function CloseIt() if Blocker and Blocker.Parent then Blocker:Destroy() end CPFrame = nil PickerOpen = false end
        CClose.MouseButton1Click:Connect(CloseIt)
        Blocker.MouseButton1Click:Connect(CloseIt)
    end

    CBtn.MouseButton1Click:Connect(function()
        if not PickerOpen then PickerOpen = true CreatePicker() end
        CreateRipple(CBtn, Vector2.new(26*Scale, 17*Scale))
    end)
    CBtn.MouseEnter:Connect(function()
        CreateTween(CBtn, Animations.Fast, {Size = UDim2.new(0, 56*Scale, 0, 38*Scale), Position = UDim2.new(1, -68*Scale, 0.5, -19*Scale)}):Play()
    end)
    CBtn.MouseLeave:Connect(function()
        CreateTween(CBtn, Animations.Fast, {Size = UDim2.new(0, 52*Scale, 0, 34*Scale), Position = UDim2.new(1, -66*Scale, 0.5, -17*Scale)}):Play()
    end)
    AddHoverEffect(CFrame, Theme.SurfaceHover, Theme.Surface)
    table.insert(Section.Elements, CFrame)
    return {
        Element = CFrame,
        GetColor = function() return CurrentColor end,
        SetColor = function(C) CurrentColor = C CurrentHue, CurrentSat, CurrentVal = RgbToHsv(C.R, C.G, C.B) UpdateColor() end,
        SetCallback = function(C) Callback = C end,
    }
end

function TerminScriptsLib:TSSlider(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Slider"
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Default = Config.Default or Min
    local Increment = Config.Increment or 1
    local Suffix = Config.Suffix or ""
    local Callback = Config.Callback or function() end
    local CurrentValue = Default

    local SFrame = Instance.new("Frame")
    SFrame.Name = "TSSlider"
    SFrame.Size = UDim2.new(1, 0, 0, 72 * Scale)
    SFrame.BackgroundColor3 = Theme.Surface
    SFrame.BackgroundTransparency = 0.28
    SFrame.BorderSizePixel = 0
    SFrame.LayoutOrder = #Section.Elements + 1
    SFrame.Parent = Section.ContentContainer
    AddCorner(SFrame, 12 * Scale)
    AddStroke(SFrame, 1 * Scale, Theme.Border, 0.55)

    local SText = Instance.new("TextLabel")
    SText.Size = UDim2.new(1, -105 * Scale, 0, 26 * Scale)
    SText.Position = UDim2.new(0, 16 * Scale, 0, 9 * Scale)
    SText.BackgroundTransparency = 1
    SText.Text = Text
    SText.TextColor3 = Theme.TextPrimary
    SText.TextSize = 14 * Scale
    SText.Font = Enum.Font.GothamSemibold
    SText.TextXAlignment = Enum.TextXAlignment.Left
    SText.Parent = SFrame

    local VDisplay = Instance.new("TextLabel")
    VDisplay.Size = UDim2.new(0, 70 * Scale, 0, 26 * Scale)
    VDisplay.Position = UDim2.new(1, -86 * Scale, 0, 9 * Scale)
    VDisplay.BackgroundTransparency = 1
    VDisplay.Text = tostring(CurrentValue) .. Suffix
    VDisplay.TextColor3 = Theme.Primary
    VDisplay.TextSize = 14 * Scale
    VDisplay.Font = Enum.Font.GothamBold
    VDisplay.TextXAlignment = Enum.TextXAlignment.Right
    VDisplay.Parent = SFrame
    RegisterColor(VDisplay, "TextColor3", "Primary")

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -32 * Scale, 0, 6 * Scale)
    Track.Position = UDim2.new(0, 16 * Scale, 0, 48 * Scale)
    Track.BackgroundColor3 = Theme.Card
    Track.BorderSizePixel = 0
    Track.Parent = SFrame
    AddCorner(Track, 3 * Scale)
    AddStroke(Track, 1 * Scale, Theme.BorderLight, 0.55)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((CurrentValue - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Primary
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    AddCorner(Fill, 3 * Scale)
    AddGradient(Fill, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Secondary),
        ColorSequenceKeypoint.new(1, Theme.PrimaryGlow)
    }, 0)
    RegisterColor(Fill, "BackgroundColor3", "Primary")

    local Thumb = Instance.new("Frame")
    Thumb.Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale)
    Thumb.Position = UDim2.new((CurrentValue - Min) / (Max - Min), -9 * Scale, 0.5, -9 * Scale)
    Thumb.BackgroundColor3 = Theme.TextPrimary
    Thumb.BorderSizePixel = 0
    Thumb.Parent = Track
    Thumb.ZIndex = Track.ZIndex + 5
    AddCorner(Thumb, 9 * Scale)
    local ThumbStroke = AddStroke(Thumb, 2 * Scale, Theme.Primary, 0.2)
    RegisterColor(ThumbStroke, "Color", "Primary")

    local function UpdateSlider()
        local Pct = (CurrentValue - Min) / (Max - Min)
        CreateTween(Fill, Animations.Fast, {Size = UDim2.new(Pct, 0, 1, 0)}):Play()
        CreateTween(Thumb, Animations.Fast, {Position = UDim2.new(Pct, -9 * Scale, 0.5, -9 * Scale)}):Play()
        VDisplay.Text = tostring(CurrentValue) .. Suffix
        local Ok, Err = pcall(Callback, CurrentValue)
        if not Ok then warn("Slider error:", Err) end
    end

    local Dragging = false
    local TrackConn
    local function HandleInput(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            CreateTween(Thumb, Animations.Fast, {Size = UDim2.new(0, 22*Scale, 0, 22*Scale)}):Play()
            TrackConn = UserInputService.InputChanged:Connect(function(I2)
                if (I2.UserInputType == Enum.UserInputType.MouseMovement or I2.UserInputType == Enum.UserInputType.Touch) and Dragging then
                    local TP = Track.AbsolutePosition.X
                    local TS = Track.AbsoluteSize.X
                    local Pct = math.clamp((I2.Position.X - TP) / TS, 0, 1)
                    local Raw = Min + (Max - Min) * Pct
                    CurrentValue = math.clamp(math.floor(Raw / Increment + 0.5) * Increment, Min, Max)
                    UpdateSlider()
                end
            end)
        end
    end
    Track.InputBegan:Connect(HandleInput)
    Thumb.InputBegan:Connect(HandleInput)
    UserInputService.InputEnded:Connect(function(I)
        if (I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch) and Dragging then
            Dragging = false
            CreateTween(Thumb, Animations.Spring, {Size = UDim2.new(0, 18*Scale, 0, 18*Scale)}):Play()
            if TrackConn then TrackConn:Disconnect() TrackConn = nil end
        end
    end)
    Thumb.MouseEnter:Connect(function()
        if not Dragging then CreateTween(Thumb, Animations.Fast, {Size = UDim2.new(0, 22*Scale, 0, 22*Scale), Position = UDim2.new((CurrentValue-Min)/(Max-Min), -11*Scale, 0.5, -11*Scale)}):Play() end
    end)
    Thumb.MouseLeave:Connect(function()
        if not Dragging then CreateTween(Thumb, Animations.Fast, {Size = UDim2.new(0, 18*Scale, 0, 18*Scale), Position = UDim2.new((CurrentValue-Min)/(Max-Min), -9*Scale, 0.5, -9*Scale)}):Play() end
    end)
    AddHoverEffect(SFrame, Theme.SurfaceHover, Theme.Surface)
    table.insert(Section.Elements, SFrame)
    return {
        Element = SFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = math.clamp(V, Min, Max) UpdateSlider() end,
        SetRange = function(NMin, NMax) Min = NMin Max = NMax CurrentValue = math.clamp(CurrentValue, Min, Max) UpdateSlider() end,
    }
end

function TerminScriptsLib:TSTextBox(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "TextBox"
    local Placeholder = Config.Placeholder or "Enter text..."
    local Default = Config.Default or ""
    local Callback = Config.Callback or function() end
    local Multiline = Config.Multiline or false
    local NumbersOnly = Config.NumbersOnly or false

    local TBFrame = Instance.new("Frame")
    TBFrame.Name = "TSTextBox"
    TBFrame.Size = UDim2.new(1, 0, 0, Multiline and 92 * Scale or 52 * Scale)
    TBFrame.BackgroundColor3 = Theme.Surface
    TBFrame.BackgroundTransparency = 0.28
    TBFrame.BorderSizePixel = 0
    TBFrame.LayoutOrder = #Section.Elements + 1
    TBFrame.Parent = Section.ContentContainer
    AddCorner(TBFrame, 12 * Scale)
    AddStroke(TBFrame, 1 * Scale, Theme.Border, 0.55)

    local TBLabel = Instance.new("TextLabel")
    TBLabel.Size = UDim2.new(1, -32 * Scale, 0, 20 * Scale)
    TBLabel.Position = UDim2.new(0, 16 * Scale, 0, 5 * Scale)
    TBLabel.BackgroundTransparency = 1
    TBLabel.Text = Text
    TBLabel.TextColor3 = Theme.TextSecondary
    TBLabel.TextSize = 11 * Scale
    TBLabel.Font = Enum.Font.GothamSemibold
    TBLabel.TextXAlignment = Enum.TextXAlignment.Left
    TBLabel.Parent = TBFrame

    local TBInput = Instance.new("TextBox")
    TBInput.Size = UDim2.new(1, -32 * Scale, 0, Multiline and 54 * Scale or 22 * Scale)
    TBInput.Position = UDim2.new(0, 16 * Scale, 0, 26 * Scale)
    TBInput.BackgroundColor3 = Theme.Card
    TBInput.BackgroundTransparency = 0.25
    TBInput.BorderSizePixel = 0
    TBInput.Text = Default
    TBInput.PlaceholderText = Placeholder
    TBInput.TextColor3 = Theme.TextPrimary
    TBInput.PlaceholderColor3 = Theme.TextMuted
    TBInput.TextSize = 13 * Scale
    TBInput.Font = Enum.Font.Gotham
    TBInput.TextXAlignment = Enum.TextXAlignment.Left
    TBInput.TextYAlignment = Multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    TBInput.MultiLine = Multiline
    TBInput.TextWrapped = Multiline
    TBInput.Parent = TBFrame
    AddCorner(TBInput, 7 * Scale)
    local TBStroke = AddStroke(TBInput, 1.5 * Scale, Theme.BorderLight, 0.55)

    TBInput.Focused:Connect(function()
        CreateTween(TBInput, Animations.Fast, {BackgroundColor3 = Theme.CardElevated, BackgroundTransparency = 0.08}):Play()
        CreateTween(TBStroke, Animations.Fast, {Color = Theme.Primary, Transparency = 0.15}):Play()
    end)
    TBInput.FocusLost:Connect(function()
        CreateTween(TBInput, Animations.Fast, {BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.25}):Play()
        CreateTween(TBStroke, Animations.Fast, {Color = Theme.BorderLight, Transparency = 0.55}):Play()
        local Ok, Err = pcall(Callback, TBInput.Text)
        if not Ok then warn("TextBox error:", Err) end
    end)
    if NumbersOnly then
        TBInput.Changed:Connect(function(P)
            if P == "Text" then
                local N = TBInput.Text:gsub("[^%d%.%-]", "")
                if N ~= TBInput.Text then TBInput.Text = N end
            end
        end)
    end
    AddHoverEffect(TBFrame, Theme.SurfaceHover, Theme.Surface)
    table.insert(Section.Elements, TBFrame)
    return {
        Element = TBFrame,
        GetText = function() return TBInput.Text end,
        SetText = function(T) TBInput.Text = T end,
        Focus = function() TBInput:CaptureFocus() end,
        ClearText = function() TBInput.Text = "" end,
    }
end

function TerminScriptsLib:TSLabel(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Label"
    local Value = Config.Value or ""
    local Icon = Config.Icon
    local Style = Config.Style or "default"
    local Typewriter = Config.Typewriter or false

    local BgColor = Theme.Surface
    if Style == "info" then BgColor = Theme.Primary:lerp(Theme.Surface, 0.88)
    elseif Style == "warning" then BgColor = Theme.Warning:lerp(Theme.Surface, 0.88)
    elseif Style == "error" then BgColor = Theme.Error:lerp(Theme.Surface, 0.88) end

    local LFrame = Instance.new("Frame")
    LFrame.Name = "TSLabel"
    LFrame.Size = UDim2.new(1, 0, 0, 42 * Scale)
    LFrame.BackgroundColor3 = BgColor
    LFrame.BackgroundTransparency = 0.25
    LFrame.BorderSizePixel = 0
    LFrame.LayoutOrder = #Section.Elements + 1
    LFrame.Parent = Section.ContentContainer
    AddCorner(LFrame, 10 * Scale)
    local LStrokeColor = Style == "info" and Theme.Primary or (Style == "warning" and Theme.Warning or (Style == "error" and Theme.Error or Theme.BorderLight))
    AddStroke(LFrame, 1 * Scale, LStrokeColor, 0.5)

    local LeftOff = 14 * Scale
    if Icon then
        local ILabel = Instance.new("TextLabel")
        ILabel.Size = UDim2.new(0, 22 * Scale, 1, 0)
        ILabel.Position = UDim2.new(0, LeftOff, 0, 0)
        ILabel.BackgroundTransparency = 1
        ILabel.Text = Icon
        ILabel.TextColor3 = LStrokeColor
        ILabel.TextSize = 15 * Scale
        ILabel.Font = Enum.Font.GothamBold
        ILabel.TextXAlignment = Enum.TextXAlignment.Center
        ILabel.Parent = LFrame
        LeftOff = LeftOff + 26 * Scale
    end

    local LText = Instance.new("TextLabel")
    LText.Size = UDim2.new(0.5, -(LeftOff), 1, 0)
    LText.Position = UDim2.new(0, LeftOff, 0, 0)
    LText.BackgroundTransparency = 1
    LText.Text = Text
    LText.TextColor3 = Theme.TextSecondary
    LText.TextSize = 12 * Scale
    LText.Font = Enum.Font.GothamSemibold
    LText.TextXAlignment = Enum.TextXAlignment.Left
    LText.Parent = LFrame

    local LValue = Instance.new("TextLabel")
    LValue.Size = UDim2.new(0.48, -14 * Scale, 1, 0)
    LValue.Position = UDim2.new(0.52, 0, 0, 0)
    LValue.BackgroundTransparency = 1
    LValue.Text = Typewriter and "" or Value
    LValue.TextColor3 = Style == "info" and Theme.Primary or (Style == "warning" and Theme.Warning or Theme.TextPrimary)
    LValue.TextSize = 12 * Scale
    LValue.Font = Enum.Font.GothamBold
    LValue.TextXAlignment = Enum.TextXAlignment.Right
    LValue.Parent = LFrame
    RegisterColor(LValue, "TextColor3", Style == "info" and "Primary" or "TextPrimary")

    if Typewriter and Value ~= "" then
        task.delay(0.1, function() TypewriterEffect(LValue, Value, 0.035) end)
    end

    table.insert(Section.Elements, LFrame)
    return {
        Element = LFrame,
        SetText = function(T) LText.Text = T end,
        SetValue = function(V)
            if Typewriter then TypewriterEffect(LValue, V, 0.03)
            else LValue.Text = V end
        end,
        GetValue = function() return LValue.Text end,
    }
end

function TerminScriptsLib:TSProgressBar(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Progress"
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Default = Config.Default or Min
    local Suffix = Config.Suffix or "%"
    local Animated = Config.Animated ~= false
    local CurrentValue = Default

    local PFrame = Instance.new("Frame")
    PFrame.Name = "TSProgressBar"
    PFrame.Size = UDim2.new(1, 0, 0, 62 * Scale)
    PFrame.BackgroundColor3 = Theme.Surface
    PFrame.BackgroundTransparency = 0.28
    PFrame.BorderSizePixel = 0
    PFrame.LayoutOrder = #Section.Elements + 1
    PFrame.Parent = Section.ContentContainer
    AddCorner(PFrame, 12 * Scale)
    AddStroke(PFrame, 1 * Scale, Theme.Border, 0.55)

    local PText = Instance.new("TextLabel")
    PText.Size = UDim2.new(0.65, -16 * Scale, 0, 24 * Scale)
    PText.Position = UDim2.new(0, 16 * Scale, 0, 8 * Scale)
    PText.BackgroundTransparency = 1
    PText.Text = Text
    PText.TextColor3 = Theme.TextPrimary
    PText.TextSize = 13 * Scale
    PText.Font = Enum.Font.GothamSemibold
    PText.TextXAlignment = Enum.TextXAlignment.Left
    PText.Parent = PFrame

    local PValLabel = Instance.new("TextLabel")
    PValLabel.Size = UDim2.new(0.35, -16 * Scale, 0, 24 * Scale)
    PValLabel.Position = UDim2.new(0.65, 0, 0, 8 * Scale)
    PValLabel.BackgroundTransparency = 1
    PValLabel.Text = tostring(math.floor((CurrentValue - Min) / (Max - Min) * 100)) .. Suffix
    PValLabel.TextColor3 = Theme.Primary
    PValLabel.TextSize = 13 * Scale
    PValLabel.Font = Enum.Font.GothamBold
    PValLabel.TextXAlignment = Enum.TextXAlignment.Right
    PValLabel.Parent = PFrame
    RegisterColor(PValLabel, "TextColor3", "Primary")

    local PTrack = Instance.new("Frame")
    PTrack.Size = UDim2.new(1, -32 * Scale, 0, 9 * Scale)
    PTrack.Position = UDim2.new(0, 16 * Scale, 0, 42 * Scale)
    PTrack.BackgroundColor3 = Theme.Card
    PTrack.BorderSizePixel = 0
    PTrack.Parent = PFrame
    AddCorner(PTrack, 5 * Scale)

    local PFill = Instance.new("Frame")
    PFill.Size = UDim2.new(0, 0, 1, 0)
    PFill.BackgroundColor3 = Theme.Primary
    PFill.BorderSizePixel = 0
    PFill.Parent = PTrack
    AddCorner(PFill, 5 * Scale)
    AddGradient(PFill, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Secondary),
        ColorSequenceKeypoint.new(0.5, Theme.Primary),
        ColorSequenceKeypoint.new(1, Theme.PrimaryGlow)
    }, 0)
    RegisterColor(PFill, "BackgroundColor3", "Primary")

    if Animated then
        local Shimmer = Instance.new("Frame")
        Shimmer.Size = UDim2.new(0, 30 * Scale, 1, 0)
        Shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
        Shimmer.BackgroundTransparency = 0.72
        Shimmer.BorderSizePixel = 0
        Shimmer.ZIndex = PFill.ZIndex + 1
        Shimmer.Parent = PFill
        AddCorner(Shimmer, 3 * Scale)
        local function AnimateShimmer()
            if not Shimmer or not Shimmer.Parent then return end
            Shimmer.Position = UDim2.new(-0.25, 0, 0, 0)
            local T = CreateTween(Shimmer, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(1.1, 0, 0, 0)})
            T:Play()
            T.Completed:Connect(function() task.delay(1.2, AnimateShimmer) end)
        end
        task.delay(0.5, AnimateShimmer)
    end

    local DisplayedValue = Min
    local function AnimateCounter(TargetVal)
        local Steps = 20
        local StepTime = 0.3 / Steps
        local StartVal = DisplayedValue
        for I = 1, Steps do
            task.delay(I * StepTime, function()
                local T = I / Steps
                local Interpolated = StartVal + (TargetVal - StartVal) * T
                DisplayedValue = Interpolated
                local Pct = math.clamp((Interpolated - Min) / (Max - Min), 0, 1)
                PValLabel.Text = tostring(math.floor(Pct * 100)) .. Suffix
            end)
        end
    end

    local function UpdateProgress()
        local Pct = math.clamp((CurrentValue - Min) / (Max - Min), 0, 1)
        CreateTween(PFill, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(Pct, 0, 1, 0)}):Play()
        AnimateCounter(CurrentValue)
    end

    task.delay(0.18, UpdateProgress)
    AddHoverEffect(PFrame, Theme.SurfaceHover, Theme.Surface)
    table.insert(Section.Elements, PFrame)
    return {
        Element = PFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = math.clamp(V, Min, Max) UpdateProgress() end,
        SetText = function(T) PText.Text = T end,
    }
end

function TerminScriptsLib:TSSeparator(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text
    local Color = Config.Color or Theme.Primary

    local SepFrame = Instance.new("Frame")
    SepFrame.Name = "TSSeparator"
    SepFrame.Size = UDim2.new(1, 0, 0, Text and 22 * Scale or 12 * Scale)
    SepFrame.BackgroundTransparency = 1
    SepFrame.LayoutOrder = #Section.Elements + 1
    SepFrame.Parent = Section.ContentContainer

    if Text then
        local LeftLine = Instance.new("Frame")
        LeftLine.Size = UDim2.new(0.5, -60 * Scale, 0, 1 * Scale)
        LeftLine.Position = UDim2.new(0, 0, 0.5, 0)
        LeftLine.BackgroundColor3 = Color
        LeftLine.BackgroundTransparency = 0.6
        LeftLine.BorderSizePixel = 0
        LeftLine.Parent = SepFrame

        local RightLine = Instance.new("Frame")
        RightLine.Size = UDim2.new(0.5, -60 * Scale, 0, 1 * Scale)
        RightLine.Position = UDim2.new(0.5, 60 * Scale, 0.5, 0)
        RightLine.BackgroundColor3 = Color
        RightLine.BackgroundTransparency = 0.6
        RightLine.BorderSizePixel = 0
        RightLine.Parent = SepFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 110 * Scale, 1, 0)
        Label.Position = UDim2.new(0.5, -55 * Scale, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Text
        Label.TextColor3 = Color
        Label.TextTransparency = 0.35
        Label.TextSize = 10 * Scale
        Label.Font = Enum.Font.GothamSemibold
        Label.Parent = SepFrame
    else
        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(1, 0, 0, 1 * Scale)
        Line.Position = UDim2.new(0, 0, 0.5, 0)
        Line.BackgroundColor3 = Color
        Line.BackgroundTransparency = 0.65
        Line.BorderSizePixel = 0
        Line.Parent = SepFrame
    end

    table.insert(Section.Elements, SepFrame)
    return {Element = SepFrame}
end

function TerminScriptsLib:TSMultiButton(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Options = Config.Options or {"Option A", "Option B", "Option C"}
    local Default = Config.Default or Options[1]
    local Callback = Config.Callback or function() end
    local Selected = Default

    local MBFrame = Instance.new("Frame")
    MBFrame.Name = "TSMultiButton"
    MBFrame.Size = UDim2.new(1, 0, 0, 48 * Scale)
    MBFrame.BackgroundColor3 = Theme.Card
    MBFrame.BackgroundTransparency = 0.2
    MBFrame.BorderSizePixel = 0
    MBFrame.LayoutOrder = #Section.Elements + 1
    MBFrame.Parent = Section.ContentContainer
    AddCorner(MBFrame, 12 * Scale)
    AddStroke(MBFrame, 1 * Scale, Theme.BorderLight, 0.5)

    local InnerPad = Instance.new("UIPadding")
    InnerPad.PaddingLeft = UDim.new(0, 4 * Scale)
    InnerPad.PaddingRight = UDim.new(0, 4 * Scale)
    InnerPad.PaddingTop = UDim.new(0, 5 * Scale)
    InnerPad.PaddingBottom = UDim.new(0, 5 * Scale)
    InnerPad.Parent = MBFrame

    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BtnLayout.Padding = UDim.new(0, 4 * Scale)
    BtnLayout.Parent = MBFrame

    local Buttons = {}
    local function SelectOption(Opt)
        Selected = Opt
        for _, BData in ipairs(Buttons) do
            local IsNow = BData.Text == Opt
            CreateTween(BData.Btn, Animations.Fast, {
                BackgroundColor3 = IsNow and Theme.Primary or Theme.Surface,
                BackgroundTransparency = IsNow and 0.05 or 0.5
            }):Play()
            CreateTween(BData.Label, Animations.Fast, {
                TextColor3 = IsNow and Theme.TextPrimary or Theme.TextMuted
            }):Play()
        end
        local Ok, Err = pcall(Callback, Opt)
        if not Ok then warn("MultiButton error:", Err) end
    end

    local TotalWeight = #Options
    for I, Opt in ipairs(Options) do
        local IsSelected = Opt == Selected
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1 / TotalWeight, -3 * Scale, 1, 0)
        Btn.BackgroundColor3 = IsSelected and Theme.Primary or Theme.Surface
        Btn.BackgroundTransparency = IsSelected and 0.05 or 0.5
        Btn.BorderSizePixel = 0
        Btn.Text = ""
        Btn.LayoutOrder = I
        Btn.Parent = MBFrame
        AddCorner(Btn, 9 * Scale)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Opt
        Label.TextColor3 = IsSelected and Theme.TextPrimary or Theme.TextMuted
        Label.TextSize = 12 * Scale
        Label.Font = Enum.Font.GothamSemibold
        Label.Parent = Btn

        table.insert(Buttons, {Btn = Btn, Label = Label, Text = Opt})

        Btn.MouseButton1Click:Connect(function()
            CreateRipple(Btn, Vector2.new(Btn.AbsoluteSize.X / 2, Btn.AbsoluteSize.Y / 2))
            SelectOption(Opt)
        end)
    end

    table.insert(Section.Elements, MBFrame)
    return {
        Element = MBFrame,
        GetSelected = function() return Selected end,
        SetSelected = function(V) SelectOption(V) end,
        SetCallback = function(C) Callback = C end,
    }
end

function TerminScriptsLib:TSBadgeRow(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Label = Config.Label or ""
    local Badges = Config.Badges or {}

    local RowFrame = Instance.new("Frame")
    RowFrame.Name = "TSBadgeRow"
    RowFrame.Size = UDim2.new(1, 0, 0, 38 * Scale)
    RowFrame.BackgroundTransparency = 1
    RowFrame.LayoutOrder = #Section.Elements + 1
    RowFrame.Parent = Section.ContentContainer

    if Label ~= "" then
        local LText = Instance.new("TextLabel")
        LText.Size = UDim2.new(0, 110 * Scale, 1, 0)
        LText.BackgroundTransparency = 1
        LText.Text = Label
        LText.TextColor3 = Theme.TextSecondary
        LText.TextSize = 12 * Scale
        LText.Font = Enum.Font.GothamSemibold
        LText.TextXAlignment = Enum.TextXAlignment.Left
        LText.Parent = RowFrame
    end

    local BadgeContainer = Instance.new("Frame")
    BadgeContainer.Size = UDim2.new(1, Label ~= "" and -114 * Scale or 0, 1, 0)
    BadgeContainer.Position = UDim2.new(0, Label ~= "" and 114 * Scale or 0, 0, 0)
    BadgeContainer.BackgroundTransparency = 1
    BadgeContainer.Parent = RowFrame

    local BLayout = Instance.new("UIListLayout")
    BLayout.FillDirection = Enum.FillDirection.Horizontal
    BLayout.Padding = UDim.new(0, 6 * Scale)
    BLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BLayout.Parent = BadgeContainer

    local BadgeObjects = {}
    for _, BData in ipairs(Badges) do
        local BColor = BData.Color or Theme.Primary
        local Badge = Instance.new("Frame")
        Badge.Size = UDim2.new(0, 0, 0, 24 * Scale)
        Badge.BackgroundColor3 = BColor
        Badge.BackgroundTransparency = 0.15
        Badge.BorderSizePixel = 0
        Badge.AutomaticSize = Enum.AutomaticSize.X
        Badge.Parent = BadgeContainer
        AddCorner(Badge, 12 * Scale)
        AddStroke(Badge, 1 * Scale, BColor, 0.4)

        local BPad = Instance.new("UIPadding")
        BPad.PaddingLeft = UDim.new(0, 8 * Scale)
        BPad.PaddingRight = UDim.new(0, 8 * Scale)
        BPad.Parent = Badge

        local BLabel = Instance.new("TextLabel")
        BLabel.Size = UDim2.new(0, 0, 1, 0)
        BLabel.AutomaticSize = Enum.AutomaticSize.X
        BLabel.BackgroundTransparency = 1
        BLabel.Text = BData.Text or "Badge"
        BLabel.TextColor3 = BColor:lerp(Color3.new(1,1,1), 0.4)
        BLabel.TextSize = 10 * Scale
        BLabel.Font = Enum.Font.GothamBold
        BLabel.Parent = Badge

        table.insert(BadgeObjects, Badge)
    end

    table.insert(Section.Elements, RowFrame)
    return {
        Element = RowFrame,
        GetBadges = function() return BadgeObjects end,
    }
end

function TerminScriptsLib:Notify(Title, Message, NotifType, Duration)
    Duration = Duration or 4
    NotifType = NotifType or "info"
    local Scale = ScalingManager.CurrentScale
    local TypeColors = {
        success = Theme.Success, error = Theme.Error,
        warning = Theme.Warning, info = Theme.Primary,
    }
    local TypeSymbols = {success = "+", error = "x", warning = "!", info = "i"}
    local Color = TypeColors[NotifType] or Theme.Primary
    local Symbol = TypeSymbols[NotifType] or "i"
    local NW = 295 * Scale
    local NH = 68 * Scale
    local Padding = 8 * Scale
    local YOffset = Padding + (#ActiveNotifications * (NH + Padding))

    local NFrame = Instance.new("Frame")
    NFrame.Name = "Notification"
    NFrame.Size = UDim2.new(0, NW, 0, NH)
    NFrame.Position = UDim2.new(1, NW + 20 * Scale, 1, -(YOffset + NH))
    NFrame.BackgroundColor3 = Theme.Card
    NFrame.BackgroundTransparency = 0.06
    NFrame.BorderSizePixel = 0
    NFrame.ZIndex = 500
    NFrame.Parent = self.ScreenGui
    AddCorner(NFrame, 13 * Scale)
    AddStroke(NFrame, 1.5 * Scale, Color, 0.25)

    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(0, 2.5 * Scale, 1, -14 * Scale)
    AccentLine.Position = UDim2.new(0, 0, 0, 7 * Scale)
    AccentLine.BackgroundColor3 = Color
    AccentLine.BorderSizePixel = 0
    AccentLine.ZIndex = 501
    AccentLine.Parent = NFrame
    AddCorner(AccentLine, 2 * Scale)

    local IconBg = Instance.new("Frame")
    IconBg.Size = UDim2.new(0, 26 * Scale, 0, 26 * Scale)
    IconBg.Position = UDim2.new(0, 10 * Scale, 0.5, -13 * Scale)
    IconBg.BackgroundColor3 = Color
    IconBg.BackgroundTransparency = 0.8
    IconBg.BorderSizePixel = 0
    IconBg.ZIndex = 501
    IconBg.Parent = NFrame
    AddCorner(IconBg, 8 * Scale)

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Symbol
    IconLabel.TextColor3 = Color
    IconLabel.TextSize = 13 * Scale
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.ZIndex = 502
    IconLabel.Parent = IconBg

    local TitleL = Instance.new("TextLabel")
    TitleL.Size = UDim2.new(1, -52 * Scale, 0, 20 * Scale)
    TitleL.Position = UDim2.new(0, 46 * Scale, 0, 12 * Scale)
    TitleL.BackgroundTransparency = 1
    TitleL.Text = Title
    TitleL.TextColor3 = Theme.TextPrimary
    TitleL.TextSize = 13 * Scale
    TitleL.Font = Enum.Font.GothamBold
    TitleL.TextXAlignment = Enum.TextXAlignment.Left
    TitleL.ZIndex = 501
    TitleL.Parent = NFrame

    local MsgL = Instance.new("TextLabel")
    MsgL.Size = UDim2.new(1, -52 * Scale, 0, 16 * Scale)
    MsgL.Position = UDim2.new(0, 46 * Scale, 0, 34 * Scale)
    MsgL.BackgroundTransparency = 1
    MsgL.Text = Message
    MsgL.TextColor3 = Theme.TextSecondary
    MsgL.TextSize = 11 * Scale
    MsgL.Font = Enum.Font.Gotham
    MsgL.TextXAlignment = Enum.TextXAlignment.Left
    MsgL.ZIndex = 501
    MsgL.Parent = NFrame

    local ProgTrack = Instance.new("Frame")
    ProgTrack.Size = UDim2.new(1, -10 * Scale, 0, 2 * Scale)
    ProgTrack.Position = UDim2.new(0, 5 * Scale, 1, -3 * Scale)
    ProgTrack.BackgroundColor3 = Theme.Surface
    ProgTrack.BorderSizePixel = 0
    ProgTrack.ZIndex = 501
    ProgTrack.Parent = NFrame
    AddCorner(ProgTrack, 1 * Scale)
    local ProgFill = Instance.new("Frame")
    ProgFill.Size = UDim2.new(1, 0, 1, 0)
    ProgFill.BackgroundColor3 = Color
    ProgFill.BorderSizePixel = 0
    ProgFill.ZIndex = 502
    ProgFill.Parent = ProgTrack
    AddCorner(ProgFill, 1 * Scale)
    CreateTween(ProgFill, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    NFrame.MouseEnter:Connect(function()
        CreateTween(NFrame, Animations.Fast, {BackgroundTransparency = 0.0}):Play()
    end)
    NFrame.MouseLeave:Connect(function()
        CreateTween(NFrame, Animations.Fast, {BackgroundTransparency = 0.06}):Play()
    end)

    table.insert(ActiveNotifications, NFrame)
    CreateTween(NFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -(NW + 12 * Scale), 1, -(YOffset + NH))
    }):Play()

    task.delay(Duration, function()
        local T = CreateTween(NFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, NW + 20 * Scale, 1, -(YOffset + NH)),
            BackgroundTransparency = 1
        })
        T:Play()
        T.Completed:Connect(function()
            for I, N in ipairs(ActiveNotifications) do
                if N == NFrame then table.remove(ActiveNotifications, I) break end
            end
            NFrame:Destroy()
            for I, N in ipairs(ActiveNotifications) do
                local TargetY = -(Padding + (I - 1) * (NH + Padding) + NH)
                CreateTween(N, Animations.Normal, {Position = UDim2.new(1, -(NW + 12 * Scale), 1, TargetY)}):Play()
            end
        end)
    end)
end

function TerminScriptsLib:SetTheme(ThemeName)
    local Preset = ThemePresets[ThemeName]
    if not Preset then return end
    self.CurrentThemeName = ThemeName
    for Key, Value in pairs(Preset) do
        Theme[Key] = Value
    end
    Theme.Success = Color3.fromRGB(52, 211, 153)
    for _, Entry in ipairs(ThemeColorRegistry) do
        if Entry.Object and Entry.Object.Parent then
            local NewColor = Theme[Entry.ThemeKey]
            if NewColor then
                pcall(function()
                    CreateTween(Entry.Object, Animations.Normal, {[Entry.Property] = NewColor}):Play()
                end)
            end
        end
    end
    for _, Entry in ipairs(ThemeGradientRegistry) do
        if Entry.Gradient and Entry.Gradient.Parent then
            pcall(function() Entry.Gradient.Color = Entry.BuildFn() end)
        end
    end
    local NotifTypes = {
        Emerald = "success", Neon = "info", Cyberpunk = "warning", Ocean = "info", Crimson = "error"
    }
    local ThemeNames = {
        Emerald = "Emerald Dark", Neon = "Neon Purple", Cyberpunk = "Cyberpunk Gold",
        Ocean = "Ocean Cyan", Crimson = "Crimson Red"
    }
    self:Notify("Theme Applied", ThemeNames[ThemeName] or ThemeName, NotifTypes[ThemeName] or "info", 3)
end

function TerminScriptsLib:SetupControls()
    self.MinimizeBtn.MouseButton1Click:Connect(function() self:Minimize() end)
    self.MaximizeBtn.MouseButton1Click:Connect(function() self:Maximize() end)
    self.CloseBtn.MouseButton1Click:Connect(function() self:Destroy() end)
end

function TerminScriptsLib:SetupDragging()
    local DragStart, StartPos
    local Dragging = false
    self.Header.InputBegan:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not self.IsMaximized then
            Dragging = true
            DragStart = Input.Position
            StartPos = self.MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
            local D = Input.Position - DragStart
            self.MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + D.X, StartPos.Y.Scale, StartPos.Y.Offset + D.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
    end)
end

function TerminScriptsLib:SetupKeybinds()
    KeybindManager:Bind(self.KeybindToggle, function() self:Toggle() end)
end

function TerminScriptsLib:SetupScaling()
    local Conn
    Conn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        ScalingManager:CalculateScale()
    end)
    self.ScaleConnection = Conn
end

function TerminScriptsLib:Minimize()
    self.IsMinimized = not self.IsMinimized
    local TS = self.IsMinimized and UDim2.new(0, 340 * ScalingManager.CurrentScale, 0, 86 * ScalingManager.CurrentScale) or self.OriginalSize
    local TT = self.IsMinimized and 0.6 or Theme.GlassMain
    CreateTween(self.MainFrame, Animations.Spring, {Size = TS, BackgroundTransparency = TT}):Play()
    if self.IsMinimized then
        CreateTween(self.ContentArea, Animations.Fast, {BackgroundTransparency = 1}):Play()
        task.delay(0.18, function() if self.ContentArea then self.ContentArea.Visible = false end end)
    else
        self.ContentArea.Visible = true
        self.ContentArea.BackgroundTransparency = 1
    end
    self.MinimizeBtn.Text = self.IsMinimized and "+" or "-"
end

function TerminScriptsLib:Maximize()
    self.IsMaximized = not self.IsMaximized
    local Camera = workspace.CurrentCamera
    local SS = Camera.ViewportSize
    local Scale = ScalingManager.CurrentScale
    local TS = self.IsMaximized and UDim2.new(0, SS.X - 80 * Scale, 0, SS.Y - 80 * Scale) or self.OriginalSize
    local TP = self.IsMaximized and UDim2.new(0, 40 * Scale, 0, 40 * Scale) or self.OriginalPosition
    CreateTween(self.MainFrame, Animations.Back, {Size = TS, Position = TP}):Play()
    self.MaximizeBtn.Text = self.IsMaximized and "o" or "+"
end

function TerminScriptsLib:Toggle()
    self.IsVisible = not self.IsVisible
    if self.IsVisible then
        self.ScreenGui.Enabled = true
        self:PlayEntranceAnimation()
    else
        CreateTween(self.MainFrame, Animations.FadeOut, {BackgroundTransparency = 1}):Play()
        task.delay(0.25, function() if self.ScreenGui then self.ScreenGui.Enabled = false end end)
    end
end

function TerminScriptsLib:Destroy()
    KeybindManager:UnbindAll()
    if self.ScaleConnection then self.ScaleConnection:Disconnect() end
    DropdownManager:CloseAll()
    if self.ScreenGui then
        local DT = CreateTween(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, self.MainFrame.Size.X.Offset * 0.92, 0, self.MainFrame.Size.Y.Offset * 0.92)
        })
        DT:Play()
        DT.Completed:Connect(function() self.ScreenGui:Destroy() end)
    end
end

return TerminScriptsLib
