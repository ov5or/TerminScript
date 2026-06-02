local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

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
    GlassMain = 0.1,
    GlassSecondary = 0.2,
    GlassLight = 0.3,
    GlowStrength = 0.2,
    Shadow = Color3.fromRGB(0, 0, 0),
    ShadowStrong = Color3.fromRGB(3, 8, 6),
    Glow = Color3.fromRGB(16, 185, 129),
    Rainbow = {
        Color3.fromRGB(16, 185, 129),
        Color3.fromRGB(52, 211, 153),
        Color3.fromRGB(251, 191, 36),
        Color3.fromRGB(255, 159, 28),
        Color3.fromRGB(239, 68, 68),
        Color3.fromRGB(96, 165, 250),
        Color3.fromRGB(167, 139, 250),
    }
}

local Animations = {
    Lightning = TweenInfo.new(0.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    UltraFast = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.6, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Back = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    FadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    FadeOut = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    Sharp = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    Breathe = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
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

    if Viewport.X < 768 then
        Scale = Scale * 1.2
    elseif Viewport.X < 1366 then
        Scale = Scale * 1.1
    end

    Scale = math.clamp(Scale, self.MinScale, self.MaxScale)

    self.CurrentScale = Scale
    return Scale
end

function ScalingManager:GetScaledValue(Value)
    return Value * self.CurrentScale
end

function ScalingManager:GetScaledUDim2(Udim2)
    return UDim2.new(
        Udim2.X.Scale,
        Udim2.X.Offset * self.CurrentScale,
        Udim2.Y.Scale,
        Udim2.Y.Offset * self.CurrentScale
    )
end

local TouchManager = {
    IsTouchDevice = UserInputService.TouchEnabled,
    IsDragging = false,
    DragObject = nil,
    DragStart = nil,
    StartPos = nil
}

function TouchManager:EnableDrag(Frame, DragHandle)
    local Handle = DragHandle or Frame

    if not (Handle.Name == "TitleContainer" or (Handle.Parent and Handle.Parent.Name == "TitleContainer")) then
        return
    end

    local Dragging = false
    local DragStartPos = nil
    local StartPosition = nil

    local function BeginDrag(Input)
        Dragging = true
        DragStartPos = Input.Position
        StartPosition = Frame.Position
        self.IsDragging = true
        self.DragObject = Frame
    end

    local function UpdateDrag(Input)
        if Dragging and DragStartPos then
            local Delta = Input.Position - DragStartPos
            Frame.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end

    local function EndDrag()
        Dragging = false
        DragStartPos = nil
        StartPosition = nil
        self.IsDragging = false
        self.DragObject = nil
    end

    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            BeginDrag(Input)
        end
    end)

    Handle.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            UpdateDrag(Input)
        end
    end)

    Handle.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            EndDrag()
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            UpdateDrag(Input)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            EndDrag()
        end
    end)
end

local KeybindManager = {
    Bindings = {},
    ToggleBindings = {},
    ToggleStates = {},
    Listening = false,
    CurrentCallback = nil,
    ListeningFrame = nil,
    ListeningConnections = {},
    ActiveListeners = {}
}

function KeybindManager:Bind(KeyCode, Callback)
    if self.Bindings[KeyCode] then
        self.Bindings[KeyCode]:Disconnect()
    end

    self.Bindings[KeyCode] = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.KeyCode == KeyCode then
            local Success, Result = pcall(Callback)
            if not Success then
                warn("Keybind callback error:", Result)
            end
        end
    end)
end

function KeybindManager:BindToggle(KeyCode, ToggleObject, Callback)
    if self.ToggleBindings[KeyCode] then
        self.ToggleBindings[KeyCode]:Disconnect()
    end

    if self.ToggleStates[KeyCode] == nil then
        self.ToggleStates[KeyCode] = false
    end

    self.ToggleBindings[KeyCode] = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.KeyCode == KeyCode then
            self.ToggleStates[KeyCode] = not self.ToggleStates[KeyCode]

            if ToggleObject and typeof(ToggleObject.SetValue) == "function" then
                local Success, Result = pcall(ToggleObject.SetValue, ToggleObject, self.ToggleStates[KeyCode])
                if not Success then
                    warn("Toggle keybind setValue error:", Result)
                end
            end

            if Callback then
                local Success, Result = pcall(Callback, self.ToggleStates[KeyCode])
                if not Success then
                    warn("Toggle keybind callback error:", Result)
                end
            end
        end
    end)
end

function KeybindManager:StartListening(Callback, Frame)
    if self.Listening then
        self:StopListening()
    end

    self.Listening = true
    self.CurrentCallback = Callback
    self.ListeningFrame = Frame

    if Frame then
        Frame.Text = "Press any key..."
        Frame.TextColor3 = Theme.Primary
    end

    self:ClearConnections()

    local KeyConnection = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.UserInputType == Enum.UserInputType.Keyboard then
            self:FinishListening(Input.KeyCode)
        end
    end)

    local MouseConnection = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed then
            local InputType = Input.UserInputType
            if InputType == Enum.UserInputType.MouseButton1 or
               InputType == Enum.UserInputType.MouseButton2 or
               InputType == Enum.UserInputType.MouseButton3 then
                self:FinishListening(InputType)
            end
        end
    end)

    table.insert(self.ListeningConnections, KeyConnection)
    table.insert(self.ListeningConnections, MouseConnection)
end

function KeybindManager:FinishListening(InputCode)
    self.Listening = false
    self:ClearConnections()

    if self.ListeningFrame then
        if InputCode then
            local DisplayText = tostring(InputCode):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
            self.ListeningFrame.Text = DisplayText
        else
            self.ListeningFrame.Text = "None"
        end
        self.ListeningFrame.TextColor3 = Theme.TextPrimary
    end

    if self.CurrentCallback and InputCode then
        local Success, Result = pcall(self.CurrentCallback, InputCode)
        if not Success then
            warn("Keybind listener callback error:", Result)
        end
    end

    self:Cleanup()
end

function KeybindManager:StopListening()
    self.Listening = false
    self:ClearConnections()

    if self.ListeningFrame then
        self.ListeningFrame.Text = "None"
        self.ListeningFrame.TextColor3 = Theme.TextMuted
    end

    self:Cleanup()
end

function KeybindManager:ClearConnections()
    for _, Connection in pairs(self.ListeningConnections) do
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
    self.ListeningConnections = {}
end

function KeybindManager:Cleanup()
    self.CurrentCallback = nil
    self.ListeningFrame = nil
end

function KeybindManager:Unbind(KeyCode)
    if self.Bindings[KeyCode] then
        self.Bindings[KeyCode]:Disconnect()
        self.Bindings[KeyCode] = nil
    end
    if self.ToggleBindings[KeyCode] then
        self.ToggleBindings[KeyCode]:Disconnect()
        self.ToggleBindings[KeyCode] = nil
    end
    if self.ToggleStates[KeyCode] then
        self.ToggleStates[KeyCode] = nil
    end
end

function KeybindManager:UnbindAll()
    for _, Connection in pairs(self.Bindings) do
        Connection:Disconnect()
    end
    for _, Connection in pairs(self.ToggleBindings) do
        Connection:Disconnect()
    end
    self.Bindings = {}
    self.ToggleBindings = {}
    self.ToggleStates = {}
    self:StopListening()
end

local DropdownManager = {
    OpenDropdown = nil,
    AllDropdowns = {}
}

function DropdownManager:Register(Dropdown)
    table.insert(self.AllDropdowns, Dropdown)
end

function DropdownManager:CloseAll()
    for _, Dropdown in pairs(self.AllDropdowns) do
        if Dropdown and Dropdown.Close then
            Dropdown.Close()
        end
    end
    self.OpenDropdown = nil
end

function DropdownManager:SetOpen(Dropdown)
    self:CloseAll()
    self.OpenDropdown = Dropdown
end

local function CreateTween(Object, TweenInfoData, Properties)
    return TweenService:Create(Object, TweenInfoData, Properties)
end

local function AddCorner(Frame, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius or ScalingManager:GetScaledValue(12))
    Corner.Parent = Frame
    return Corner
end

local function AddStroke(Frame, Thickness, Color, Transparency)
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = Thickness or ScalingManager:GetScaledValue(1)
    Stroke.Color = Color or Theme.Border
    Stroke.Transparency = Transparency or 0
    Stroke.Parent = Frame
    return Stroke
end

local function AddGlow(Frame, Color, Size, Transparency)
    local Glow = Instance.new("Frame")
    Glow.Name = "GlowEffect"
    Glow.Size = UDim2.new(1, Size * 2, 1, Size * 2)
    Glow.Position = UDim2.new(0, -Size, 0, -Size)
    Glow.BackgroundColor3 = Color or Theme.BorderGlow
    Glow.BackgroundTransparency = Transparency or 0.8
    Glow.BorderSizePixel = 0
    Glow.ZIndex = Frame.ZIndex - 1
    Glow.Parent = Frame.Parent or Frame
    AddCorner(Glow, (Size or 20) + 10)
    return Glow
end

local function AddShadow(Frame, Offset, Blur, Color, Transparency)
    local Shadow = Instance.new("Frame")
    Shadow.Name = "ShadowEffect"
    Shadow.Size = UDim2.new(1, Blur * 2, 1, Blur * 2)
    Shadow.Position = UDim2.new(0, Offset.X - Blur, 0, Offset.Y - Blur)
    Shadow.BackgroundColor3 = Color or Theme.Shadow
    Shadow.BackgroundTransparency = Transparency or 0.7
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = Frame.ZIndex - 2
    Shadow.Parent = Frame.Parent or Frame
    AddCorner(Shadow, Blur + 5)
    return Shadow
end

local function AddGradient(Frame, ColorSequenceValue, Rotation, Transparency)
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequenceValue
    Gradient.Rotation = Rotation or 90
    if Transparency then
        Gradient.Transparency = Transparency
    end
    Gradient.Parent = Frame
    return Gradient
end

local function CreateRipple(Frame, Position)
    local Ripple = Instance.new("Frame")
    Ripple.Name = "RippleEffect"
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0, Position.X, 0, Position.Y)
    Ripple.BackgroundColor3 = Theme.Primary
    Ripple.BackgroundTransparency = 0.7
    Ripple.BorderSizePixel = 0
    Ripple.ZIndex = Frame.ZIndex + 10
    Ripple.ClipsDescendants = true
    Ripple.Parent = Frame
    AddCorner(Ripple, 1000)

    local MaxSize = math.max(Frame.AbsoluteSize.X, Frame.AbsoluteSize.Y) * 2.5
    local Tween = CreateTween(Ripple, Animations.Normal, {
        Size = UDim2.new(0, MaxSize, 0, MaxSize),
        Position = UDim2.new(0, Position.X - MaxSize / 2, 0, Position.Y - MaxSize / 2),
        BackgroundTransparency = 1
    })

    Tween:Play()
    Tween.Completed:Connect(function()
        Ripple:Destroy()
    end)

    return Ripple
end

local function AddHoverEffect(Frame, HoverColor, NormalColor)
    local NormalBg = NormalColor or Frame.BackgroundColor3
    local HoverBg = HoverColor or Theme.SurfaceHover

    Frame.MouseEnter:Connect(function()
        CreateTween(Frame, Animations.Fast, {BackgroundColor3 = HoverBg}):Play()
    end)

    Frame.MouseLeave:Connect(function()
        CreateTween(Frame, Animations.Fast, {BackgroundColor3 = NormalBg}):Play()
    end)
end

local function AddClickEffect(Frame, Callback)
    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            local Position = Vector2.new(Input.Position.X - Frame.AbsolutePosition.X, Input.Position.Y - Frame.AbsolutePosition.Y)
            CreateRipple(Frame, Position)
            if Callback then
                local Success, Result = pcall(Callback)
                if not Success then
                    warn("Click effect callback error:", Result)
                end
            end
        end
    end)
end

local TerminScriptsLib = {}
TerminScriptsLib.__index = TerminScriptsLib

function TerminScriptsLib.new(Title, Config)
    local Self = setmetatable({}, TerminScriptsLib)

    Config = Config or {}
    Self.Title = Title or "Termin Scripts V3"
    Self.Theme = Config.Theme or "default"
    Self.GlowEffects = Config.GlowEffects ~= false
    Self.Animations = Config.Animations ~= false
    Self.KeybindToggle = Config.KeybindToggle or Enum.KeyCode.RightControl

    ScalingManager:CalculateScale()

    Self.Tabs = {}
    Self.CurrentTab = nil
    Self.IsVisible = true
    Self.IsMinimized = false
    Self.IsMaximized = false
    Self.OriginalSize = nil
    Self.OriginalPosition = nil
    Self.IsDragging = false

    Self:CreateMainGui()
    Self:SetupControls()
    Self:SetupDragging()
    Self:SetupKeybinds()
    Self:SetupScaling()

    return Self
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

    AddCorner(self.MainFrame, 30 * Scale)
    AddStroke(self.MainFrame, 2 * Scale, Theme.BorderGlow, 0.2)

    self:CreateHeader()
    self:CreateContentArea()
end

function TerminScriptsLib:CreateHeader()
    local Scale = ScalingManager.CurrentScale

    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 90 * Scale)
    self.Header.BackgroundColor3 = Theme.Surface
    self.Header.BackgroundTransparency = Theme.GlassSecondary
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.MainFrame

    AddCorner(self.Header, 30 * Scale)
    AddStroke(self.Header, 1 * Scale, Theme.BorderLight, 0.4)

    local HeaderGradient = AddGradient(self.Header, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(0.25, Theme.Secondary),
        ColorSequenceKeypoint.new(0.5, Theme.Accent),
        ColorSequenceKeypoint.new(0.75, Theme.Secondary),
        ColorSequenceKeypoint.new(1, Theme.Primary)
    }, 45, NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 0.1)
    })

    if self.Animations then
        local GradientTween = CreateTween(HeaderGradient, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 405
        })
        GradientTween:Play()
    end

    local AvatarContainer = Instance.new("Frame")
    AvatarContainer.Size = UDim2.new(0, 70 * Scale, 0, 70 * Scale)
    AvatarContainer.Position = UDim2.new(0, 25 * Scale, 0, 10 * Scale)
    AvatarContainer.BackgroundColor3 = Theme.Card
    AvatarContainer.BackgroundTransparency = 0.1
    AvatarContainer.BorderSizePixel = 0
    AvatarContainer.Parent = self.Header
    AddCorner(AvatarContainer, 20 * Scale)
    AddStroke(AvatarContainer, 2 * Scale, Theme.Primary, 0.3)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(1, -8 * Scale, 1, -8 * Scale)
    Avatar.Position = UDim2.new(0, 4 * Scale, 0, 4 * Scale)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png"
    Avatar.Parent = AvatarContainer
    AddCorner(Avatar, 18 * Scale)

    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(1, -320 * Scale, 1, 0)
    TitleContainer.Position = UDim2.new(0, 110 * Scale, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = self.Header

    TouchManager:EnableDrag(self.MainFrame, TitleContainer)

    local TitleLayout = Instance.new("UIListLayout")
    TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TitleLayout.Padding = UDim.new(0, 5 * Scale)
    TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TitleLayout.Parent = TitleContainer

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 35 * Scale)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Theme.TextPrimary
    self.TitleLabel.TextSize = 28 * Scale
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.LayoutOrder = 1
    self.TitleLabel.Parent = TitleContainer

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(1, 0, 0, 20 * Scale)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "v3.0.0 - (Game Name) - discord.gg/KkzMrTzSF4"
    VersionLabel.TextColor3 = Theme.TextSecondary
    VersionLabel.TextSize = 14 * Scale
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.LayoutOrder = 2
    VersionLabel.Parent = TitleContainer

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 16 * Scale)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Online - " .. Player.Name
    StatusLabel.TextColor3 = Theme.Success
    StatusLabel.TextSize = 12 * Scale
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.LayoutOrder = 3
    StatusLabel.Parent = TitleContainer

    self:CreateControlButtons()
end

function TerminScriptsLib:CreateControlButtons()
    local Scale = ScalingManager.CurrentScale
    local ButtonSize = 35 * Scale
    local Spacing = 10 * Scale

    self.MinimizeBtn = self:CreateControlButton("─", Theme.Warning,
        UDim2.new(1, -(ButtonSize * 3 + Spacing * 2 + 25 * Scale), 0.5, -ButtonSize / 2), ButtonSize)

    self.MaximizeBtn = self:CreateControlButton("□", Theme.Info,
        UDim2.new(1, -(ButtonSize * 2 + Spacing + 25 * Scale), 0.5, -ButtonSize / 2), ButtonSize)

    self.CloseBtn = self:CreateControlButton("×", Theme.Error,
        UDim2.new(1, -(ButtonSize + 25 * Scale), 0.5, -ButtonSize / 2), ButtonSize)
end

function TerminScriptsLib:CreateControlButton(Text, Color, Position, Size)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, Size, 0, Size)
    Button.Position = Position
    Button.BackgroundColor3 = Color
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Theme.TextPrimary
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = Size * 0.5
    Button.ZIndex = 10
    Button.Parent = self.Header

    AddCorner(Button, Size * 0.3)
    AddStroke(Button, 1, Color:lerp(Theme.TextPrimary, 0.3), 0.3)

    Button.MouseEnter:Connect(function()
        local HoverTween = CreateTween(Button, Animations.Fast, {
            BackgroundColor3 = Color:lerp(Theme.TextPrimary, 0.15),
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, Size * 1.05, 0, Size * 1.05)
        })
        HoverTween:Play()
    end)

    Button.MouseLeave:Connect(function()
        local NormalTween = CreateTween(Button, Animations.Fast, {
            BackgroundColor3 = Color,
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, Size, 0, Size)
        })
        NormalTween:Play()
    end)

    Button.MouseButton1Down:Connect(function()
        CreateRipple(Button, Vector2.new(Size / 2, Size / 2))
    end)

    return Button
end

function TerminScriptsLib:CreateContentArea()
    local Scale = ScalingManager.CurrentScale

    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -50 * Scale, 1, -140 * Scale)
    self.ContentArea.Position = UDim2.new(0, 25 * Scale, 0, 115 * Scale)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Parent = self.MainFrame

    self:CreateTabNavigation()

    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Size = UDim2.new(1, 0, 1, -80 * Scale)
    self.PageContainer.Position = UDim2.new(0, 0, 0, 75 * Scale)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Parent = self.ContentArea
end

function TerminScriptsLib:CreateTabNavigation()
    local Scale = ScalingManager.CurrentScale

    self.TabNav = Instance.new("Frame")
    self.TabNav.Size = UDim2.new(1, 0, 0, 70 * Scale)
    self.TabNav.BackgroundColor3 = Theme.Card
    self.TabNav.BackgroundTransparency = Theme.GlassSecondary
    self.TabNav.BorderSizePixel = 0
    self.TabNav.Parent = self.ContentArea

    AddCorner(self.TabNav, 20 * Scale)
    AddStroke(self.TabNav, 1 * Scale, Theme.BorderLight, 0.4)

    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Size = UDim2.new(1, -20 * Scale, 1, -10 * Scale)
    self.TabContainer.Position = UDim2.new(0, 10 * Scale, 0, 5 * Scale)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.ScrollBarThickness = 0
    self.TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabContainer.Parent = self.TabNav

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 15 * Scale)
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Parent = self.TabContainer

    TabLayout.Changed:Connect(function()
        self.TabContainer.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 30 * Scale, 0, 0)
    end)
end

function TerminScriptsLib:CreateTab(Name, Icon, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale

    local Tab = {
        Name = Name,
        Icon = Icon or "📄",
        Config = Config,
        Button = nil,
        Page = nil,
        Sections = {},
        Active = false,
        LayoutOrder = #self.Tabs + 1,
        Gui = self
    }

    local TextSize = TextService:GetTextSize(Name, 16 * Scale, Enum.Font.GothamSemibold, Vector2.new(1000, 1000))
    local ButtonWidth = TextSize.X + (Icon and 60 or 40) * Scale

    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Name .. "Tab"
    Tab.Button.Size = UDim2.new(0, ButtonWidth, 0, 60 * Scale)
    Tab.Button.BackgroundColor3 = Theme.Surface
    Tab.Button.BackgroundTransparency = 0.3
    Tab.Button.BorderSizePixel = 0
    Tab.Button.Text = ""
    Tab.Button.LayoutOrder = Tab.LayoutOrder
    Tab.Button.Parent = self.TabContainer

    AddCorner(Tab.Button, 15 * Scale)
    AddStroke(Tab.Button, 1 * Scale, Theme.Border, 0.5)

    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, -20 * Scale, 1, -10 * Scale)
    TabContent.Position = UDim2.new(0, 10 * Scale, 0, 5 * Scale)
    TabContent.BackgroundTransparency = 1
    TabContent.Parent = Tab.Button

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Horizontal
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8 * Scale)
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.Parent = TabContent

    if Icon then
        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 24 * Scale, 0, 24 * Scale)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = Icon
        IconLabel.TextColor3 = Theme.TextSecondary
        IconLabel.TextSize = 18 * Scale
        IconLabel.Font = Enum.Font.GothamBold
        IconLabel.LayoutOrder = 1
        IconLabel.Parent = TabContent
    end

    local TabText = Instance.new("TextLabel")
    TabText.Size = UDim2.new(0, TextSize.X, 0, 24 * Scale)
    TabText.BackgroundTransparency = 1
    TabText.Text = Name
    TabText.TextColor3 = Theme.TextSecondary
    TabText.TextSize = 16 * Scale
    TabText.Font = Enum.Font.GothamSemibold
    TabText.LayoutOrder = 2
    TabText.Parent = TabContent

    Tab.Page = Instance.new("ScrollingFrame")
    Tab.Page.Name = Name .. "Page"
    Tab.Page.Size = UDim2.new(1, 0, 1, 0)
    Tab.Page.BackgroundTransparency = 1
    Tab.Page.BorderSizePixel = 0
    Tab.Page.ScrollBarThickness = 8 * Scale
    Tab.Page.ScrollBarImageColor3 = Theme.Primary
    Tab.Page.ScrollBarImageTransparency = 0.3
    Tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.Page.Visible = false
    Tab.Page.Parent = self.PageContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 20 * Scale)
    PageLayout.Parent = Tab.Page

    PageLayout.Changed:Connect(function()
        Tab.Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 40 * Scale)
    end)

    Tab.Button.MouseEnter:Connect(function()
        if not Tab.Active then
            local HoverTween = CreateTween(Tab.Button, Animations.Fast, {
                BackgroundColor3 = Theme.CardHover,
                BackgroundTransparency = 0.1
            })
            HoverTween:Play()

            local TextTween = CreateTween(TabText, Animations.Fast, {
                TextColor3 = Theme.TextPrimary
            })
            TextTween:Play()

            if Icon then
                local IconTween = CreateTween(TabContent:FindFirstChild("TextLabel"), Animations.Fast, {
                    TextColor3 = Theme.Primary
                })
                IconTween:Play()
            end
        end
    end)

    Tab.Button.MouseLeave:Connect(function()
        if not Tab.Active then
            local NormalTween = CreateTween(Tab.Button, Animations.Fast, {
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.3
            })
            NormalTween:Play()

            local TextTween = CreateTween(TabText, Animations.Fast, {
                TextColor3 = Theme.TextSecondary
            })
            TextTween:Play()

            if Icon then
                local IconTween = CreateTween(TabContent:FindFirstChild("TextLabel"), Animations.Fast, {
                    TextColor3 = Theme.TextSecondary
                })
                IconTween:Play()
            end
        end
    end)

    Tab.Button.MouseButton1Click:Connect(function()
        CreateRipple(Tab.Button, Vector2.new(Tab.Button.AbsoluteSize.X / 2, Tab.Button.AbsoluteSize.Y / 2))
        self:SwitchTab(Tab)
    end)

    function Tab:CreateSection(SectionName, Description, SectionConfig)
        return self.Gui:CreateSection(self, SectionName, Description, SectionConfig)
    end

    function Tab:TSButton(ButtonConfig)
        local Section = self.Sections[#self.Sections]
        if not Section then
            Section = self:CreateSection("Default Section")
        end
        return self.Gui:TSButton(Section, ButtonConfig)
    end

    function Tab:TSToggle(ToggleConfig)
        local Section = self.Sections[#self.Sections]
        if not Section then
            Section = self:CreateSection("Default Section")
        end
        return self.Gui:TSToggle(Section, ToggleConfig)
    end

    function Tab:TSKeyBind(KeyConfig)
        local Section = self.Sections[#self.Sections]
        if not Section then
            Section = self:CreateSection("Default Section")
        end
        return self.Gui:TSKeyBind(Section, KeyConfig)
    end

    function Tab:TSDropdown(DropConfig)
        local Section = self.Sections[#self.Sections]
        if not Section then
            Section = self:CreateSection("Default Section")
        end
        return self.Gui:TSDropdown(Section, DropConfig)
    end

    function Tab:TSColorPicker(ColorConfig)
        local Section = self.Sections[#self.Sections]
        if not Section then
            Section = self:CreateSection("Default Section")
        end
        return self.Gui:TSColorPicker(Section, ColorConfig)
    end

    function Tab:TSSlider(SliderConfig)
        local Section = self.Sections[#self.Sections]
        if not Section then
            Section = self:CreateSection("Default Section")
        end
        return self.Gui:TSSlider(Section, SliderConfig)
    end

    function Tab:TSTextBox(TextConfig)
        local Section = self.Sections[#self.Sections]
        if not Section then
            Section = self:CreateSection("Default Section")
        end
        return self.Gui:TSTextBox(Section, TextConfig)
    end

    table.insert(self.Tabs, Tab)

    if #self.Tabs == 1 then
        self:SwitchTab(Tab)
    end

    return Tab
end

function TerminScriptsLib:SwitchTab(TargetTab)
    for _, Tab in pairs(self.Tabs) do
        if Tab == TargetTab then
            Tab.Active = true
            Tab.Page.Visible = true

            local ActiveTween = CreateTween(Tab.Button, Animations.Fast, {
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.1
            })
            ActiveTween:Play()

            local ActiveStroke = Tab.Button:FindFirstChild("UIStroke")
            if ActiveStroke then
                local StrokeTween = CreateTween(ActiveStroke, Animations.Fast, {
                    Color = Theme.PrimaryGlow,
                    Transparency = 0.2
                })
                StrokeTween:Play()
            end
        else
            Tab.Active = false
            Tab.Page.Visible = false

            local InactiveTween = CreateTween(Tab.Button, Animations.Fast, {
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.3
            })
            InactiveTween:Play()

            local InactiveStroke = Tab.Button:FindFirstChild("UIStroke")
            if InactiveStroke then
                local StrokeTween = CreateTween(InactiveStroke, Animations.Fast, {
                    Color = Theme.Border,
                    Transparency = 0.5
                })
                StrokeTween:Play()
            end
        end
    end
    self.CurrentTab = TargetTab
end

function TerminScriptsLib:CreateSection(Tab, Name, Description, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale

    local Section = {
        Name = Name,
        Description = Description,
        Config = Config,
        Frame = nil,
        Elements = {},
        Expanded = true,
        LayoutOrder = #Tab.Sections + 1,
        Tab = Tab
    }

    Section.Frame = Instance.new("Frame")
    Section.Frame.Name = Name .. "Section"
    Section.Frame.Size = UDim2.new(1, 0, 0, 80 * Scale)
    Section.Frame.BackgroundColor3 = Theme.Card
    Section.Frame.BackgroundTransparency = Theme.GlassLight
    Section.Frame.BorderSizePixel = 0
    Section.Frame.LayoutOrder = Section.LayoutOrder
    Section.Frame.Parent = Tab.Page

    AddCorner(Section.Frame, 20 * Scale)
    AddStroke(Section.Frame, 1 * Scale, Theme.BorderLight, 0.4)

    local SectionHeader = Instance.new("Frame")
    SectionHeader.Name = "Header"
    SectionHeader.Size = UDim2.new(1, 0, 0, 80 * Scale)
    SectionHeader.BackgroundTransparency = 1
    SectionHeader.Parent = Section.Frame

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -100 * Scale, 0, 30 * Scale)
    SectionTitle.Position = UDim2.new(0, 25 * Scale, 0, 15 * Scale)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = Name
    SectionTitle.TextColor3 = Theme.TextPrimary
    SectionTitle.TextSize = 18 * Scale
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionHeader

    if Description then
        local SectionDesc = Instance.new("TextLabel")
        SectionDesc.Size = UDim2.new(1, -100 * Scale, 0, 20 * Scale)
        SectionDesc.Position = UDim2.new(0, 25 * Scale, 0, 45 * Scale)
        SectionDesc.BackgroundTransparency = 1
        SectionDesc.Text = Description
        SectionDesc.TextColor3 = Theme.TextSecondary
        SectionDesc.TextSize = 14 * Scale
        SectionDesc.Font = Enum.Font.Gotham
        SectionDesc.TextXAlignment = Enum.TextXAlignment.Left
        SectionDesc.Parent = SectionHeader
    end

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -50 * Scale, 0, 200 * Scale)
    ContentContainer.Position = UDim2.new(0, 25 * Scale, 0, 90 * Scale)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Visible = true
    ContentContainer.Parent = Section.Frame

    Section.ContentContainer = ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 15 * Scale)
    ContentLayout.Parent = ContentContainer

    local function UpdateSectionSize()
        local ContentHeight = ContentLayout.AbsoluteContentSize.Y + 50 * Scale
        local TotalHeight = 80 * Scale + ContentHeight + 25 * Scale

        Section.Frame.Size = UDim2.new(1, 0, 0, TotalHeight)
        ContentContainer.Size = UDim2.new(1, -50 * Scale, 0, ContentHeight)
    end

    ContentLayout.Changed:Connect(UpdateSectionSize)

    spawn(function()
        wait(0.1)
        UpdateSectionSize()
    end)

    AddHoverEffect(Section.Frame, Theme.CardHover, Theme.Card)

    function Section:TSButton(ButtonConfig)
        return self.Tab.Gui:TSButton(self, ButtonConfig)
    end

    function Section:TSToggle(ToggleConfig)
        return self.Tab.Gui:TSToggle(self, ToggleConfig)
    end

    function Section:TSKeyBind(KeyConfig)
        return self.Tab.Gui:TSKeyBind(self, KeyConfig)
    end

    function Section:TSDropdown(DropConfig)
        return self.Tab.Gui:TSDropdown(self, DropConfig)
    end

    function Section:TSColorPicker(ColorConfig)
        return self.Tab.Gui:TSColorPicker(self, ColorConfig)
    end

    function Section:TSSlider(SliderConfig)
        return self.Tab.Gui:TSSlider(self, SliderConfig)
    end

    function Section:TSTextBox(TextConfig)
        return self.Tab.Gui:TSTextBox(self, TextConfig)
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

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "TSButton"
    ButtonFrame.Size = UDim2.new(1, 0, 0, 60 * Scale)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.LayoutOrder = #Section.Elements + 1
    ButtonFrame.Parent = Section.ContentContainer

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color
    Button.BackgroundTransparency = 0.1
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = ButtonFrame

    AddCorner(Button, 15 * Scale)
    AddStroke(Button, 2 * Scale, Color:lerp(Theme.TextPrimary, 0.3), 0.3)

    local ButtonContent = Instance.new("Frame")
    ButtonContent.Size = UDim2.new(1, -40 * Scale, 1, 0)
    ButtonContent.Position = UDim2.new(0, 20 * Scale, 0, 0)
    ButtonContent.BackgroundTransparency = 1
    ButtonContent.Parent = Button

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Horizontal
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10 * Scale)
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.Parent = ButtonContent

    if Icon then
        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 24 * Scale, 0, 24 * Scale)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = Icon
        IconLabel.TextColor3 = Theme.TextPrimary
        IconLabel.TextSize = 20 * Scale
        IconLabel.Font = Enum.Font.GothamBold
        IconLabel.LayoutOrder = 1
        IconLabel.Parent = ButtonContent
    end

    local ButtonText = Instance.new("TextLabel")
    ButtonText.Size = UDim2.new(0, 200 * Scale, 0, 30 * Scale)
    ButtonText.BackgroundTransparency = 1
    ButtonText.Text = Text
    ButtonText.TextColor3 = Theme.TextPrimary
    ButtonText.TextSize = 16 * Scale
    ButtonText.Font = Enum.Font.GothamSemibold
    ButtonText.LayoutOrder = 2
    ButtonText.Parent = ButtonContent

    Button.MouseEnter:Connect(function()
        local HoverTween = CreateTween(Button, Animations.Fast, {
            BackgroundColor3 = Color:lerp(Theme.TextPrimary, 0.1),
            BackgroundTransparency = 0.05
        })
        HoverTween:Play()
    end)

    Button.MouseLeave:Connect(function()
        local NormalTween = CreateTween(Button, Animations.Fast, {
            BackgroundColor3 = Color,
            BackgroundTransparency = 0.1
        })
        NormalTween:Play()
    end)

    Button.MouseButton1Click:Connect(function()
        CreateRipple(Button, Vector2.new(Button.AbsoluteSize.X / 2, Button.AbsoluteSize.Y / 2))
        local Success, Result = pcall(Callback)
        if not Success then
            warn("Button callback error:", Result)
        end
    end)

    table.insert(Section.Elements, ButtonFrame)

    return {
        Element = ButtonFrame,
        SetText = function(NewText)
            ButtonText.Text = NewText
        end,
        SetColor = function(NewColor)
            Color = NewColor
            Button.BackgroundColor3 = NewColor
        end,
        SetCallback = function(NewCallback)
            Callback = NewCallback
        end
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
    ToggleFrame.Size = UDim2.new(1, 0, 0, 60 * Scale)
    ToggleFrame.BackgroundColor3 = Theme.Surface
    ToggleFrame.BackgroundTransparency = Theme.GlassLight
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.LayoutOrder = #Section.Elements + 1
    ToggleFrame.Parent = Section.ContentContainer

    AddCorner(ToggleFrame, 15 * Scale)
    AddStroke(ToggleFrame, 1 * Scale, Theme.Border, 0.4)

    local HasKeybind = Keybind ~= nil
    local RightOffset = HasKeybind and -180 * Scale or -100 * Scale
    local TextRightPadding = HasKeybind and -200 * Scale or -120 * Scale

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(1, TextRightPadding, 1, 0)
    ToggleText.Position = UDim2.new(0, 20 * Scale, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = Text
    ToggleText.TextColor3 = Theme.TextPrimary
    ToggleText.TextSize = 16 * Scale
    ToggleText.Font = Enum.Font.GothamSemibold
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame

    local KeybindBtn, KeybindText
    if HasKeybind then
        KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Size = UDim2.new(0, 60 * Scale, 0, 35 * Scale)
        KeybindBtn.Position = UDim2.new(1, -180 * Scale, 0.5, -17.5 * Scale)
        KeybindBtn.BackgroundColor3 = Theme.KeybindGrey
        KeybindBtn.BackgroundTransparency = 0.1
        KeybindBtn.BorderSizePixel = 0
        KeybindBtn.Text = ""
        KeybindBtn.Parent = ToggleFrame

        AddCorner(KeybindBtn, 12 * Scale)
        AddStroke(KeybindBtn, 2 * Scale, Theme.Primary, 0.4)

        AddGradient(KeybindBtn, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.KeybindGrey),
            ColorSequenceKeypoint.new(1, Theme.Card)
        }, 45)

        KeybindText = Instance.new("TextLabel")
        KeybindText.Size = UDim2.new(1, 0, 1, 0)
        KeybindText.BackgroundTransparency = 1
        KeybindText.Text = CurrentKeybind and CurrentKeybind.Name or "None"
        KeybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeybindText.TextSize = 10 * Scale
        KeybindText.Font = Enum.Font.GothamBold
        KeybindText.TextScaled = true
        KeybindText.Parent = KeybindBtn
    end

    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Size = UDim2.new(0, 80 * Scale, 0, 40 * Scale)
    ToggleSwitch.Position = UDim2.new(1, RightOffset + 40, 0.5, -20 * Scale)
    ToggleSwitch.BackgroundColor3 = CurrentValue and Theme.Primary or Theme.Card
    ToggleSwitch.BorderSizePixel = 0
    ToggleSwitch.Parent = ToggleFrame

    AddCorner(ToggleSwitch, 20 * Scale)
    AddStroke(ToggleSwitch, 2 * Scale, CurrentValue and Theme.PrimaryGlow or Theme.BorderLight, 0.3)

    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Size = UDim2.new(0, 32 * Scale, 0, 32 * Scale)
    ToggleKnob.Position = UDim2.new(0, CurrentValue and 44 * Scale or 4 * Scale, 0.5, -16 * Scale)
    ToggleKnob.BackgroundColor3 = Theme.TextPrimary
    ToggleKnob.BorderSizePixel = 0
    ToggleKnob.Parent = ToggleSwitch

    AddCorner(ToggleKnob, 16 * Scale)
    AddStroke(ToggleKnob, 1 * Scale, Theme.BorderLight, 0.2)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleSwitch

    local function UpdateToggle()
        local SwitchColor = CurrentValue and Theme.Primary or Theme.Card
        local StrokeColor = CurrentValue and Theme.PrimaryGlow or Theme.BorderLight
        local KnobPosition = CurrentValue and 44 * Scale or 4 * Scale

        local SwitchTween = CreateTween(ToggleSwitch, Animations.Fast, {
            BackgroundColor3 = SwitchColor
        })
        SwitchTween:Play()

        local StrokeTween = CreateTween(ToggleSwitch.UIStroke, Animations.Fast, {
            Color = StrokeColor
        })
        StrokeTween:Play()

        local KnobTween = CreateTween(ToggleKnob, Animations.Elastic, {
            Position = UDim2.new(0, KnobPosition, 0.5, -16 * Scale)
        })
        KnobTween:Play()

        local Success, Result = pcall(Callback, CurrentValue)
        if not Success then
            warn("Toggle callback error:", Result)
        end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        CurrentValue = not CurrentValue
        UpdateToggle()
        CreateRipple(ToggleSwitch, Vector2.new(40 * Scale, 20 * Scale))
    end)

    if HasKeybind then
        ToggleSwitch.Position = UDim2.new(1, RightOffset + 93, 0.5, -20 * Scale)
    else
        ToggleSwitch.Position = UDim2.new(1, RightOffset, 0.5, -20 * Scale)
    end

    if HasKeybind then
        local Listening = false

        if CurrentKeybind then
            KeybindManager:Bind(CurrentKeybind, function()
                CurrentValue = not CurrentValue
                UpdateToggle()
            end)
        end

        KeybindBtn.MouseButton1Click:Connect(function()
            if Listening then return end

            Listening = true
            KeybindText.Text = "..."
            KeybindBtn.BackgroundColor3 = Theme.Primary

            local Connection
            Connection = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if CurrentKeybind then
                        KeybindManager:Unbind(CurrentKeybind)
                    end

                    CurrentKeybind = Input.KeyCode
                    KeybindText.Text = Input.KeyCode.Name

                    KeybindManager:Bind(CurrentKeybind, function()
                        CurrentValue = not CurrentValue
                        UpdateToggle()
                    end)

                    KeybindBtn.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
                    Listening = false
                    Connection:Disconnect()
                end
            end)
        end)
    end

    ToggleBtn.MouseEnter:Connect(function()
        local HoverTween = CreateTween(ToggleKnob, Animations.Fast, {
            Size = UDim2.new(0, 36 * Scale, 0, 36 * Scale),
            Position = UDim2.new(0, CurrentValue and 42 * Scale or 2 * Scale, 0.5, -18 * Scale)
        })
        HoverTween:Play()
    end)

    ToggleBtn.MouseLeave:Connect(function()
        local NormalTween = CreateTween(ToggleKnob, Animations.Fast, {
            Size = UDim2.new(0, 32 * Scale, 0, 32 * Scale),
            Position = UDim2.new(0, CurrentValue and 44 * Scale or 4 * Scale, 0.5, -16 * Scale)
        })
        NormalTween:Play()
    end)

    AddHoverEffect(ToggleFrame, Theme.SurfaceHover, Theme.Surface)

    table.insert(Section.Elements, ToggleFrame)

    return {
        Element = ToggleFrame,
        GetValue = function()
            return CurrentValue
        end,
        SetValue = function(Value)
            CurrentValue = Value
            UpdateToggle()
        end,
        Toggle = function()
            CurrentValue = not CurrentValue
            UpdateToggle()
        end,
        SetCallback = function(NewCallback)
            Callback = NewCallback
        end
    }
end

function TerminScriptsLib:TSKeyBind(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale

    local Text = Config.Text or "KeyBind"
    local Default = Config.Default
    local Callback = Config.Callback or function() end

    local CurrentKeybind = Default

    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = "TSKeyBind"
    KeybindFrame.Size = UDim2.new(1, 0, 0, 60 * Scale)
    KeybindFrame.BackgroundColor3 = Theme.Surface
    KeybindFrame.BackgroundTransparency = Theme.GlassLight
    KeybindFrame.BorderSizePixel = 0
    KeybindFrame.LayoutOrder = #Section.Elements + 1
    KeybindFrame.Parent = Section.ContentContainer

    AddCorner(KeybindFrame, 15 * Scale)
    AddStroke(KeybindFrame, 1 * Scale, Theme.Border, 0.4)

    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Size = UDim2.new(1, -160 * Scale, 1, 0)
    KeybindLabel.Position = UDim2.new(0, 20 * Scale, 0, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = Text
    KeybindLabel.TextColor3 = Theme.TextPrimary
    KeybindLabel.TextSize = 16 * Scale
    KeybindLabel.Font = Enum.Font.GothamSemibold
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeybindLabel.Parent = KeybindFrame

    local KeybindBtn = Instance.new("TextButton")
    KeybindBtn.Size = UDim2.new(0, 92 * Scale, 0, 40 * Scale)
    KeybindBtn.Position = UDim2.new(1, -107 * Scale, 0.5, -20 * Scale)
    KeybindBtn.BackgroundColor3 = Theme.KeybindGrey
    KeybindBtn.BackgroundTransparency = 0.1
    KeybindBtn.BorderSizePixel = 0
    KeybindBtn.Text = ""
    KeybindBtn.Parent = KeybindFrame

    AddCorner(KeybindBtn, 12 * Scale)
    AddStroke(KeybindBtn, 2 * Scale, Theme.Primary, 0.4)

    AddGradient(KeybindBtn, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.KeybindGrey),
        ColorSequenceKeypoint.new(1, Theme.Card)
    }, 45)

    local KeybindBtnText = Instance.new("TextLabel")
    KeybindBtnText.Size = UDim2.new(1, 0, 1, 0)
    KeybindBtnText.BackgroundTransparency = 1
    KeybindBtnText.Text = CurrentKeybind and tostring(CurrentKeybind):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "") or "None"
    KeybindBtnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindBtnText.TextSize = 10 * Scale
    KeybindBtnText.Font = Enum.Font.GothamBold
    KeybindBtnText.TextScaled = true
    KeybindBtnText.Parent = KeybindBtn

    local Listening = false

    local function UpdateKeybindDisplay()
        if Listening then
            KeybindBtnText.Text = "Press any key..."
            KeybindBtnText.TextColor3 = Color3.fromRGB(255, 255, 255)

            local PulseTween = CreateTween(KeybindBtn, Animations.Breathe, {
                BackgroundColor3 = Theme.Warning:lerp(Theme.TextPrimary, 0.7)
            })
            PulseTween:Play()
        else
            KeybindBtnText.Text = CurrentKeybind and tostring(CurrentKeybind):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "") or "None"
            KeybindBtnText.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindBtn.BackgroundColor3 = Theme.KeybindGrey
        end
    end

    KeybindBtn.MouseButton1Click:Connect(function()
        if not Listening then
            Listening = true
            UpdateKeybindDisplay()

            KeybindManager:StartListening(function(KeyCode)
                if CurrentKeybind then
                    KeybindManager:Unbind(CurrentKeybind)
                end

                CurrentKeybind = KeyCode
                if CurrentKeybind then
                    KeybindManager:Bind(CurrentKeybind, function()
                        local Success, Result = pcall(Callback, CurrentKeybind)
                        if not Success then
                            warn("KeyBind press callback error:", Result)
                        end
                    end)
                    local Success, Result = pcall(Callback, CurrentKeybind)
                    if not Success then
                        warn("KeyBind change callback error:", Result)
                    end
                end

                Listening = false
                UpdateKeybindDisplay()
            end, KeybindBtn)

            CreateRipple(KeybindBtn, Vector2.new(KeybindBtn.AbsoluteSize.X / 2, KeybindBtn.AbsoluteSize.Y / 2))
        end
    end)

    KeybindBtn.MouseEnter:Connect(function()
        if not Listening then
            local HoverTween = CreateTween(KeybindBtn, Animations.Fast, {
                BackgroundColor3 = Theme.CardHover,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            })
            HoverTween:Play()
        end
    end)

    KeybindBtn.MouseLeave:Connect(function()
        if not Listening then
            local NormalTween = CreateTween(KeybindBtn, Animations.Fast, {
                BackgroundColor3 = Theme.KeybindGrey,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            })
            NormalTween:Play()
        end
    end)

    if CurrentKeybind then
        KeybindManager:Bind(CurrentKeybind, function()
            local Success, Result = pcall(Callback, CurrentKeybind)
            if not Success then
                warn("KeyBind press callback error:", Result)
            end
        end)
    end

    AddHoverEffect(KeybindFrame, Theme.SurfaceHover, Theme.Surface)

    table.insert(Section.Elements, KeybindFrame)

    return {
        Element = KeybindFrame,
        GetKeybind = function()
            return CurrentKeybind
        end,
        SetKeybind = function(KeyCode)
            if CurrentKeybind then
                KeybindManager:Unbind(CurrentKeybind)
            end
            CurrentKeybind = KeyCode
            if CurrentKeybind then
                KeybindManager:Bind(CurrentKeybind, function()
                    local Success, Result = pcall(Callback, CurrentKeybind)
                    if not Success then
                        warn("KeyBind press callback error:", Result)
                    end
                end)
            end
            UpdateKeybindDisplay()
        end,
        SetCallback = function(NewCallback)
            Callback = NewCallback
            if CurrentKeybind then
                KeybindManager:Unbind(CurrentKeybind)
                KeybindManager:Bind(CurrentKeybind, function()
                    local Success, Result = pcall(Callback, CurrentKeybind)
                    if not Success then
                        warn("KeyBind press callback error:", Result)
                    end
                end)
            end
        end
    }
end

function TerminScriptsLib:TSDropdown(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale

    local Text = Config.Text or "Dropdown"
    local Options = Config.Options or {"Option 1", "Option 2", "Option 3"}
    local Callback = Config.Callback or function() end
    local MultiSelect = Config.MultiSelect or false
    local MaxVisible = Config.MaxVisible or 5
    local Default = Config.Default

    local SelectedOptions = {}
    local IsOpen = false

    if Default then
        if MultiSelect then
            SelectedOptions = type(Default) == "table" and Default or {Default}
        else
            SelectedOptions = {Default}
        end
    end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "TSDropdown"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 60 * Scale)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.LayoutOrder = #Section.Elements + 1
    DropdownFrame.Parent = Section.ContentContainer

    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, 0, 0, 60 * Scale)
    DropdownBtn.BackgroundColor3 = Theme.Surface
    DropdownBtn.BackgroundTransparency = Theme.GlassLight
    DropdownBtn.BorderSizePixel = 0
    DropdownBtn.Text = ""
    DropdownBtn.Active = true
    DropdownBtn.Selectable = true
    DropdownBtn.Parent = DropdownFrame

    AddCorner(DropdownBtn, 15 * Scale)
    AddStroke(DropdownBtn, 1 * Scale, Theme.Border, 0.4)

    local DropContent = Instance.new("Frame")
    DropContent.Size = UDim2.new(1, -40 * Scale, 1, 0)
    DropContent.Position = UDim2.new(0, 20 * Scale, 0, 0)
    DropContent.BackgroundTransparency = 1
    DropContent.Parent = DropdownBtn

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Horizontal
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContentLayout.Parent = DropContent

    local DropText = Instance.new("TextLabel")
    DropText.Size = UDim2.new(1, -40 * Scale, 1, 0)
    DropText.BackgroundTransparency = 1
    DropText.Text = Text
    DropText.TextColor3 = Theme.TextPrimary
    DropText.TextSize = 16 * Scale
    DropText.Font = Enum.Font.GothamSemibold
    DropText.TextXAlignment = Enum.TextXAlignment.Left
    DropText.LayoutOrder = 1
    DropText.Parent = DropContent

    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Size = UDim2.new(0, 150 * Scale, 1, 0)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = #SelectedOptions > 0 and (MultiSelect and table.concat(SelectedOptions, ", ") or SelectedOptions[1]) or "None"
    ValueDisplay.TextColor3 = Theme.TextSecondary
    ValueDisplay.TextSize = 14 * Scale
    ValueDisplay.Font = Enum.Font.Gotham
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValueDisplay.LayoutOrder = 2
    ValueDisplay.Parent = DropContent

    local DropArrow = Instance.new("TextLabel")
    DropArrow.Size = UDim2.new(0, 24 * Scale, 0, 24 * Scale)
    DropArrow.BackgroundTransparency = 1
    DropArrow.Text = "▼"
    DropArrow.TextColor3 = Theme.TextSecondary
    DropArrow.TextSize = 14 * Scale
    DropArrow.Font = Enum.Font.GothamBold
    DropArrow.LayoutOrder = 3
    DropArrow.Parent = DropContent

    local VisibleItems = math.min(#Options, MaxVisible)
    local ListHeight = VisibleItems * 45 * Scale + 10 * Scale

    local DropdownList = nil
    local DropdownOpen = false

    local function UpdateDisplay()
        if #SelectedOptions > 0 then
            ValueDisplay.Text = MultiSelect and table.concat(SelectedOptions, ", ") or SelectedOptions[1]
            ValueDisplay.TextColor3 = Theme.TextPrimary
        else
            ValueDisplay.Text = "None"
            ValueDisplay.TextColor3 = Theme.TextMuted
        end
    end

    local function CreateDropdownOptions()
        if DropdownList then return end

        local Blocker = Instance.new("ImageButton")
        Blocker.Size = UDim2.new(1, 0, 1, 0)
        Blocker.Position = UDim2.new(0, 0, 0, 0)
        Blocker.BackgroundColor3 = Color3.new(0, 0, 0)
        Blocker.BackgroundTransparency = 0.5
        Blocker.BorderSizePixel = 0
        Blocker.ZIndex = 999
        Blocker.AutoButtonColor = false
        Blocker.Parent = self.ScreenGui

        DropdownList = Instance.new("Frame")
        DropdownList.Size = UDim2.new(0, 300 * Scale, 0, math.min(ListHeight + 80 * Scale, 400 * Scale))
        DropdownList.Position = UDim2.new(0.5, -150 * Scale, 0.5, -200 * Scale)
        DropdownList.BackgroundColor3 = Theme.Card
        DropdownList.BackgroundTransparency = 0.05
        DropdownList.BorderSizePixel = 0
        DropdownList.ZIndex = 1000
        DropdownList.Parent = Blocker

        AddCorner(DropdownList, 20 * Scale)
        AddStroke(DropdownList, 2 * Scale, Theme.Primary, 0.3)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -60 * Scale, 0, 40 * Scale)
        TitleLabel.Position = UDim2.new(0, 20 * Scale, 0, 10 * Scale)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = Text
        TitleLabel.TextColor3 = Theme.TextPrimary
        TitleLabel.TextSize = 18 * Scale
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = DropdownList

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30 * Scale, 0, 30 * Scale)
        CloseBtn.Position = UDim2.new(1, -40 * Scale, 0, 15 * Scale)
        CloseBtn.BackgroundColor3 = Theme.Error
        CloseBtn.BackgroundTransparency = 0.2
        CloseBtn.BorderSizePixel = 0
        CloseBtn.Text = "×"
        CloseBtn.TextColor3 = Theme.TextPrimary
        CloseBtn.TextSize = 18 * Scale
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.Parent = DropdownList

        AddCorner(CloseBtn, 15 * Scale)

        CloseBtn.MouseButton1Click:Connect(function()
            Blocker:Destroy()
            DropdownList = nil
            DropdownOpen = false
        end)

        Blocker.MouseButton1Click:Connect(function()
            Blocker:Destroy()
            DropdownList = nil
            DropdownOpen = false
        end)

        local ListScroll = Instance.new("ScrollingFrame")
        ListScroll.Size = UDim2.new(1, -20 * Scale, 1, -70 * Scale)
        ListScroll.Position = UDim2.new(0, 10 * Scale, 0, 60 * Scale)
        ListScroll.BackgroundTransparency = 1
        ListScroll.BorderSizePixel = 0
        ListScroll.ScrollBarThickness = 6 * Scale
        ListScroll.ScrollBarImageColor3 = Theme.Primary
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, #Options * 50 * Scale)
        ListScroll.Parent = DropdownList

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 2 * Scale)
        ListLayout.Parent = ListScroll

        for I, Option in ipairs(Options) do
            local OptionBtn = Instance.new("TextButton")
            OptionBtn.Size = UDim2.new(1, -10 * Scale, 0, 45 * Scale)
            OptionBtn.Position = UDim2.new(0, 5 * Scale, 0, (I - 1) * 50 * Scale)
            OptionBtn.BackgroundColor3 = Theme.Surface
            OptionBtn.BackgroundTransparency = 0.3
            OptionBtn.BorderSizePixel = 0
            OptionBtn.Text = Option
            OptionBtn.TextColor3 = Theme.TextPrimary
            OptionBtn.TextSize = 16 * Scale
            OptionBtn.Font = Enum.Font.GothamMedium
            OptionBtn.Parent = ListScroll

            AddCorner(OptionBtn, 12 * Scale)

            local IsSelected = false
            for _, Selected in ipairs(SelectedOptions) do
                if Selected == Option then
                    IsSelected = true
                    break
                end
            end

            if IsSelected then
                OptionBtn.BackgroundColor3 = Theme.Primary
                OptionBtn.BackgroundTransparency = 0.1
            end

            OptionBtn.MouseButton1Click:Connect(function()
                if MultiSelect then
                    local Found = false
                    for J, Selected in ipairs(SelectedOptions) do
                        if Selected == Option then
                            table.remove(SelectedOptions, J)
                            Found = true
                            break
                        end
                    end

                    if not Found then
                        table.insert(SelectedOptions, Option)
                    end

                    local IsNowSelected = false
                    for _, Selected in ipairs(SelectedOptions) do
                        if Selected == Option then
                            IsNowSelected = true
                            break
                        end
                    end

                    OptionBtn.BackgroundColor3 = IsNowSelected and Theme.Primary or Theme.Surface
                    OptionBtn.BackgroundTransparency = IsNowSelected and 0.1 or 0.3
                else
                    SelectedOptions = {Option}
                    Blocker:Destroy()
                    DropdownList = nil
                    DropdownOpen = false
                end

                UpdateDisplay()
                local Success, Result = pcall(Callback, MultiSelect and SelectedOptions or SelectedOptions[1])
                if not Success then
                    warn("Dropdown callback error:", Result)
                end
            end)

            AddHoverEffect(OptionBtn, Theme.SurfaceHover, Theme.Surface)
        end
    end

    local function OpenDropdown()
        if DropdownOpen then return end
        DropdownOpen = true
        CreateDropdownOptions()

        local ArrowTween = CreateTween(DropArrow, Animations.Fast, {
            Rotation = 180,
            TextColor3 = Theme.Primary
        })
        ArrowTween:Play()
    end

    local function CloseDropdown()
        if not DropdownOpen then return end
        DropdownOpen = false
        if DropdownList then
            DropdownList.Parent:Destroy()
            DropdownList = nil
        end

        local ArrowTween = CreateTween(DropArrow, Animations.Fast, {
            Rotation = 0,
            TextColor3 = Theme.TextSecondary
        })
        ArrowTween:Play()
    end

    DropdownBtn.MouseButton1Click:Connect(function()
        CreateRipple(DropdownBtn, Vector2.new(DropdownBtn.AbsoluteSize.X / 2, DropdownBtn.AbsoluteSize.Y / 2))
        if DropdownOpen then
            CloseDropdown()
        else
            OpenDropdown()
        end
    end)

    AddHoverEffect(DropdownBtn, Theme.SurfaceHover, Theme.Surface)

    DropdownManager:Register({Close = CloseDropdown})

    table.insert(Section.Elements, DropdownFrame)

    return {
        Element = DropdownFrame,
        GetSelected = function()
            return MultiSelect and SelectedOptions or SelectedOptions[1]
        end,
        SetSelected = function(Value)
            SelectedOptions = MultiSelect and (type(Value) == "table" and Value or {Value}) or {Value}
            UpdateDisplay()
        end,
        AddOption = function(Option)
            table.insert(Options, Option)
        end,
        Close = CloseDropdown
    }
end

function TerminScriptsLib:TSColorPicker(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale

    local Text = Config.Text or "Color Picker"
    local Default = Config.Default or Color3.fromRGB(255, 255, 255)
    local Callback = Config.Callback or function() end
    local ShowAlpha = Config.Alpha or false

    local CurrentColor = Default
    local CurrentHue = 0
    local CurrentSat = 1
    local CurrentVal = 1
    local CurrentAlpha = 1

    local function RgbToHsv(R, G, B)
        local Max = math.max(R, G, B)
        local Min = math.min(R, G, B)
        local Delta = Max - Min

        local H = 0
        if Delta > 0 then
            if Max == R then
                H = ((G - B) / Delta) % 6
            elseif Max == G then
                H = (B - R) / Delta + 2
            elseif Max == B then
                H = (R - G) / Delta + 4
            end
            H = H / 6
        end

        local S = Max == 0 and 0 or Delta / Max
        local V = Max

        return H, S, V
    end

    local function HsvToRgb(H, S, V)
        local C = V * S
        local X = C * (1 - math.abs((H * 6) % 2 - 1))
        local M = V - C

        local R, G, B = 0, 0, 0
        if H < 1 / 6 then
            R, G, B = C, X, 0
        elseif H < 2 / 6 then
            R, G, B = X, C, 0
        elseif H < 3 / 6 then
            R, G, B = 0, C, X
        elseif H < 4 / 6 then
            R, G, B = 0, X, C
        elseif H < 5 / 6 then
            R, G, B = X, 0, C
        else
            R, G, B = C, 0, X
        end

        return Color3.new(R + M, G + M, B + M)
    end

    CurrentHue, CurrentSat, CurrentVal = RgbToHsv(CurrentColor.R, CurrentColor.G, CurrentColor.B)

    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = "TSColorPicker"
    ColorFrame.Size = UDim2.new(1, 0, 0, 60 * Scale)
    ColorFrame.BackgroundColor3 = Theme.Surface
    ColorFrame.BackgroundTransparency = Theme.GlassLight
    ColorFrame.BorderSizePixel = 0
    ColorFrame.LayoutOrder = #Section.Elements + 1
    ColorFrame.Parent = Section.ContentContainer

    AddCorner(ColorFrame, 15 * Scale)
    AddStroke(ColorFrame, 1 * Scale, Theme.Border, 0.4)

    local ColorText = Instance.new("TextLabel")
    ColorText.Size = UDim2.new(1, -200 * Scale, 1, 0)
    ColorText.Position = UDim2.new(0, 20 * Scale, 0, 0)
    ColorText.BackgroundTransparency = 1
    ColorText.Text = Text
    ColorText.TextColor3 = Theme.TextPrimary
    ColorText.TextSize = 16 * Scale
    ColorText.Font = Enum.Font.GothamSemibold
    ColorText.TextXAlignment = Enum.TextXAlignment.Left
    ColorText.Parent = ColorFrame

    local ColorValueLabel = Instance.new("TextLabel")
    ColorValueLabel.Size = UDim2.new(0, 80 * Scale, 1, 0)
    ColorValueLabel.Position = UDim2.new(1, -165 * Scale, 0, 0)
    ColorValueLabel.BackgroundTransparency = 1
    ColorValueLabel.Text = string.format("%d,%d,%d", CurrentColor.R * 255, CurrentColor.G * 255, CurrentColor.B * 255)
    ColorValueLabel.TextColor3 = Theme.TextSecondary
    ColorValueLabel.TextSize = 14 * Scale
    ColorValueLabel.Font = Enum.Font.Gotham
    ColorValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ColorValueLabel.Parent = ColorFrame

    local ColorBtn = Instance.new("TextButton")
    ColorBtn.Size = UDim2.new(0, 60 * Scale, 0, 40 * Scale)
    ColorBtn.Position = UDim2.new(1, -75 * Scale, 0.5, -20 * Scale)
    ColorBtn.BackgroundColor3 = CurrentColor
    ColorBtn.BorderSizePixel = 0
    ColorBtn.Text = ""
    ColorBtn.Parent = ColorFrame

    AddCorner(ColorBtn, 12 * Scale)
    AddStroke(ColorBtn, 2 * Scale, Theme.Primary, 0.4)

    local ColorPickerFrame = nil
    local PickerOpen = false

    local function UpdateColor()
        CurrentColor = HsvToRgb(CurrentHue, CurrentSat, CurrentVal)
        ColorBtn.BackgroundColor3 = CurrentColor
        ColorValueLabel.Text = string.format("%d,%d,%d", math.floor(CurrentColor.R * 255), math.floor(CurrentColor.G * 255), math.floor(CurrentColor.B * 255))

        local Success, Result = pcall(Callback, CurrentColor)
        if not Success then
            warn("Color picker callback error:", Result)
        end
    end

    local function CreateColorPickerFrame()
        if ColorPickerFrame then return end

        local Blocker = Instance.new("Frame")
        Blocker.Size = UDim2.new(1, 0, 1, 0)
        Blocker.BackgroundColor3 = Color3.new(0, 0, 0)
        Blocker.BackgroundTransparency = 0.5
        Blocker.BorderSizePixel = 0
        Blocker.ZIndex = 999
        Blocker.Active = true
        Blocker.Parent = self.ScreenGui

        ColorPickerFrame = Instance.new("Frame")
        ColorPickerFrame.Size = UDim2.new(0, 300 * Scale, 0, 350 * Scale)
        ColorPickerFrame.Position = UDim2.new(0.5, -150 * Scale, 0.5, -175 * Scale)
        ColorPickerFrame.BackgroundColor3 = Theme.Card
        ColorPickerFrame.BackgroundTransparency = 0.05
        ColorPickerFrame.BorderSizePixel = 0
        ColorPickerFrame.ZIndex = 1000
        ColorPickerFrame.Parent = Blocker

        AddCorner(ColorPickerFrame, 20 * Scale)
        AddStroke(ColorPickerFrame, 2 * Scale, Theme.Primary, 0.3)

        local SatValPicker = Instance.new("Frame")
        SatValPicker.Size = UDim2.new(1, -40 * Scale, 0, 200 * Scale)
        SatValPicker.Position = UDim2.new(0, 20 * Scale, 0, 20 * Scale)
        SatValPicker.BackgroundColor3 = HsvToRgb(CurrentHue, 1, 1)
        SatValPicker.BorderSizePixel = 0
        SatValPicker.Parent = ColorPickerFrame

        AddCorner(SatValPicker, 10 * Scale)

        local WhiteGradient = Instance.new("UIGradient")
        WhiteGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }
        WhiteGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }
        WhiteGradient.Rotation = 0
        WhiteGradient.Parent = SatValPicker

        local BlackOverlay = Instance.new("Frame")
        BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
        BlackOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
        BlackOverlay.BorderSizePixel = 0
        BlackOverlay.Parent = SatValPicker

        local BlackGradient = Instance.new("UIGradient")
        BlackGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }
        BlackGradient.Rotation = 90
        BlackGradient.Parent = BlackOverlay

        local HueSlider = Instance.new("Frame")
        HueSlider.Size = UDim2.new(1, -40 * Scale, 0, 30 * Scale)
        HueSlider.Position = UDim2.new(0, 20 * Scale, 0, 240 * Scale)
        HueSlider.BorderSizePixel = 0
        HueSlider.Parent = ColorPickerFrame

        AddCorner(HueSlider, 15 * Scale)

        local HueGradient = AddGradient(HueSlider, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }, 0)

        local SatValSelector = Instance.new("Frame")
        SatValSelector.Size = UDim2.new(0, 10 * Scale, 0, 10 * Scale)
        SatValSelector.Position = UDim2.new(CurrentSat, -5 * Scale, 1 - CurrentVal, -5 * Scale)
        SatValSelector.BackgroundColor3 = Color3.new(1, 1, 1)
        SatValSelector.BorderSizePixel = 0
        SatValSelector.ZIndex = SatValPicker.ZIndex + 1
        SatValSelector.Parent = SatValPicker

        AddCorner(SatValSelector, 5 * Scale)
        AddStroke(SatValSelector, 2 * Scale, Color3.new(0, 0, 0), 0)

        local HueSelector = Instance.new("Frame")
        HueSelector.Size = UDim2.new(0, 6 * Scale, 1, 0)
        HueSelector.Position = UDim2.new(CurrentHue, -3 * Scale, 0, 0)
        HueSelector.BackgroundColor3 = Color3.new(1, 1, 1)
        HueSelector.BorderSizePixel = 0
        HueSelector.ZIndex = HueSlider.ZIndex + 1
        HueSelector.Parent = HueSlider

        AddCorner(HueSelector, 3 * Scale)
        AddStroke(HueSelector, 1 * Scale, Color3.new(0, 0, 0), 0)

        local SatValDragging = false
        local HueDragging = false

        SatValPicker.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SatValDragging = true
            end
        end)

        HueSlider.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                HueDragging = true
            end
        end)

        UserInputService.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SatValDragging then
                    local Pos = SatValPicker.AbsolutePosition
                    local Size = SatValPicker.AbsoluteSize
                    local MousePos = Input.Position

                    CurrentSat = math.clamp((MousePos.X - Pos.X) / Size.X, 0, 1)
                    CurrentVal = 1 - math.clamp((MousePos.Y - Pos.Y) / Size.Y, 0, 1)

                    SatValSelector.Position = UDim2.new(CurrentSat, -5 * Scale, 1 - CurrentVal, -5 * Scale)
                    UpdateColor()
                elseif HueDragging then
                    local Pos = HueSlider.AbsolutePosition
                    local Size = HueSlider.AbsoluteSize
                    local MousePos = Input.Position

                    CurrentHue = math.clamp((MousePos.X - Pos.X) / Size.X, 0, 1)
                    HueSelector.Position = UDim2.new(CurrentHue, -3 * Scale, 0, 0)
                    SatValPicker.BackgroundColor3 = HsvToRgb(CurrentHue, 1, 1)
                    UpdateColor()
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SatValDragging = false
                HueDragging = false
            end
        end)

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30 * Scale, 0, 30 * Scale)
        CloseBtn.Position = UDim2.new(1, -40 * Scale, 0, 10 * Scale)
        CloseBtn.BackgroundColor3 = Theme.Error
        CloseBtn.BackgroundTransparency = 0.2
        CloseBtn.BorderSizePixel = 0
        CloseBtn.Text = "×"
        CloseBtn.TextColor3 = Theme.TextPrimary
        CloseBtn.TextSize = 18 * Scale
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.Parent = ColorPickerFrame

        AddCorner(CloseBtn, 15 * Scale)

        CloseBtn.MouseButton1Click:Connect(function()
            Blocker:Destroy()
            ColorPickerFrame = nil
            PickerOpen = false
        end)

        Blocker.MouseButton1Click:Connect(function()
            Blocker:Destroy()
            ColorPickerFrame = nil
            PickerOpen = false
        end)
    end

    ColorBtn.MouseButton1Click:Connect(function()
        if not PickerOpen then
            PickerOpen = true
            CreateColorPickerFrame()
        end
        CreateRipple(ColorBtn, Vector2.new(30 * Scale, 20 * Scale))
    end)

    ColorBtn.MouseEnter:Connect(function()
        local HoverTween = CreateTween(ColorBtn, Animations.Fast, {
            Size = UDim2.new(0, 64 * Scale, 0, 44 * Scale),
            Position = UDim2.new(1, -77 * Scale, 0.5, -22 * Scale)
        })
        HoverTween:Play()
    end)

    ColorBtn.MouseLeave:Connect(function()
        local NormalTween = CreateTween(ColorBtn, Animations.Fast, {
            Size = UDim2.new(0, 60 * Scale, 0, 40 * Scale),
            Position = UDim2.new(1, -75 * Scale, 0.5, -20 * Scale)
        })
        NormalTween:Play()
    end)

    AddHoverEffect(ColorFrame, Theme.SurfaceHover, Theme.Surface)

    table.insert(Section.Elements, ColorFrame)

    return {
        Element = ColorFrame,
        GetColor = function()
            return CurrentColor
        end,
        SetColor = function(Color)
            CurrentColor = Color
            CurrentHue, CurrentSat, CurrentVal = RgbToHsv(Color.R, Color.G, Color.B)
            UpdateColor()
        end,
        SetCallback = function(NewCallback)
            Callback = NewCallback
        end
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

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "TSSlider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 80 * Scale)
    SliderFrame.BackgroundColor3 = Theme.Surface
    SliderFrame.BackgroundTransparency = Theme.GlassLight
    SliderFrame.BorderSizePixel = 0
    SliderFrame.LayoutOrder = #Section.Elements + 1
    SliderFrame.Parent = Section.ContentContainer

    AddCorner(SliderFrame, 15 * Scale)
    AddStroke(SliderFrame, 1 * Scale, Theme.Border, 0.4)

    local SliderText = Instance.new("TextLabel")
    SliderText.Size = UDim2.new(1, -120 * Scale, 0, 30 * Scale)
    SliderText.Position = UDim2.new(0, 20 * Scale, 0, 10 * Scale)
    SliderText.BackgroundTransparency = 1
    SliderText.Text = Text
    SliderText.TextColor3 = Theme.TextPrimary
    SliderText.TextSize = 16 * Scale
    SliderText.Font = Enum.Font.GothamSemibold
    SliderText.TextXAlignment = Enum.TextXAlignment.Left
    SliderText.Parent = SliderFrame

    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Size = UDim2.new(0, 80 * Scale, 0, 30 * Scale)
    ValueDisplay.Position = UDim2.new(1, -100 * Scale, 0, 10 * Scale)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = tostring(CurrentValue) .. Suffix
    ValueDisplay.TextColor3 = Theme.TextSecondary
    ValueDisplay.TextSize = 14 * Scale
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValueDisplay.Parent = SliderFrame

    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -40 * Scale, 0, 8 * Scale)
    SliderTrack.Position = UDim2.new(0, 20 * Scale, 0, 50 * Scale)
    SliderTrack.BackgroundColor3 = Theme.Card
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    AddCorner(SliderTrack, 4 * Scale)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((CurrentValue - Min) / (Max - Min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Theme.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    AddCorner(SliderFill, 4 * Scale)

    local SliderThumb = Instance.new("Frame")
    SliderThumb.Size = UDim2.new(0, 20 * Scale, 0, 20 * Scale)
    SliderThumb.Position = UDim2.new((CurrentValue - Min) / (Max - Min), -10 * Scale, 0.5, -10 * Scale)
    SliderThumb.BackgroundColor3 = Theme.TextPrimary
    SliderThumb.BorderSizePixel = 0
    SliderThumb.Parent = SliderTrack
    SliderThumb.ZIndex = SliderTrack.ZIndex + 5
    AddCorner(SliderThumb, 10 * Scale)
    AddStroke(SliderThumb, 2 * Scale, Theme.Primary, 0.3)

    local function UpdateSlider()
        local Percentage = (CurrentValue - Min) / (Max - Min)

        local FillTween = CreateTween(SliderFill, Animations.Fast, {
            Size = UDim2.new(Percentage, 0, 1, 0)
        })
        FillTween:Play()

        local ThumbTween = CreateTween(SliderThumb, Animations.Fast, {
            Position = UDim2.new(Percentage, -10 * Scale, 0.5, -10 * Scale)
        })
        ThumbTween:Play()

        ValueDisplay.Text = tostring(CurrentValue) .. Suffix

        local Success, Result = pcall(Callback, CurrentValue)
        if not Success then
            warn("Slider callback error:", Result)
        end
    end

    local Dragging = false
    local TrackConnection

    local function HandleInput(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true

            TrackConnection = UserInputService.InputChanged:Connect(function(Input2)
                if (Input2.UserInputType == Enum.UserInputType.MouseMovement or Input2.UserInputType == Enum.UserInputType.Touch) and Dragging then
                    local TrackPos = SliderTrack.AbsolutePosition.X
                    local TrackSize = SliderTrack.AbsoluteSize.X
                    local MousePos = Input2.Position.X

                    local Percentage = math.clamp((MousePos - TrackPos) / TrackSize, 0, 1)
                    local RawValue = Min + (Max - Min) * Percentage
                    CurrentValue = math.floor(RawValue / Increment + 0.5) * Increment
                    CurrentValue = math.clamp(CurrentValue, Min, Max)

                    UpdateSlider()
                end
            end)
        end
    end

    SliderTrack.InputBegan:Connect(HandleInput)
    SliderThumb.InputBegan:Connect(HandleInput)

    UserInputService.InputEnded:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
            Dragging = false
            if TrackConnection then
                TrackConnection:Disconnect()
                TrackConnection = nil
            end
        end
    end)

    SliderThumb.MouseEnter:Connect(function()
        local HoverTween = CreateTween(SliderThumb, Animations.Fast, {
            Size = UDim2.new(0, 24 * Scale, 0, 24 * Scale),
            Position = UDim2.new((CurrentValue - Min) / (Max - Min), -12 * Scale, 0.5, -12 * Scale)
        })
        HoverTween:Play()
    end)

    SliderThumb.MouseLeave:Connect(function()
        if not Dragging then
            local NormalTween = CreateTween(SliderThumb, Animations.Fast, {
                Size = UDim2.new(0, 20 * Scale, 0, 20 * Scale),
                Position = UDim2.new((CurrentValue - Min) / (Max - Min), -10 * Scale, 0.5, -10 * Scale)
            })
            NormalTween:Play()
        end
    end)

    AddHoverEffect(SliderFrame, Theme.SurfaceHover, Theme.Surface)

    table.insert(Section.Elements, SliderFrame)

    return {
        Element = SliderFrame,
        GetValue = function()
            return CurrentValue
        end,
        SetValue = function(Value)
            CurrentValue = math.clamp(Value, Min, Max)
            UpdateSlider()
        end,
        SetRange = function(NewMin, NewMax)
            Min = NewMin
            Max = NewMax
            CurrentValue = math.clamp(CurrentValue, Min, Max)
            UpdateSlider()
        end
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

    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = "TSTextBox"
    TextBoxFrame.Size = UDim2.new(1, 0, 0, Multiline and 100 * Scale or 60 * Scale)
    TextBoxFrame.BackgroundColor3 = Theme.Surface
    TextBoxFrame.BackgroundTransparency = Theme.GlassLight
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.LayoutOrder = #Section.Elements + 1
    TextBoxFrame.Parent = Section.ContentContainer

    AddCorner(TextBoxFrame, 15 * Scale)
    AddStroke(TextBoxFrame, 1 * Scale, Theme.Border, 0.4)

    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Size = UDim2.new(1, -40 * Scale, 0, 25 * Scale)
    TextBoxLabel.Position = UDim2.new(0, 20 * Scale, 0, 5 * Scale)
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Text = Text
    TextBoxLabel.TextColor3 = Theme.TextPrimary
    TextBoxLabel.TextSize = 14 * Scale
    TextBoxLabel.Font = Enum.Font.GothamSemibold
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextBoxLabel.Parent = TextBoxFrame

    local TextBoxInput = Instance.new("TextBox")
    TextBoxInput.Size = UDim2.new(1, -40 * Scale, 0, Multiline and 60 * Scale or 25 * Scale)
    TextBoxInput.Position = UDim2.new(0, 20 * Scale, 0, Multiline and 30 * Scale or 30 * Scale)
    TextBoxInput.BackgroundColor3 = Theme.Card
    TextBoxInput.BackgroundTransparency = 0.2
    TextBoxInput.BorderSizePixel = 0
    TextBoxInput.Text = Default
    TextBoxInput.PlaceholderText = Placeholder
    TextBoxInput.TextColor3 = Theme.TextPrimary
    TextBoxInput.PlaceholderColor3 = Theme.TextMuted
    TextBoxInput.TextSize = 14 * Scale
    TextBoxInput.Font = Enum.Font.Gotham
    TextBoxInput.TextXAlignment = Enum.TextXAlignment.Left
    TextBoxInput.TextYAlignment = Multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    TextBoxInput.MultiLine = Multiline
    TextBoxInput.TextWrapped = Multiline
    TextBoxInput.Parent = TextBoxFrame

    AddCorner(TextBoxInput, 10 * Scale)
    AddStroke(TextBoxInput, 1 * Scale, Theme.BorderLight, 0.5)

    TextBoxInput.Focused:Connect(function()
        local FocusTween = CreateTween(TextBoxInput, Animations.Fast, {
            BackgroundColor3 = Theme.CardElevated,
            BackgroundTransparency = 0.1
        })
        FocusTween:Play()

        local StrokeTween = CreateTween(TextBoxInput.UIStroke, Animations.Fast, {
            Color = Theme.Primary,
            Transparency = 0.2
        })
        StrokeTween:Play()
    end)

    TextBoxInput.FocusLost:Connect(function()
        local UnfocusTween = CreateTween(TextBoxInput, Animations.Fast, {
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.2
        })
        UnfocusTween:Play()

        local StrokeTween = CreateTween(TextBoxInput.UIStroke, Animations.Fast, {
            Color = Theme.BorderLight,
            Transparency = 0.5
        })
        StrokeTween:Play()

        local Success, Result = pcall(Callback, TextBoxInput.Text)
        if not Success then
            warn("TextBox callback error:", Result)
        end
    end)

    if NumbersOnly then
        TextBoxInput.Changed:Connect(function(Property)
            if Property == "Text" then
                local NewText = TextBoxInput.Text:gsub("[^%d%.%-]", "")
                if NewText ~= TextBoxInput.Text then
                    TextBoxInput.Text = NewText
                end
            end
        end)
    end

    AddHoverEffect(TextBoxFrame, Theme.SurfaceHover, Theme.Surface)

    table.insert(Section.Elements, TextBoxFrame)

    return {
        Element = TextBoxFrame,
        GetText = function()
            return TextBoxInput.Text
        end,
        SetText = function(NewText)
            TextBoxInput.Text = NewText
        end,
        Focus = function()
            TextBoxInput:CaptureFocus()
        end,
        ClearText = function()
            TextBoxInput.Text = ""
        end
    }
end

function TerminScriptsLib:SetupControls()
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)

    self.MaximizeBtn.MouseButton1Click:Connect(function()
        self:Maximize()
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
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
            local Delta = Input.Position - DragStart
            self.MainFrame.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

function TerminScriptsLib:SetupKeybinds()
    KeybindManager:Bind(self.KeybindToggle, function()
        self:Toggle()
    end)
end

function TerminScriptsLib:SetupScaling()
    local Connection
    Connection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        ScalingManager:CalculateScale()
        self:UpdateScaling()
    end)

    self.ScaleConnection = Connection
end

function TerminScriptsLib:UpdateScaling()
end

function TerminScriptsLib:Minimize()
    self.IsMinimized = not self.IsMinimized

    local TargetSize = self.IsMinimized and UDim2.new(0, 350 * ScalingManager.CurrentScale, 0, 90 * ScalingManager.CurrentScale) or self.OriginalSize
    local TargetTransparency = self.IsMinimized and 0.7 or Theme.GlassMain

    local SizeTween = CreateTween(self.MainFrame, Animations.Elastic, {
        Size = TargetSize,
        BackgroundTransparency = TargetTransparency
    })
    SizeTween:Play()

    self.ContentArea.Visible = not self.IsMinimized
    self.MinimizeBtn.Text = self.IsMinimized and "+" or "─"
end

function TerminScriptsLib:Maximize()
    self.IsMaximized = not self.IsMaximized

    local Camera = workspace.CurrentCamera
    local ScreenSize = Camera.ViewportSize
    local Scale = ScalingManager.CurrentScale

    local TargetSize = self.IsMaximized and UDim2.new(0, ScreenSize.X - 100 * Scale, 0, ScreenSize.Y - 100 * Scale) or self.OriginalSize
    local TargetPosition = self.IsMaximized and UDim2.new(0, 50 * Scale, 0, 50 * Scale) or self.OriginalPosition

    local Tween = CreateTween(self.MainFrame, Animations.Back, {
        Size = TargetSize,
        Position = TargetPosition
    })
    Tween:Play()

    self.MaximizeBtn.Text = self.IsMaximized and "⧉" or "□"
end

function TerminScriptsLib:Toggle()
    self.IsVisible = not self.IsVisible
    self.ScreenGui.Enabled = self.IsVisible
end

function TerminScriptsLib:Destroy()
    KeybindManager:UnbindAll()

    if self.ScaleConnection then
        self.ScaleConnection:Disconnect()
    end

    DropdownManager:CloseAll()

    if self.ScreenGui then
        local DestroyTween = CreateTween(self.MainFrame, Animations.FadeOut, {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0)
        })

        DestroyTween:Play()
        DestroyTween.Completed:Connect(function()
            self.ScreenGui:Destroy()
        end)
    end
end

return TerminScriptsLib
