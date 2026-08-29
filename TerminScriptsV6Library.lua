local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library
Library.Version = "TS V6"

local Themes = {
    White = {
        Primary = Color3.fromRGB(255,255,255),
        PrimaryHover = Color3.fromRGB(235,235,235),
        Background = Color3.fromRGB(7,8,10),
        Surface = Color3.fromRGB(13,15,18),
        Surface2 = Color3.fromRGB(18,20,24),
        SurfaceHover = Color3.fromRGB(24,27,32),
        Card = Color3.fromRGB(16,18,22),
        Border = Color3.fromRGB(43,46,52),
        BorderStrong = Color3.fromRGB(75,79,87),
        Text = Color3.fromRGB(247,247,249),
        Text2 = Color3.fromRGB(190,193,200),
        Muted = Color3.fromRGB(120,124,133),
        Danger = Color3.fromRGB(244,72,72),
        Warning = Color3.fromRGB(245,185,58),
        Info = Color3.fromRGB(92,165,255),
        Success = Color3.fromRGB(89,218,145)
    },
    Graphite = {
        Primary = Color3.fromRGB(210,215,225),
        PrimaryHover = Color3.fromRGB(235,238,245),
        Background = Color3.fromRGB(8,9,12),
        Surface = Color3.fromRGB(15,17,21),
        Surface2 = Color3.fromRGB(21,24,30),
        SurfaceHover = Color3.fromRGB(29,33,40),
        Card = Color3.fromRGB(18,21,26),
        Border = Color3.fromRGB(48,53,62),
        BorderStrong = Color3.fromRGB(84,91,104),
        Text = Color3.fromRGB(242,244,248),
        Text2 = Color3.fromRGB(188,193,202),
        Muted = Color3.fromRGB(118,124,136),
        Danger = Color3.fromRGB(244,72,72),
        Warning = Color3.fromRGB(245,185,58),
        Info = Color3.fromRGB(92,165,255),
        Success = Color3.fromRGB(89,218,145)
    }
}

local Theme = Themes.White
local ActiveDropdowns = {}

local Tween = {
    Fast = TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.34, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Fade = TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
}

local function Safe(fn,...)
    return pcall(fn,...)
end

local function New(class,parent,props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            obj[k] = v
        end
    end
    if parent then
        obj.Parent = parent
    end
    return obj
end

local function Corner(obj,radius)
    return New("UICorner",obj,{CornerRadius=UDim.new(0,radius or 10)})
end

local function Stroke(obj,color,transparency,thickness)
    return New("UIStroke",obj,{
        Color=color or Theme.Border,
        Transparency=transparency == nil and 0.5 or transparency,
        Thickness=thickness or 1
    })
end

local function Gradient(obj,a,b,rotation)
    return New("UIGradient",obj,{
        Color=ColorSequence.new(a,b or a),
        Rotation=rotation or 90
    })
end

local function Play(obj,info,props)
    if obj and obj.Parent then
        local t = TweenService:Create(obj,info,props)
        t:Play()
        return t
    end
end

local function Contrast(color)
    local luminance = color.R*0.299 + color.G*0.587 + color.B*0.114
    return luminance > 0.62 and Color3.fromRGB(10,10,12) or Color3.fromRGB(250,250,250)
end

local function Text(parent,text,size,color,font,props)
    props = props or {}
    props.BackgroundTransparency = 1
    props.Text = text or ""
    props.TextSize = size
    props.TextColor3 = color or Theme.Text
    props.Font = font or Enum.Font.Gotham
    return New("TextLabel",parent,props)
end

local function Ripple(button,position)
    local size = math.max(button.AbsoluteSize.X,button.AbsoluteSize.Y)*2
    local ripple = New("Frame",button,{
        Size=UDim2.fromOffset(0,0),
        Position=UDim2.fromOffset(position.X,position.Y),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=Color3.new(1,1,1),
        BackgroundTransparency=0.82,
        BorderSizePixel=0,
        ZIndex=button.ZIndex+5
    })
    Corner(ripple,size)
    local tween = Play(ripple,TweenInfo.new(0.42,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{
        Size=UDim2.fromOffset(size,size),
        BackgroundTransparency=1
    })
    if tween then
        tween.Completed:Connect(function()
            if ripple.Parent then ripple:Destroy() end
        end)
    end
end

local function CleanName(name)
    return tostring(name or ""):gsub("[^%w%-%_%.%s]",""):gsub("^%s+",""):gsub("%s+$","")
end

local function Serialize(value)
    if typeof(value) == "Color3" then
        return {__type="Color3",R=value.R,G=value.G,B=value.B}
    end
    if typeof(value) == "EnumItem" then
        return {__type="EnumItem",EnumType=tostring(value.EnumType):gsub("Enum%.",""),Name=value.Name}
    end
    if type(value) == "table" then
        local output = {}
        for k,v in pairs(value) do
            output[k] = Serialize(v)
        end
        return output
    end
    return value
end

local function Deserialize(value)
    if type(value) == "table" and value.__type == "Color3" then
        return Color3.new(value.R,value.G,value.B)
    end
    if type(value) == "table" and value.__type == "EnumItem" then
        local enumTable = Enum[value.EnumType]
        return enumTable and enumTable[value.Name] or nil
    end
    if type(value) == "table" then
        local output = {}
        for k,v in pairs(value) do
            output[k] = Deserialize(v)
        end
        return output
    end
    return value
end

local function HasFileApi()
    return typeof(isfile)=="function" and typeof(readfile)=="function" and typeof(writefile)=="function"
end

local function Request(options)
    local fn = (typeof(request)=="function" and request)
        or (typeof(http_request)=="function" and http_request)
        or (typeof(syn)=="table" and typeof(syn.request)=="function" and syn.request)
        or (typeof(fluxus)=="table" and typeof(fluxus.request)=="function" and fluxus.request)

    if fn then
        return Safe(fn,options)
    end

    return Safe(function()
        return game:GetService("HttpService"):RequestAsync(options)
    end)
end

local function GetHwid()
    local ok,id = Safe(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)

    if ok and id and id ~= "" then
        return id
    end

    return "UID-"..Player.UserId
end

function Library.new(title,config)
    config = config or {}

    local self = setmetatable({},Library)

    self.Title = title or "Termin Scripts"
    self.ConfigFolderName = config.ConfigFolderName or "TerminConfigs"
    self.CurrentConfigName = config.DefaultConfigName or ""
    self.AutoSaveEnabled = config.AutoSaveEnabled == true
    self.AutoLoadConfigEnabled = config.AutoLoadConfig == true
    self.AutoLoadConfigName = config.AutoLoadConfigName or ""
    self.KeybindToggle = config.KeybindToggle or Enum.KeyCode.RightControl
    self.Tabs = {}
    self.Registry = {}
    self.Connections = {}
    self.Scale = 1
    self.Visible = true
    self.Minimized = false
    self.Maximized = false
    self.Destroyed = false
    self.LoadingConfig = false

    self:_calculateScale()
    self:_createGui()
    self:_bindWindow()
    self:_bindScale()
    self:_animateIn()

    return self
end

function Library:_calculateScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1920,1080)
    local scale = math.sqrt((viewport.X/1920)*(viewport.Y/1080))

    if viewport.X < 800 then
        scale = scale*1.18
    elseif viewport.X < 1300 then
        scale = scale*1.08
    end

    self.Scale = math.clamp(scale,0.55,1.45)
end

function Library:_s(value)
    return value*self.Scale
end

function Library:_createGui()
    self.ScreenGui = New("ScreenGui",PlayerGui,{
        Name="TerminScriptsV6",
        ResetOnSpawn=false,
        IgnoreGuiInset=true,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        DisplayOrder=100
    })

    self.Main = New("Frame",self.ScreenGui,{
        Name="Window",
        Size=UDim2.fromOffset(self:_s(1040),self:_s(690)),
        Position=UDim2.fromScale(0.5,0.5),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=Theme.Background,
        BorderSizePixel=0,
        ClipsDescendants=true
    })

    Corner(self.Main,self:_s(22))
    self.MainStroke = Stroke(self.Main,Theme.BorderStrong,0.22,self:_s(1.2))
    Gradient(self.Main,Theme.Background,Theme.Surface,135)

    self.Top = New("Frame",self.Main,{
        Size=UDim2.new(1,0,0,self:_s(84)),
        BackgroundColor3=Theme.Surface,
        BackgroundTransparency=0.18,
        BorderSizePixel=0
    })

    Corner(self.Top,self:_s(22))

    local line = New("Frame",self.Top,{
        Size=UDim2.new(1,-self:_s(40),0,self:_s(1)),
        Position=UDim2.new(0,self:_s(20),1,-self:_s(1)),
        BackgroundColor3=Theme.Primary,
        BackgroundTransparency=0.58,
        BorderSizePixel=0
    })

    self:_registerTheme(line,"BackgroundColor3","Primary")

    local avatarWrap = New("Frame",self.Top,{
        Size=UDim2.fromOffset(self:_s(54),self:_s(54)),
        Position=UDim2.new(0,self:_s(16),0.5,-self:_s(27)),
        BackgroundColor3=Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(avatarWrap,self:_s(16))
    self:_registerTheme(Stroke(avatarWrap,Theme.Primary,0.55,self:_s(1.2)),"Color","Primary")

    local avatar = New("ImageLabel",avatarWrap,{
        Size=UDim2.new(1,-self:_s(6),1,-self:_s(6)),
        Position=UDim2.fromOffset(self:_s(3),self:_s(3)),
        BackgroundTransparency=1,
        Image="https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=420&height=420&format=png"
    })

    Corner(avatar,self:_s(13))

    self.TitleLabel = Text(self.Top,self.Title,22,Theme.Text,Enum.Font.GothamBold,{
        Size=UDim2.new(1,-self:_s(350),0,self:_s(28)),
        Position=UDim2.fromOffset(self:_s(84),self:_s(14)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    self.Subtitle = Text(self.Top,"V6  •  "..Player.DisplayName,11,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.new(1,-self:_s(350),0,self:_s(20)),
        Position=UDim2.fromOffset(self:_s(84),self:_s(43)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    self.StatusDot = New("Frame",self.Top,{
        Size=UDim2.fromOffset(self:_s(7),self:_s(7)),
        Position=UDim2.fromOffset(self:_s(84),self:_s(68)),
        BackgroundColor3=Theme.Success,
        BorderSizePixel=0
    })

    Corner(self.StatusDot,self:_s(4))

    self.Status = Text(self.Top,"Ready",10,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.fromOffset(self:_s(70),self:_s(16)),
        Position=UDim2.fromOffset(self:_s(96),self:_s(64)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local buttons = {
        {"−","Minimize",Theme.Warning},
        {"□","Maximize",Theme.Info},
        {"×","Close",Theme.Danger}
    }

    self.WindowButtons = {}

    for i,data in ipairs(buttons) do
        local button = New("TextButton",self.Top,{
            Name=data[2],
            Size=UDim2.fromOffset(self:_s(30),self:_s(30)),
            Position=UDim2.new(1,-self:_s(18+(3-i)*40),0.5,-self:_s(15)),
            BackgroundColor3=data[3],
            BackgroundTransparency=0.76,
            BorderSizePixel=0,
            Text=data[1],
            TextColor3=Contrast(data[3]),
            TextSize=self:_s(15),
            Font=Enum.Font.GothamBold,
            AutoButtonColor=false
        })

        Corner(button,self:_s(10))
        Stroke(button,data[3],0.35,self:_s(1))

        button.MouseEnter:Connect(function()
            Play(button,Tween.Fast,{
                BackgroundTransparency=0.42,
                Size=UDim2.fromOffset(self:_s(33),self:_s(33))
            })
        end)

        button.MouseLeave:Connect(function()
            Play(button,Tween.Fast,{
                BackgroundTransparency=0.76,
                Size=UDim2.fromOffset(self:_s(30),self:_s(30))
            })
        end)

        self.WindowButtons[data[2]] = button
    end

    self.Nav = New("Frame",self.Main,{
        Size=UDim2.new(1,-self:_s(28),0,self:_s(58)),
        Position=UDim2.fromOffset(self:_s(14),self:_s(96)),
        BackgroundColor3=Theme.Surface2,
        BackgroundTransparency=0.18,
        BorderSizePixel=0
    })

    Corner(self.Nav,self:_s(15))
    Stroke(self.Nav,Theme.Border,0.55,self:_s(1))

    self.TabList = New("ScrollingFrame",self.Nav,{
        Size=UDim2.new(1,-self:_s(12),1,-self:_s(8)),
        Position=UDim2.fromOffset(self:_s(6),self:_s(4)),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=0,
        ScrollingDirection=Enum.ScrollingDirection.X,
        AutomaticCanvasSize=Enum.AutomaticSize.X,
        CanvasSize=UDim2.new()
    })

    New("UIListLayout",self.TabList,{
        FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,self:_s(7)),
        VerticalAlignment=Enum.VerticalAlignment.Center
    })

    self.Pages = New("Frame",self.Main,{
        Size=UDim2.new(1,-self:_s(28),1,-self:_s(168)),
        Position=UDim2.fromOffset(self:_s(14),self:_s(164)),
        BackgroundTransparency=1,
        ClipsDescendants=true
    })

    self:_setupDrag(self.Top)
end

function Library:_setupDrag(handle)
    local dragging = false
    local startInput
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPosition = self.Main.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    table.insert(self.Connections,UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position-startInput
            self.Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset+delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset+delta.Y
            )
        end
    end))
end

function Library:_bindWindow()
    self.WindowButtons.Minimize.MouseButton1Click:Connect(function()
        self:Minimize()
    end)

    self.WindowButtons.Maximize.MouseButton1Click:Connect(function()
        self:Maximize()
    end)

    self.WindowButtons.Close.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    table.insert(self.Connections,UserInputService.InputBegan:Connect(function(input,gameProcessed)
        if not gameProcessed and input.KeyCode == self.KeybindToggle then
            self:Toggle()
        end
    end))
end

function Library:_bindScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    table.insert(self.Connections,camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self:_calculateScale()
    end))
end

function Library:_animateIn()
    local target = self.Main.Size
    self.Main.Size = UDim2.fromOffset(target.X.Offset*0.92,target.Y.Offset*0.92)
    self.Main.BackgroundTransparency = 1

    task.defer(function()
        Play(self.Main,Tween.Spring,{
            Size=target,
            BackgroundTransparency=0
        })
    end)
end

function Library:_registerTheme(object,property,key)
    if object then
        object:SetAttribute("TSThemeKey",key)
        object:SetAttribute("TSThemeProperty",property)
    end
end

function Library:SetTheme(name)
    Theme = Themes[name] or Themes.White

    for _,object in ipairs(self.ScreenGui:GetDescendants()) do
        local key = object:GetAttribute("TSThemeKey")
        local property = object:GetAttribute("TSThemeProperty")

        if key and property and Theme[key] then
            Safe(function()
                object[property] = Theme[key]
            end)
        end
    end

    self:Notify("Theme","Applied "..(name or "White"),"success",2)
end

function Library:RegisterElement(key,getter,setter,default)
    key = key or ("_auto_"..tostring(#self.Registry+1))

    for _,entry in ipairs(self.Registry) do
        if entry.Key == key then
            entry.Get = getter
            entry.Set = setter
            entry.Default = default
            return
        end
    end

    table.insert(self.Registry,{
        Key=key,
        Get=getter,
        Set=setter,
        Default=default
    })
end

function Library:_saveSoon()
    if self.LoadingConfig or not self.AutoSaveEnabled or self.CurrentConfigName == "" then
        return
    end

    if self.SavePending then return end
    self.SavePending = true

    task.delay(0.2,function()
        self.SavePending = false

        if self.ScreenGui and self.ScreenGui.Parent then
            self:SaveConfig()
        end
    end)
end

function Library:CreateTab(name,config)
    config = config or {}

    local tab = {
        Name=name,
        Sections={},
        Gui=self,
        Active=false
    }

    local textSize = self:_s(13)
    local textBounds = TextService:GetTextSize(name,textSize,Enum.Font.GothamSemibold,Vector2.new(1000,1000))
    local width = math.max(self:_s(78),textBounds.X+self:_s(34))

    tab.Button = New("TextButton",self.TabList,{
        Size=UDim2.fromOffset(width,self:_s(48)),
        BackgroundColor3=Theme.Surface,
        BackgroundTransparency=0.52,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false
    })

    Corner(tab.Button,self:_s(12))
    tab.Stroke = Stroke(tab.Button,Theme.Border,0.68,self:_s(1))

    tab.Label = Text(tab.Button,name,13,Theme.Muted,Enum.Font.GothamSemibold,{
        Size=UDim2.fromScale(1,1),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    tab.Bar = New("Frame",tab.Button,{
        Size=UDim2.fromOffset(0,self:_s(2)),
        Position=UDim2.new(0.5,0,1,-self:_s(3)),
        AnchorPoint=Vector2.new(0.5,0),
        BackgroundColor3=Theme.Primary,
        BorderSizePixel=0
    })

    Corner(tab.Bar,self:_s(2))
    self:_registerTheme(tab.Bar,"BackgroundColor3","Primary")

    tab.Page = New("ScrollingFrame",self.Pages,{
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=self:_s(4),
        ScrollBarImageColor3=Theme.Primary,
        ScrollBarImageTransparency=0.55,
        Visible=false,
        CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y
    })

    New("UIPadding",tab.Page,{
        PaddingTop=UDim.new(0,self:_s(8)),
        PaddingBottom=UDim.new(0,self:_s(18)),
        PaddingLeft=UDim.new(0,self:_s(2)),
        PaddingRight=UDim.new(0,self:_s(6))
    })

    New("UIListLayout",tab.Page,{
        Padding=UDim.new(0,self:_s(12)),
        SortOrder=Enum.SortOrder.LayoutOrder
    })

    tab.Button.MouseEnter:Connect(function()
        if not tab.Active then
            Play(tab.Button,Tween.Fast,{BackgroundTransparency=0.25})
        end
    end)

    tab.Button.MouseLeave:Connect(function()
        if not tab.Active then
            Play(tab.Button,Tween.Fast,{BackgroundTransparency=0.52})
        end
    end)

    tab.Button.MouseButton1Click:Connect(function()
        Ripple(tab.Button,Vector2.new(tab.Button.AbsoluteSize.X/2,tab.Button.AbsoluteSize.Y/2))
        self:SwitchTab(tab)
    end)

    function tab:CreateSection(title,description,cfg)
        return self.Gui:CreateSection(self,title,description,cfg)
    end

    local componentNames = {
        "TSButton","TSToggle","TSKeyBind","TSDropdown","TSColorPicker","TSSlider",
        "TSTextBox","TSLabel","TSProgressBar","TSSeparator","TSMultiButton",
        "TSBadgeRow","TSCheckbox","TSRadioGroup","TSNumberStepper","TSCard",
        "TSCodeBlock","TSStatDisplay","TSImage","TSSpacer","TSFileDropdown",
        "TSKeybindDisplay"
    }

    for _,componentName in ipairs(componentNames) do
        tab[componentName] = function(tabSelf,cfg)
            local section = tabSelf.Sections[#tabSelf.Sections]

            if not section then
                section = tabSelf:CreateSection("General")
            end

            return tabSelf.Gui[componentName](tabSelf.Gui,section,cfg)
        end
    end

    table.insert(self.Tabs,tab)

    if #self.Tabs == 1 then
        self:SwitchTab(tab)
    end

    return tab
end

function Library:SwitchTab(target)
    for _,tab in ipairs(self.Tabs) do
        local active = tab == target
        tab.Active = active
        tab.Page.Visible = active

        if active then
            Play(tab.Button,Tween.Fast,{
                BackgroundColor3=Theme.Primary,
                BackgroundTransparency=0.08
            })
            Play(tab.Label,Tween.Fast,{TextColor3=Contrast(Theme.Primary)})
            Play(tab.Stroke,Tween.Fast,{
                Color=Theme.Primary,
                Transparency=0.22
            })
            Play(tab.Bar,Tween.Spring,{
                Size=UDim2.fromOffset(self:_s(42),self:_s(2))
            })
        else
            Play(tab.Button,Tween.Fast,{
                BackgroundColor3=Theme.Surface,
                BackgroundTransparency=0.52
            })
            Play(tab.Label,Tween.Fast,{TextColor3=Theme.Muted})
            Play(tab.Stroke,Tween.Fast,{
                Color=Theme.Border,
                Transparency=0.68
            })
            Play(tab.Bar,Tween.Fast,{
                Size=UDim2.fromOffset(0,self:_s(2))
            })
        end
    end

    self.CurrentTab = target
end

function Library:CreateSection(tab,name,description,config)
    local section = {
        Name=name,
        Description=description,
        Elements={},
        Tab=tab,
        Gui=self,
        Expanded=true
    }

    section.Frame = New("Frame",tab.Page,{
        Size=UDim2.new(1,0,0,self:_s(78)),
        BackgroundColor3=Theme.Card,
        BackgroundTransparency=0.12,
        BorderSizePixel=0
    })

    Corner(section.Frame,self:_s(16))
    Stroke(section.Frame,Theme.Border,0.5,self:_s(1))
    Gradient(section.Frame,Theme.Card,Theme.Surface,140)

    section.Header = New("Frame",section.Frame,{
        Size=UDim2.new(1,0,0,self:_s(62)),
        BackgroundTransparency=1
    })

    New("Frame",section.Header,{
        Size=UDim2.fromOffset(self:_s(3),self:_s(28)),
        Position=UDim2.fromOffset(self:_s(14),self:_s(17)),
        BackgroundColor3=Theme.Primary,
        BorderSizePixel=0
    })

    Text(section.Header,name,15,Theme.Text,Enum.Font.GothamBold,{
        Size=UDim2.new(1,-self:_s(78),0,self:_s(23)),
        Position=UDim2.fromOffset(self:_s(26),self:_s(11)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    if description then
        Text(section.Header,description,10,Theme.Muted,Enum.Font.Gotham,{
            Size=UDim2.new(1,-self:_s(78),0,self:_s(17)),
            Position=UDim2.fromOffset(self:_s(26),self:_s(35)),
            TextXAlignment=Enum.TextXAlignment.Left
        })
    end

    local collapse = New("TextButton",section.Header,{
        Size=UDim2.fromOffset(self:_s(30),self:_s(30)),
        Position=UDim2.new(1,-self:_s(44),0.5,-self:_s(15)),
        BackgroundColor3=Theme.Surface2,
        BackgroundTransparency=0.2,
        BorderSizePixel=0,
        Text="⌃",
        TextColor3=Theme.Muted,
        TextSize=self:_s(14),
        Font=Enum.Font.GothamBold,
        AutoButtonColor=false
    })

    Corner(collapse,self:_s(9))

    section.Content = New("Frame",section.Frame,{
        Size=UDim2.new(1,-self:_s(32),0,0),
        Position=UDim2.fromOffset(self:_s(16),self:_s(67)),
        BackgroundTransparency=1,
        ClipsDescendants=true
    })

    section.Layout = New("UIListLayout",section.Content,{
        Padding=UDim.new(0,self:_s(8)),
        SortOrder=Enum.SortOrder.LayoutOrder
    })

    New("UIPadding",section.Content,{
        PaddingBottom=UDim.new(0,self:_s(14))
    })

    local function resize()
        if not section.Expanded then return end

        local height = section.Layout.AbsoluteContentSize.Y+self:_s(14)

        section.Content.Size = UDim2.new(1,-self:_s(32),0,height)
        section.Frame.Size = UDim2.new(1,0,0,self:_s(67)+height)
    end

    section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)

    collapse.MouseButton1Click:Connect(function()
        section.Expanded = not section.Expanded
        collapse.Text = section.Expanded and "⌃" or "⌄"

        if section.Expanded then
            local height = section.Layout.AbsoluteContentSize.Y+self:_s(14)
            Play(section.Content,Tween.Spring,{
                Size=UDim2.new(1,-self:_s(32),0,height)
            })
            Play(section.Frame,Tween.Spring,{
                Size=UDim2.new(1,0,0,self:_s(67)+height)
            })
        else
            Play(section.Content,Tween.Fast,{
                Size=UDim2.new(1,-self:_s(32),0,0)
            })
            Play(section.Frame,Tween.Fast,{
                Size=UDim2.new(1,0,0,self:_s(67))
            })
        end
    end)

    table.insert(tab.Sections,section)
    task.defer(resize)

    return section
end

function Library:_row(section,height,name)
    local row = New("Frame",section.Content,{
        Name=name,
        Size=UDim2.new(1,0,0,self:_s(height)),
        BackgroundColor3=Theme.Surface,
        BackgroundTransparency=0.24,
        BorderSizePixel=0,
        LayoutOrder=#section.Elements+1
    })

    Corner(row,self:_s(12))
    Stroke(row,Theme.Border,0.54,self:_s(1))

    row.MouseEnter:Connect(function()
        Play(row,Tween.Fast,{
            BackgroundColor3=Theme.SurfaceHover,
            BackgroundTransparency=0.08
        })
    end)

    row.MouseLeave:Connect(function()
        Play(row,Tween.Fast,{
            BackgroundColor3=Theme.Surface,
            BackgroundTransparency=0.24
        })
    end)

    table.insert(section.Elements,row)
    return row
end

function Library:TSButton(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Button"
    local callback=cfg.Callback or function() end
    local color=cfg.Color or Theme.Primary
    local style=cfg.Style or "filled"

    local row=self:_row(section,50,"TSButton")

    local button=New("TextButton",row,{
        Size=UDim2.fromScale(1,1),
        BackgroundColor3=style=="ghost" and Theme.Surface2 or color,
        BackgroundTransparency=style=="ghost" and 0.28 or 0.05,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false
    })

    Corner(button,self:_s(12))

    local border=Stroke(button,style=="ghost" and Theme.BorderStrong or color,0.28,self:_s(1))

    local label=Text(button,labelText,13,Contrast(style=="ghost" and Theme.Surface2 or color),Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-self:_s(30),1,0),
        Position=UDim2.fromOffset(self:_s(15),0),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    button.MouseEnter:Connect(function()
        Play(button,Tween.Fast,{
            BackgroundColor3=style=="ghost" and Theme.SurfaceHover or color:lerp(Color3.new(1,1,1),0.09)
        })
        Play(border,Tween.Fast,{Transparency=0.08})
    end)

    button.MouseLeave:Connect(function()
        Play(button,Tween.Fast,{
            BackgroundColor3=style=="ghost" and Theme.Surface2 or color
        })
        Play(border,Tween.Fast,{Transparency=0.28})
    end)

    button.MouseButton1Click:Connect(function()
        Ripple(button,Vector2.new(button.AbsoluteSize.X/2,button.AbsoluteSize.Y/2))
        Safe(callback)
    end)

    return {
        Element=row,
        SetText=function(v) label.Text=tostring(v) end,
        SetColor=function(v)
            color=v
            button.BackgroundColor3=v
            label.TextColor3=Contrast(v)
        end,
        SetCallback=function(v) callback=v end,
        SetEnabled=function(v)
            button.Active=v
            label.TextTransparency=v and 0 or 0.55
        end
    }
end

function Library:TSToggle(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Toggle"
    local value=cfg.Default==true
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSToggle:"..labelText)

    local row=self:_row(section,54,"TSToggle")

    Text(row,labelText,13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-self:_s(108),1,0),
        Position=UDim2.fromOffset(self:_s(16),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local switch=New("Frame",row,{
        Size=UDim2.fromOffset(self:_s(60),self:_s(30)),
        Position=UDim2.new(1,-self:_s(74),0.5,-self:_s(15)),
        BackgroundColor3=value and Theme.Primary or Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(switch,self:_s(15))

    local switchStroke=Stroke(switch,value and Theme.Primary or Theme.BorderStrong,0.25,self:_s(1))

    local knob=New("Frame",switch,{
        Size=UDim2.fromOffset(self:_s(22),self:_s(22)),
        Position=UDim2.fromOffset(value and self:_s(34) or self:_s(4),self:_s(4)),
        BackgroundColor3=value and Contrast(Theme.Primary) or Theme.Muted,
        BorderSizePixel=0
    })

    Corner(knob,self:_s(11))

    local function update(fire)
        local x=value and self:_s(34) or self:_s(4)

        Play(switch,Tween.Fast,{
            BackgroundColor3=value and Theme.Primary or Theme.Surface2
        })

        Play(switchStroke,Tween.Fast,{
            Color=value and Theme.Primary or Theme.BorderStrong
        })

        Play(knob,Tween.Spring,{
            Position=UDim2.fromOffset(x,self:_s(4)),
            BackgroundColor3=value and Contrast(Theme.Primary) or Theme.Muted
        })

        if fire then
            Safe(callback,value)
            self:_saveSoon()
        end
    end

    switch.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            value=not value
            update(true)
            Ripple(switch,Vector2.new(switch.AbsoluteSize.X/2,switch.AbsoluteSize.Y/2))
        end
    end)

    self:RegisterElement(key,function() return value end,function(v)
        value=v==true
        update(false)
    end,cfg.Default)

    return {
        Element=row,
        GetValue=function() return value end,
        SetValue=function(v) value=v==true update(true) end,
        Toggle=function() value=not value update(true) end,
        SetCallback=function(v) callback=v end
    }
end

function Library:TSKeyBind(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Keybind"
    local current=cfg.Default
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSKeyBind:"..labelText)

    local row=self:_row(section,52,"TSKeyBind")

    Text(row,labelText,13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-self:_s(125),1,0),
        Position=UDim2.fromOffset(self:_s(16),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local button=New("TextButton",row,{
        Size=UDim2.fromOffset(self:_s(92),self:_s(32)),
        Position=UDim2.new(1,-self:_s(106),0.5,-self:_s(16)),
        BackgroundColor3=Theme.Surface2,
        BackgroundTransparency=0.08,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false
    })

    Corner(button,self:_s(9))
    local border=Stroke(button,Theme.Primary,0.4,self:_s(1.2))

    local display=Text(button,current and current.Name or "None",11,Theme.Text,Enum.Font.GothamBold,{
        Size=UDim2.fromScale(1,1),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    local listening=false
    local bindConnection

    local function bind()
        if bindConnection then
            bindConnection:Disconnect()
        end

        if not current then return end

        bindConnection=UserInputService.InputBegan:Connect(function(input,gameProcessed)
            if not gameProcessed and input.KeyCode==current then
                Safe(callback,current)
            end
        end)
    end

    local function refresh()
        display.Text=listening and "PRESS KEY" or (current and current.Name or "None")
        display.TextColor3=listening and Contrast(Theme.Primary) or Theme.Text

        Play(button,Tween.Fast,{
            BackgroundColor3=listening and Theme.Primary or Theme.Surface2
        })

        Play(border,Tween.Fast,{
            Transparency=listening and 0.08 or 0.4
        })
    end

    button.MouseButton1Click:Connect(function()
        if listening then return end

        listening=true
        refresh()

        local listenConnection

        listenConnection=UserInputService.InputBegan:Connect(function(input,gameProcessed)
            if gameProcessed then return end

            if input.UserInputType==Enum.UserInputType.Keyboard
                or input.UserInputType==Enum.UserInputType.MouseButton1
                or input.UserInputType==Enum.UserInputType.MouseButton2
                or input.UserInputType==Enum.UserInputType.MouseButton3 then

                current=input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                listening=false
                refresh()
                bind()
                listenConnection:Disconnect()
                Safe(callback,current)
                self:_saveSoon()
            end
        end)
    end)

    bind()

    self:RegisterElement(key,function() return current end,function(v)
        if typeof(v)=="EnumItem" then
            current=v
            bind()
            refresh()
        end
    end,current)

    return {
        Element=row,
        GetKeybind=function() return current end,
        SetKeybind=function(v)
            current=v
            bind()
            refresh()
        end,
        SetCallback=function(v)
            callback=v
            bind()
        end
    }
end

function Library:TSDropdown(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Dropdown"
    local options=cfg.Options or {}
    local multi=cfg.MultiSelect==true
    local selected={}
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSDropdown:"..labelText)

    if cfg.Default~=nil then
        selected=multi and (type(cfg.Default)=="table" and cfg.Default or {cfg.Default}) or {cfg.Default}
    end

    local row=self:_row(section,54,"TSDropdown")

    Text(row,labelText,13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-self:_s(175),1,0),
        Position=UDim2.fromOffset(self:_s(16),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local valueLabel=Text(row,"None",11,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.fromOffset(self:_s(115),1),
        Position=UDim2.new(1,-self:_s(150),0,0),
        TextXAlignment=Enum.TextXAlignment.Right
    })

    local arrow=Text(row,"⌄",16,Theme.Muted,Enum.Font.GothamBold,{
        Size=UDim2.fromOffset(self:_s(24),1),
        Position=UDim2.new(1,-self:_s(31),0,0),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    local hit=New("TextButton",row,{
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false
    })

    local open=false
    local popup

    local function contains(option)
        for _,v in ipairs(selected) do
            if v==option then return true end
        end
        return false
    end

    local function refresh()
        if #selected==0 then
            valueLabel.Text="None"
            valueLabel.TextColor3=Theme.Muted
        elseif multi then
            valueLabel.Text=#selected==1 and tostring(selected[1]) or tostring(#selected).." selected"
            valueLabel.TextColor3=Theme.Primary
        else
            valueLabel.Text=tostring(selected[1])
            valueLabel.TextColor3=Theme.Primary
        end
    end

    refresh()

    local function close()
        open=false

        if popup then
            popup:Destroy()
            popup=nil
        end

        Play(arrow,Tween.Fast,{
            Rotation=0,
            TextColor3=Theme.Muted
        })

        for i=#ActiveDropdowns,1,-1 do
            if ActiveDropdowns[i]==close then
                table.remove(ActiveDropdowns,i)
            end
        end
    end

    local function openPopup()
        if open then return end

        for _,closer in ipairs(ActiveDropdowns) do
            Safe(closer)
        end

        table.clear(ActiveDropdowns)

        open=true
        table.insert(ActiveDropdowns,close)

        local camera=workspace.CurrentCamera
        local viewport=camera and camera.ViewportSize or Vector2.new(1920,1080)
        local position=row.AbsolutePosition
        local size=row.AbsoluteSize
        local width=math.max(size.X,self:_s(230))
        local height=math.min(math.max(#options*self:_s(42)+self:_s(12),self:_s(60)),self:_s(300))
        local y=position.Y+size.Y+self:_s(6)

        if y+height>viewport.Y-self:_s(8) then
            y=position.Y-height-self:_s(6)
        end

        popup=New("Frame",self.ScreenGui,{
            Size=UDim2.fromOffset(width,self:_s(8)),
            Position=UDim2.fromOffset(math.clamp(position.X,8,viewport.X-width-8),math.max(8,y)),
            BackgroundColor3=Theme.Card,
            BorderSizePixel=0,
            ZIndex=900
        })

        Corner(popup,self:_s(13))
        Stroke(popup,Theme.Primary,0.35,self:_s(1.2))

        Play(popup,Tween.Spring,{
            Size=UDim2.fromOffset(width,height)
        })

        local scroll=New("ScrollingFrame",popup,{
            Size=UDim2.new(1,-8,1,-8),
            Position=UDim2.fromOffset(4,4),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ScrollBarThickness=3,
            ScrollBarImageColor3=Theme.Primary,
            CanvasSize=UDim2.new(0,0,0,#options*self:_s(42)+8),
            ZIndex=901
        })

        New("UIListLayout",scroll,{
            Padding=UDim.new(0,self:_s(5)),
            SortOrder=Enum.SortOrder.LayoutOrder
        })

        for index,option in ipairs(options) do
            local chosen=contains(option)

            local optionButton=New("TextButton",scroll,{
                Size=UDim2.new(1,0,0,self:_s(38)),
                BackgroundColor3=chosen and Theme.Primary or Theme.Surface2,
                BackgroundTransparency=chosen and 0.06 or 0.2,
                BorderSizePixel=0,
                Text=tostring(option),
                TextColor3=chosen and Contrast(Theme.Primary) or Theme.Text,
                TextSize=self:_s(12),
                Font=Enum.Font.GothamMedium,
                AutoButtonColor=false,
                LayoutOrder=index,
                ZIndex=902
            })

            Corner(optionButton,self:_s(9))

            optionButton.MouseEnter:Connect(function()
                if not contains(option) then
                    Play(optionButton,Tween.Fast,{
                        BackgroundColor3=Theme.SurfaceHover,
                        BackgroundTransparency=0.05
                    })
                end
            end)

            optionButton.MouseLeave:Connect(function()
                if not contains(option) then
                    Play(optionButton,Tween.Fast,{
                        BackgroundColor3=Theme.Surface2,
                        BackgroundTransparency=0.2
                    })
                end
            end)

            optionButton.MouseButton1Click:Connect(function()
                if multi then
                    if contains(option) then
                        for i,v in ipairs(selected) do
                            if v==option then
                                table.remove(selected,i)
                                break
                            end
                        end
                    else
                        table.insert(selected,option)
                    end

                    local chosenNow=contains(option)

                    Play(optionButton,Tween.Fast,{
                        BackgroundColor3=chosenNow and Theme.Primary or Theme.Surface2,
                        BackgroundTransparency=chosenNow and 0.06 or 0.2
                    })

                    optionButton.TextColor3=chosenNow and Contrast(Theme.Primary) or Theme.Text
                    refresh()
                    Safe(callback,selected)
                    self:_saveSoon()
                else
                    selected={option}
                    refresh()
                    Safe(callback,option)
                    self:_saveSoon()
                    close()
                end
            end)
        end

        Play(arrow,Tween.Fast,{
            Rotation=180,
            TextColor3=Theme.Primary
        })
    end

    hit.MouseButton1Click:Connect(function()
        Ripple(row,Vector2.new(row.AbsoluteSize.X/2,row.AbsoluteSize.Y/2))

        if open then
            close()
        else
            openPopup()
        end
    end)

    self:RegisterElement(key,function()
        return multi and selected or selected[1]
    end,function(v)
        selected=multi and (type(v)=="table" and v or {v}) or {v}
        refresh()
    end,cfg.Default)

    return {
        Element=row,
        GetSelected=function() return multi and selected or selected[1] end,
        SetSelected=function(v)
            selected=multi and (type(v)=="table" and v or {v}) or {v}
            refresh()
        end,
        SetOptions=function(v)
            options=v or {}
            close()
            refresh()
        end,
        AddOption=function(v)
            table.insert(options,v)
        end,
        Close=close
    }
end

function Library:TSColorPicker(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Color"
    local color=cfg.Default or Theme.Primary
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSColorPicker:"..labelText)

    local row=self:_row(section,54,"TSColorPicker")

    Text(row,labelText,13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-self:_s(130),1,0),
        Position=UDim2.fromOffset(self:_s(16),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local rgb=Text(row,"255 255 255",10,Theme.Muted,Enum.Font.Gotham,{
        Size=UDim2.fromOffset(self:_s(88),1),
        Position=UDim2.new(1,-self:_s(148),0,0),
        TextXAlignment=Enum.TextXAlignment.Right
    })

    local swatch=New("TextButton",row,{
        Size=UDim2.fromOffset(self:_s(42),self:_s(30)),
        Position=UDim2.new(1,-self:_s(57),0.5,-self:_s(15)),
        BackgroundColor3=color,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false
    })

    Corner(swatch,self:_s(9))
    Stroke(swatch,Theme.Primary,0.3,self:_s(1.2))

    local function setColor(value,fire)
        if typeof(value)~="Color3" then return end

        color=value
        swatch.BackgroundColor3=value
        rgb.Text=string.format("%d %d %d",math.floor(value.R*255),math.floor(value.G*255),math.floor(value.B*255))

        if fire then
            Safe(callback,value)
            self:_saveSoon()
        end
    end

    setColor(color,false)

    local popup

    local function makePicker()
        if popup then
            popup:Destroy()
            popup=nil
            return
        end

        local blocker=New("TextButton",self.ScreenGui,{
            Size=UDim2.fromScale(1,1),
            BackgroundColor3=Color3.new(0,0,0),
            BackgroundTransparency=0.45,
            BorderSizePixel=0,
            Text="",
            AutoButtonColor=false,
            ZIndex=950
        })

        popup=New("Frame",blocker,{
            Size=UDim2.fromOffset(0,0),
            Position=UDim2.fromScale(0.5,0.5),
            AnchorPoint=Vector2.new(0.5,0.5),
            BackgroundColor3=Theme.Card,
            BorderSizePixel=0,
            ZIndex=951
        })

        Corner(popup,self:_s(16))
        Stroke(popup,Theme.Primary,0.28,self:_s(1.2))

        Play(popup,Tween.Spring,{
            Size=UDim2.fromOffset(self:_s(300),self:_s(315))
        })

        Text(popup,labelText,15,Theme.Text,Enum.Font.GothamBold,{
            Size=UDim2.new(1,-self:_s(48),0,self:_s(30)),
            Position=UDim2.fromOffset(self:_s(16),self:_s(10)),
            ZIndex=952,
            TextXAlignment=Enum.TextXAlignment.Left
        })

        local closeButton=New("TextButton",popup,{
            Size=UDim2.fromOffset(self:_s(28),self:_s(28)),
            Position=UDim2.new(1,-self:_s(40),0,self:_s(11)),
            BackgroundColor3=Theme.Surface2,
            BorderSizePixel=0,
            Text="×",
            TextColor3=Theme.Text,
            TextSize=self:_s(15),
            Font=Enum.Font.GothamBold,
            AutoButtonColor=false,
            ZIndex=952
        })

        Corner(closeButton,self:_s(9))

        local h,s,v=Color3.toHSV(color)

        local sv=New("Frame",popup,{
            Size=UDim2.new(1,-self:_s(32),0,self:_s(170)),
            Position=UDim2.fromOffset(self:_s(16),self:_s(48)),
            BackgroundColor3=Color3.fromHSV(h,1,1),
            BorderSizePixel=0,
            ZIndex=952
        })

        Corner(sv,self:_s(10))

        local white=New("Frame",sv,{
            Size=UDim2.fromScale(1,1),
            BackgroundColor3=Color3.new(1,1,1),
            BorderSizePixel=0,
            ZIndex=953
        })

        Corner(white,self:_s(10))

        local whiteGradient=Gradient(white,Color3.new(1,1,1),Color3.new(1,1,1),0)
        whiteGradient.Transparency=NumberSequence.new(0,1)

        local black=New("Frame",sv,{
            Size=UDim2.fromScale(1,1),
            BackgroundColor3=Color3.new(0,0,0),
            BorderSizePixel=0,
            ZIndex=954
        })

        Corner(black,self:_s(10))

        local blackGradient=Gradient(black,Color3.new(0,0,0),Color3.new(0,0,0),90)
        blackGradient.Transparency=NumberSequence.new(1,0)

        local hueBar=New("Frame",popup,{
            Size=UDim2.new(1,-self:_s(32),0,self:_s(22)),
            Position=UDim2.fromOffset(self:_s(16),self:_s(228)),
            BorderSizePixel=0,
            ZIndex=952
        })

        Corner(hueBar,self:_s(11))

        New("UIGradient",hueBar,{
            Color=ColorSequence.new{
                ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(0.166,Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.666,Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))
            }
        })

        local preview=New("Frame",popup,{
            Size=UDim2.new(1,-self:_s(32),0,self:_s(30)),
            Position=UDim2.fromOffset(self:_s(16),self:_s(260)),
            BackgroundColor3=color,
            BorderSizePixel=0,
            ZIndex=952
        })

        Corner(preview,self:_s(8))

        local svDot=New("Frame",sv,{
            Size=UDim2.fromOffset(self:_s(10),self:_s(10)),
            AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(s,0,1-v,0),
            BackgroundColor3=Color3.new(1,1,1),
            BorderSizePixel=0,
            ZIndex=955
        })

        Corner(svDot,self:_s(5))
        Stroke(svDot,Color3.new(0,0,0),0.1,self:_s(1))

        local hueDot=New("Frame",hueBar,{
            Size=UDim2.fromOffset(self:_s(5),self:_s(30)),
            AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(h,0,0.5,0),
            BackgroundColor3=Color3.new(1,1,1),
            BorderSizePixel=0,
            ZIndex=955
        })

        Corner(hueDot,self:_s(3))
        Stroke(hueDot,Color3.new(0,0,0),0.1,self:_s(1))

        local function refresh(fire)
            sv.BackgroundColor3=Color3.fromHSV(h,1,1)
            svDot.Position=UDim2.new(s,0,1-v,0)
            hueDot.Position=UDim2.new(h,0,0.5,0)
            setColor(Color3.fromHSV(h,s,v),fire)
            preview.BackgroundColor3=color
        end

        local dragSV=false
        local dragHue=false

        sv.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragSV=true
            end
        end)

        hueBar.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragHue=true
            end
        end)

        local changedConnection=UserInputService.InputChanged:Connect(function(input)
            if not popup then return end

            if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then
                return
            end

            if dragSV then
                local p=sv.AbsolutePosition
                local size=sv.AbsoluteSize
                s=math.clamp((input.Position.X-p.X)/size.X,0,1)
                v=1-math.clamp((input.Position.Y-p.Y)/size.Y,0,1)
                refresh(true)
            elseif dragHue then
                local p=hueBar.AbsolutePosition
                local size=hueBar.AbsoluteSize
                h=math.clamp((input.Position.X-p.X)/size.X,0,1)
                refresh(true)
            end
        end)

        local endedConnection=UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragSV=false
                dragHue=false
            end
        end)

        local function close()
            changedConnection:Disconnect()
            endedConnection:Disconnect()

            if blocker.Parent then
                blocker:Destroy()
            end

            popup=nil
        end

        closeButton.MouseButton1Click:Connect(close)
        blocker.MouseButton1Click:Connect(close)
    end

    swatch.MouseButton1Click:Connect(makePicker)

    self:RegisterElement(key,function() return color end,function(value)
        setColor(value,true)
    end,color)

    return {
        Element=row,
        GetColor=function() return color end,
        SetColor=function(value) setColor(value,true) end,
        SetCallback=function(value) callback=value end
    }
end

function Library:TSSlider(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Slider"
    local min=tonumber(cfg.Min) or 0
    local max=tonumber(cfg.Max) or 100

    if max<min then
        min,max=max,min
    end

    local increment=tonumber(cfg.Increment) or 1
    local value=math.clamp(tonumber(cfg.Default) or min,min,max)
    local suffix=cfg.Suffix or ""
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSSlider:"..labelText)

    local row=self:_row(section,72,"TSSlider")

    Text(row,labelText,13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-self:_s(110),0,self:_s(25)),
        Position=UDim2.fromOffset(self:_s(16),self:_s(8)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local valueLabel=Text(row,tostring(value)..suffix,13,Theme.Primary,Enum.Font.GothamBold,{
        Size=UDim2.fromOffset(self:_s(90),0,self:_s(25)),
        Position=UDim2.new(1,-self:_s(105),0,self:_s(8)),
        TextXAlignment=Enum.TextXAlignment.Right
    })

    local track=New("Frame",row,{
        Size=UDim2.new(1,-self:_s(32),0,self:_s(7)),
        Position=UDim2.fromOffset(self:_s(16),self:_s(50)),
        BackgroundColor3=Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(track,self:_s(4))

    local fill=New("Frame",track,{
        Size=UDim2.new(0,0,1,0),
        BackgroundColor3=Theme.Primary,
        BorderSizePixel=0
    })

    Corner(fill,self:_s(4))
    Gradient(fill,Theme.Primary,Theme.PrimaryHover,0)

    local thumb=New("Frame",track,{
        Size=UDim2.fromOffset(self:_s(18),self:_s(18)),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=Contrast(Theme.Primary),
        BorderSizePixel=0
    })

    Corner(thumb,self:_s(9))
    Stroke(thumb,Theme.Primary,0.1,self:_s(1.5))

    local function update(fire)
        local percentage=(value-min)/(max-min==0 and 1 or max-min)

        fill.Size=UDim2.new(percentage,0,1,0)
        thumb.Position=UDim2.new(percentage,0,0.5,0)
        valueLabel.Text=tostring(value)..suffix

        if fire then
            Safe(callback,value)
            self:_saveSoon()
        end
    end

    local dragging=false

    local function updateFromInput(input)
        local percentage=math.clamp((input.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        value=math.clamp(math.floor((min+(max-min)*percentage)/increment+0.5)*increment,min,max)
        update(true)
    end

    local function begin(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            updateFromInput(input)
        end
    end

    track.InputBegan:Connect(begin)
    thumb.InputBegan:Connect(begin)

    table.insert(self.Connections,UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end))

    table.insert(self.Connections,UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end))

    update(false)

    self:RegisterElement(key,function() return value end,function(v)
        value=math.clamp(tonumber(v) or min,min,max)
        update(false)
    end,value)

    return {
        Element=row,
        GetValue=function() return value end,
        SetValue=function(v)
            value=math.clamp(tonumber(v) or min,min,max)
            update(true)
        end,
        SetRange=function(a,b)
            min=tonumber(a) or min
            max=tonumber(b) or max
            value=math.clamp(value,min,max)
            update(true)
        end,
        SetCallback=function(v) callback=v end
    }
end

function Library:TSTextBox(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Text"
    local placeholder=cfg.Placeholder or "Enter text..."
    local value=tostring(cfg.Default or "")
    local callback=cfg.Callback or function() end
    local multiline=cfg.Multiline==true
    local numbersOnly=cfg.NumbersOnly==true
    local key=cfg.Key or ("TSTextBox:"..labelText)

    local row=self:_row(section,multiline and 92 or 58,"TSTextBox")

    Text(row,labelText,10,Theme.Muted,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-self:_s(30),0,self:_s(18)),
        Position=UDim2.fromOffset(self:_s(16),self:_s(5)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local box=New("TextBox",row,{
        Size=UDim2.new(1,-self:_s(32),0,self:_s(multiline and 54 or 28)),
        Position=UDim2.fromOffset(self:_s(16),self:_s(25)),
        BackgroundColor3=Theme.Surface2,
        BackgroundTransparency=0.08,
        BorderSizePixel=0,
        Text=value,
        PlaceholderText=placeholder,
        PlaceholderColor3=Theme.Muted,
        TextColor3=Theme.Text,
        TextSize=self:_s(12),
        Font=Enum.Font.Gotham,
        ClearTextOnFocus=false,
        MultiLine=multiline,
        TextWrapped=multiline,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    })

    Corner(box,self:_s(8))

    local border=Stroke(box,Theme.BorderStrong,0.48,self:_s(1))

    box.Focused:Connect(function()
        Play(border,Tween.Fast,{
            Color=Theme.Primary,
            Transparency=0.08
        })
    end)

    box.FocusLost:Connect(function()
        Play(border,Tween.Fast,{
            Color=Theme.BorderStrong,
            Transparency=0.48
        })

        Safe(callback,box.Text)
        self:_saveSoon()
    end)

    if numbersOnly then
        box:GetPropertyChangedSignal("Text"):Connect(function()
            local cleaned=box.Text:gsub("[^%d%.-]","")
            if cleaned~=box.Text then
                box.Text=cleaned
            end
        end)
    end

    self:RegisterElement(key,function() return box.Text end,function(v)
        box.Text=tostring(v or "")
        Safe(callback,box.Text)
    end,value)

    return {
        Element=row,
        GetText=function() return box.Text end,
        SetText=function(v)
            box.Text=tostring(v or "")
            Safe(callback,box.Text)
        end,
        ClearText=function()
            box.Text=""
            Safe(callback,"")
        end,
        Focus=function()
            box:CaptureFocus()
        end,
        SetCallback=function(v) callback=v end
    }
end

function Library:TSLabel(section,cfg)
    cfg=cfg or {}

    local row=self:_row(section,cfg.Height or 44,"TSLabel")

    local left=Text(row,cfg.Text or "Label",12,Theme.Text2,Enum.Font.GothamSemibold,{
        Size=UDim2.new(0.5,-self:_s(16),1,0),
        Position=UDim2.fromOffset(self:_s(14),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local valueColor=Theme.Text

    if cfg.Style=="warning" then
        valueColor=Theme.Warning
    elseif cfg.Style=="error" then
        valueColor=Theme.Danger
    elseif cfg.Style=="info" then
        valueColor=Theme.Info
    end

    local right=Text(row,tostring(cfg.Value or ""),12,valueColor,Enum.Font.GothamBold,{
        Size=UDim2.new(0.5,-self:_s(14),1,0),
        Position=UDim2.new(0.5,0,0,0),
        TextXAlignment=Enum.TextXAlignment.Right
    })

    return {
        Element=row,
        SetText=function(v) left.Text=tostring(v) end,
        SetValue=function(v) right.Text=tostring(v) end,
        GetValue=function() return right.Text end
    }
end

function Library:TSProgressBar(section,cfg)
    cfg=cfg or {}

    local min=tonumber(cfg.Min) or 0
    local max=tonumber(cfg.Max) or 100
    local value=math.clamp(tonumber(cfg.Default) or min,min,max)

    local row=self:_row(section,62,"TSProgressBar")

    Text(row,cfg.Text or "Progress",12,Theme.Text2,Enum.Font.GothamSemibold,{
        Size=UDim2.new(0.65,-16,0,24),
        Position=UDim2.fromOffset(self:_s(16),self:_s(6)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local output=Text(row,"0%",12,Theme.Primary,Enum.Font.GothamBold,{
        Size=UDim2.new(0.35,-16,0,24),
        Position=UDim2.new(0.65,0,0,self:_s(6)),
        TextXAlignment=Enum.TextXAlignment.Right
    })

    local track=New("Frame",row,{
        Size=UDim2.new(1,-32,0,self:_s(7)),
        Position=UDim2.fromOffset(self:_s(16),self:_s(42)),
        BackgroundColor3=Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(track,self:_s(4))

    local fill=New("Frame",track,{
        Size=UDim2.new(0,0,1,0),
        BackgroundColor3=Theme.Primary,
        BorderSizePixel=0
    })

    Corner(fill,self:_s(4))
    Gradient(fill,Theme.Primary,Theme.PrimaryHover,0)

    local function update(v)
        value=math.clamp(tonumber(v) or min,min,max)

        local percentage=(value-min)/(max-min==0 and 1 or max-min)

        Play(fill,Tween.Smooth,{
            Size=UDim2.new(percentage,0,1,0)
        })

        output.Text=string.format("%d%%",math.floor(percentage*100+0.5))
    end

    update(value)

    return {
        Element=row,
        GetValue=function() return value end,
        SetValue=update,
        SetText=function() end
    }
end

function Library:TSSeparator(section,cfg)
    cfg=cfg or {}

    local row=New("Frame",section.Content,{
        Size=UDim2.new(1,0,0,self:_s(cfg.Text and 24 or 10)),
        BackgroundTransparency=1,
        LayoutOrder=#section.Elements+1
    })

    if cfg.Text then
        New("Frame",row,{
            Size=UDim2.new(0.5,-self:_s(62),0,self:_s(1)),
            Position=UDim2.new(0,0,0.5,0),
            BackgroundColor3=Theme.Border,
            BorderSizePixel=0
        })

        New("Frame",row,{
            Size=UDim2.new(0.5,-self:_s(62),0,self:_s(1)),
            Position=UDim2.new(0.5,self:_s(62),0.5,0),
            BackgroundColor3=Theme.Border,
            BorderSizePixel=0
        })

        Text(row,cfg.Text,9,Theme.Muted,Enum.Font.GothamBold,{
            Size=UDim2.fromOffset(self:_s(120),1),
            Position=UDim2.new(0.5,-self:_s(60),0,0),
            TextXAlignment=Enum.TextXAlignment.Center
        })
    else
        New("Frame",row,{
            Size=UDim2.new(1,0,0,self:_s(1)),
            Position=UDim2.new(0,0,0.5,0),
            BackgroundColor3=Theme.Border,
            BorderSizePixel=0
        })
    end

    table.insert(section.Elements,row)
    return {Element=row}
end

function Library:TSMultiButton(section,cfg)
    cfg=cfg or {}

    local options=cfg.Options or {"Option 1","Option 2"}
    local selected=cfg.Default or options[1]
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSMultiButton:"..table.concat(options,"|"))

    local row=self:_row(section,48,"TSMultiButton")

    New("UIPadding",row,{
        PaddingLeft=UDim.new(0,self:_s(5)),
        PaddingRight=UDim.new(0,self:_s(5)),
        PaddingTop=UDim.new(0,self:_s(5)),
        PaddingBottom=UDim.new(0,self:_s(5))
    })

    New("UIListLayout",row,{
        FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,self:_s(4)),
        VerticalAlignment=Enum.VerticalAlignment.Center
    })

    local buttons={}

    local function refresh(fire)
        for _,entry in ipairs(buttons) do
            local chosen=entry.Value==selected

            Play(entry.Button,Tween.Fast,{
                BackgroundColor3=chosen and Theme.Primary or Theme.Surface2,
                BackgroundTransparency=chosen and 0.04 or 0.2
            })

            entry.Label.TextColor3=chosen and Contrast(Theme.Primary) or Theme.Muted
        end

        if fire then
            Safe(callback,selected)
            self:_saveSoon()
        end
    end

    for index,option in ipairs(options) do
        local chosen=option==selected

        local button=New("TextButton",row,{
            Size=UDim2.new(1/#options,-self:_s(5),1,-self:_s(10)),
            BackgroundColor3=chosen and Theme.Primary or Theme.Surface2,
            BackgroundTransparency=chosen and 0.04 or 0.2,
            BorderSizePixel=0,
            Text="",
            AutoButtonColor=false,
            LayoutOrder=index
        })

        Corner(button,self:_s(9))

        local label=Text(button,tostring(option),11,chosen and Contrast(Theme.Primary) or Theme.Muted,Enum.Font.GothamSemibold,{
            Size=UDim2.fromScale(1,1),
            TextXAlignment=Enum.TextXAlignment.Center
        })

        table.insert(buttons,{
            Button=button,
            Label=label,
            Value=option
        })

        button.MouseButton1Click:Connect(function()
            selected=option
            refresh(true)
        end)
    end

    self:RegisterElement(key,function() return selected end,function(v)
        selected=v
        refresh(false)
    end,selected)

    return {
        Element=row,
        GetSelected=function() return selected end,
        SetSelected=function(v) selected=v refresh(true) end,
        SetCallback=function(v) callback=v end
    }
end

function Library:TSBadgeRow(section,cfg)
    cfg=cfg or {}

    local row=New("Frame",section.Content,{
        Size=UDim2.new(1,0,0,self:_s(34)),
        BackgroundTransparency=1,
        LayoutOrder=#section.Elements+1
    })

    if cfg.Label then
        Text(row,cfg.Label,10,Theme.Muted,Enum.Font.GothamSemibold,{
            Size=UDim2.fromOffset(self:_s(105),1),
            TextXAlignment=Enum.TextXAlignment.Left
        })
    end

    local holder=New("Frame",row,{
        Size=UDim2.new(1,cfg.Label and -self:_s(110) or 0,1,0),
        Position=UDim2.fromOffset(cfg.Label and self:_s(110) or 0,0),
        BackgroundTransparency=1
    })

    New("UIListLayout",holder,{
        FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,self:_s(6)),
        VerticalAlignment=Enum.VerticalAlignment.Center
    })

    for _,badgeData in ipairs(cfg.Badges or {}) do
        local color=badgeData.Color or Theme.Primary

        local badge=New("Frame",holder,{
            AutomaticSize=Enum.AutomaticSize.X,
            Size=UDim2.fromOffset(0,self:_s(24)),
            BackgroundColor3=color,
            BackgroundTransparency=0.78,
            BorderSizePixel=0
        })

        Corner(badge,self:_s(12))
        Stroke(badge,color,0.4,1)

        New("UIPadding",badge,{
            PaddingLeft=UDim.new(0,self:_s(8)),
            PaddingRight=UDim.new(0,self:_s(8))
        })

        Text(badge,badgeData.Text or "Badge",10,color,Enum.Font.GothamBold,{
            AutomaticSize=Enum.AutomaticSize.X,
            Size=UDim2.fromOffset(0,self:_s(24)),
            TextXAlignment=Enum.TextXAlignment.Center
        })
    end

    table.insert(section.Elements,row)
    return {Element=row}
end

function Library:TSCheckbox(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Checkbox"
    local value=cfg.Default==true
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSCheckbox:"..labelText)

    local row=self:_row(section,50,"TSCheckbox")

    Text(row,labelText,13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-60,1,0),
        Position=UDim2.fromOffset(self:_s(16),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local box=New("Frame",row,{
        Size=UDim2.fromOffset(self:_s(24),self:_s(24)),
        Position=UDim2.new(1,-self:_s(39),0.5,-self:_s(12)),
        BackgroundColor3=value and Theme.Primary or Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(box,self:_s(7))

    local border=Stroke(box,value and Theme.Primary or Theme.BorderStrong,0.3,1.2)

    local check=Text(box,"✓",13,Contrast(Theme.Primary),Enum.Font.GothamBlack,{
        Size=UDim2.fromScale(1,1),
        TextTransparency=value and 0 or 1,
        TextXAlignment=Enum.TextXAlignment.Center
    })

    local hit=New("TextButton",row,{
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        Text="",
        AutoButtonColor=false
    })

    local function update(fire)
        Play(box,Tween.Fast,{
            BackgroundColor3=value and Theme.Primary or Theme.Surface2
        })

        Play(border,Tween.Fast,{
            Color=value and Theme.Primary or Theme.BorderStrong
        })

        Play(check,Tween.Fast,{
            TextTransparency=value and 0 or 1
        })

        if fire then
            Safe(callback,value)
            self:_saveSoon()
        end
    end

    hit.MouseButton1Click:Connect(function()
        value=not value
        update(true)
    end)

    self:RegisterElement(key,function() return value end,function(v)
        value=v==true
        update(false)
    end,value)

    return {
        Element=row,
        GetValue=function() return value end,
        SetValue=function(v) value=v==true update(true) end,
        SetCallback=function(v) callback=v end
    }
end

function Library:TSRadioGroup(section,cfg)
    cfg=cfg or {}

    local options=cfg.Options or {}
    local selected=cfg.Default or options[1]
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSRadioGroup:"..(cfg.Text or "Options"))

    local row=self:_row(section,38+#options*34,"TSRadioGroup")

    Text(row,cfg.Text or "Options",13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-30,0,28),
        Position=UDim2.fromOffset(self:_s(16),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local radios={}

    local function refresh(fire)
        for _,entry in ipairs(radios) do
            local chosen=entry.Value==selected

            Play(entry.Circle,Tween.Fast,{
                BackgroundColor3=chosen and Theme.Primary or Theme.Surface2
            })

            Play(entry.Dot,Tween.Fast,{
                BackgroundTransparency=chosen and 0 or 1
            })

            entry.Label.TextColor3=chosen and Theme.Text or Theme.Muted
        end

        if fire then
            Safe(callback,selected)
            self:_saveSoon()
        end
    end

    for index,option in ipairs(options) do
        local button=New("TextButton",row,{
            Size=UDim2.new(1,-32,0,self:_s(30)),
            Position=UDim2.fromOffset(self:_s(16),self:_s(30+(index-1)*34)),
            BackgroundTransparency=1,
            Text="",
            AutoButtonColor=false
        })

        local circle=New("Frame",button,{
            Size=UDim2.fromOffset(self:_s(20),self:_s(20)),
            Position=UDim2.fromOffset(0,self:_s(5)),
            BackgroundColor3=option==selected and Theme.Primary or Theme.Surface2,
            BorderSizePixel=0
        })

        Corner(circle,self:_s(10))
        Stroke(circle,Theme.BorderStrong,0.3,1)

        local dot=New("Frame",circle,{
            Size=UDim2.fromOffset(self:_s(8),self:_s(8)),
            Position=UDim2.fromScale(0.5,0.5),
            AnchorPoint=Vector2.new(0.5,0.5),
            BackgroundColor3=Contrast(Theme.Primary),
            BackgroundTransparency=option==selected and 0 or 1,
            BorderSizePixel=0
        })

        Corner(dot,self:_s(4))

        local label=Text(button,tostring(option),11,option==selected and Theme.Text or Theme.Muted,Enum.Font.GothamMedium,{
            Size=UDim2.new(1,-30,1,0),
            Position=UDim2.fromOffset(self:_s(30),0),
            TextXAlignment=Enum.TextXAlignment.Left
        })

        table.insert(radios,{
            Circle=circle,
            Dot=dot,
            Label=label,
            Value=option
        })

        button.MouseButton1Click:Connect(function()
            selected=option
            refresh(true)
        end)
    end

    self:RegisterElement(key,function() return selected end,function(v)
        selected=v
        refresh(false)
    end,selected)

    return {
        Element=row,
        GetValue=function() return selected end,
        SetValue=function(v) selected=v refresh(true) end,
        SetCallback=function(v) callback=v end
    }
end

function Library:TSNumberStepper(section,cfg)
    cfg=cfg or {}

    local labelText=cfg.Text or "Value"
    local min=tonumber(cfg.Min) or 0
    local max=tonumber(cfg.Max) or 100
    local step=tonumber(cfg.Step) or 1
    local value=math.clamp(tonumber(cfg.Default) or min,min,max)
    local callback=cfg.Callback or function() end
    local key=cfg.Key or ("TSNumberStepper:"..labelText)

    local row=self:_row(section,52,"TSNumberStepper")

    Text(row,labelText,13,Theme.Text,Enum.Font.GothamSemibold,{
        Size=UDim2.new(1,-145,1,0),
        Position=UDim2.fromOffset(self:_s(16),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local function makeButton(offset,textValue)
        local button=New("TextButton",row,{
            Size=UDim2.fromOffset(self:_s(30),self:_s(30)),
            Position=UDim2.new(1,-self:_s(offset),0.5,-self:_s(15)),
            BackgroundColor3=Theme.Surface2,
            BorderSizePixel=0,
            Text=textValue,
            TextColor3=Theme.Text,
            TextSize=self:_s(15),
            Font=Enum.Font.GothamBold,
            AutoButtonColor=false
        })

        Corner(button,self:_s(8))
        Stroke(button,Theme.BorderStrong,0.45,1)

        return button
    end

    local minus=makeButton(112,"−")
    local plus=makeButton(40,"+")

    local display=New("TextLabel",row,{
        Size=UDim2.fromOffset(self:_s(60),self:_s(30)),
        Position=UDim2.new(1,-self:_s(106),0.5,-self:_s(15)),
        BackgroundColor3=Theme.Surface2,
        BorderSizePixel=0,
        Text=tostring(value),
        TextColor3=Theme.Primary,
        TextSize=self:_s(12),
        Font=Enum.Font.GothamBold
    })

    Corner(display,self:_s(8))

    local function update(fire)
        value=math.clamp(value,min,max)
        display.Text=tostring(value)

        if fire then
            Safe(callback,value)
            self:_saveSoon()
        end
    end

    minus.MouseButton1Click:Connect(function()
        value=value-step
        update(true)
    end)

    plus.MouseButton1Click:Connect(function()
        value=value+step
        update(true)
    end)

    self:RegisterElement(key,function() return value end,function(v)
        value=tonumber(v) or value
        update(false)
    end,value)

    return {
        Element=row,
        GetValue=function() return value end,
        SetValue=function(v)
            value=tonumber(v) or value
            update(true)
        end,
        SetCallback=function(v) callback=v end
    }
end

function Library:TSCard(section,cfg)
    cfg=cfg or {}

    local row=self:_row(section,68,"TSCard")

    local icon=New("Frame",row,{
        Size=UDim2.fromOffset(self:_s(42),self:_s(42)),
        Position=UDim2.fromOffset(self:_s(12),self:_s(13)),
        BackgroundColor3=Theme.Primary,
        BackgroundTransparency=0.84,
        BorderSizePixel=0
    })

    Corner(icon,self:_s(12))

    Text(icon,cfg.Icon or "◆",17,Theme.Primary,Enum.Font.GothamBlack,{
        Size=UDim2.fromScale(1,1),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    Text(row,cfg.Title or "Card",13,Theme.Text,Enum.Font.GothamBold,{
        Size=UDim2.new(1,-72,0,20),
        Position=UDim2.fromOffset(self:_s(64),self:_s(10)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    Text(row,cfg.Description or "",10,Theme.Muted,Enum.Font.Gotham,{
        Size=UDim2.new(1,-72,0,30),
        Position=UDim2.fromOffset(self:_s(64),self:_s(32)),
        TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    if cfg.Callback then
        local hit=New("TextButton",row,{
            Size=UDim2.fromScale(1,1),
            BackgroundTransparency=1,
            Text="",
            AutoButtonColor=false
        })

        hit.MouseButton1Click:Connect(function()
            Ripple(row,Vector2.new(row.AbsoluteSize.X/2,row.AbsoluteSize.Y/2))
            Safe(cfg.Callback)
        end)
    end

    return {Element=row}
end

function Library:TSCodeBlock(section,cfg)
    cfg=cfg or {}

    local code=tostring(cfg.Code or "")
    local lines=1

    for _ in code:gmatch("\n") do
        lines+=1
    end

    local height=math.clamp(58+lines*15,75,230)
    local row=self:_row(section,height,"TSCodeBlock")

    Text(row,cfg.Label or "Code",10,Theme.Muted,Enum.Font.GothamBold,{
        Size=UDim2.new(1,-80,0,24),
        Position=UDim2.fromOffset(self:_s(12),self:_s(5)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local copy=New("TextButton",row,{
        Size=UDim2.fromOffset(self:_s(60),self:_s(23)),
        Position=UDim2.new(1,-self:_s(70),0,self:_s(5)),
        BackgroundColor3=Theme.Primary,
        BackgroundTransparency=0.86,
        BorderSizePixel=0,
        Text="Copy",
        TextColor3=Theme.Primary,
        TextSize=self:_s(10),
        Font=Enum.Font.GothamBold,
        AutoButtonColor=false
    })

    Corner(copy,self:_s(7))

    local scroll=New("ScrollingFrame",row,{
        Size=UDim2.new(1,-24,1,-36),
        Position=UDim2.fromOffset(12,31),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=Theme.Primary,
        CanvasSize=UDim2.new(0,0,0,lines*15+8)
    })

    Text(scroll,code,11,Theme.Text2,Enum.Font.Code,{
        Size=UDim2.new(1,0,0,lines*15+8),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top,
        TextWrapped=false
    })

    copy.MouseButton1Click:Connect(function()
        local fn=(typeof(setclipboard)=="function" and setclipboard)
            or (typeof(toclipboard)=="function" and toclipboard)

        if fn then
            Safe(fn,code)
            copy.Text="Copied"

            task.delay(1,function()
                if copy.Parent then
                    copy.Text="Copy"
                end
            end)
        end
    end)

    return {
        Element=row,
        SetCode=function(v) code=tostring(v) end
    }
end

function Library:TSStatDisplay(section,cfg)
    cfg=cfg or {}

    local row=self:_row(section,58,"TSStatDisplay")

    local icon=New("Frame",row,{
        Size=UDim2.fromOffset(self:_s(36),self:_s(36)),
        Position=UDim2.fromOffset(self:_s(11),self:_s(11)),
        BackgroundColor3=Theme.Primary,
        BackgroundTransparency=0.86,
        BorderSizePixel=0
    })

    Corner(icon,self:_s(10))

    Text(icon,cfg.Icon or "#",14,Theme.Primary,Enum.Font.GothamBlack,{
        Size=UDim2.fromScale(1,1),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    Text(row,cfg.Label or "Stat",10,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.new(0.55,0,0,17),
        Position=UDim2.fromOffset(self:_s(58),self:_s(8)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local value=Text(row,tostring(cfg.Value or "0"),16,Theme.Text,Enum.Font.GothamBlack,{
        Size=UDim2.new(0.55,0,0,22),
        Position=UDim2.fromOffset(self:_s(58),self:_s(26)),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    return {
        Element=row,
        SetValue=function(v) value.Text=tostring(v) end,
        SetLabel=function() end
    }
end

function Library:TSImage(section,cfg)
    cfg=cfg or {}

    local height=tonumber(cfg.Height) or 140
    local row=self:_row(section,height,"TSImage")
    row.ClipsDescendants=true

    local image=New("ImageLabel",row,{
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        Image=cfg.ImageId or "rbxassetid://0",
        ScaleType=Enum.ScaleType.Crop
    })

    Corner(image,self:_s(12))

    return {
        Element=row,
        SetImage=function(v) image.Image=v end
    }
end

function Library:TSSpacer(section,cfg)
    cfg=cfg or {}

    local row=New("Frame",section.Content,{
        Size=UDim2.new(1,0,0,self:_s(cfg.Height or 10)),
        BackgroundTransparency=1,
        LayoutOrder=#section.Elements+1
    })

    table.insert(section.Elements,row)

    return {Element=row}
end

function Library:TSFileDropdown(section,cfg)
    cfg=cfg or {}

    local folder=cfg.Folder or ""
    local extension=cfg.Extension
    local files={}

    if typeof(listfiles)=="function" then
        local ok,list=Safe(function()
            return listfiles(folder)
        end)

        if ok and type(list)=="table" then
            for _,path in ipairs(list) do
                local name=tostring(path):match("([^/\\]+)$") or tostring(path)

                if not extension or name:sub(-#extension)==extension then
                    table.insert(files,name)
                end
            end
        end
    end

    return self:TSDropdown(section,{
        Text=cfg.Text or "File",
        Options=files,
        Default=cfg.Default,
        Callback=cfg.Callback,
        Key=cfg.Key or ("TSFileDropdown:"..(cfg.Text or "File"))
    })
end

function Library:TSKeybindDisplay(section,cfg)
    cfg=cfg or {}

    local row=self:_row(section,46,"TSKeybindDisplay")

    Text(row,cfg.Text or "Hotkey",12,Theme.Text2,Enum.Font.GothamMedium,{
        Size=UDim2.new(1,-105,1,0),
        Position=UDim2.fromOffset(self:_s(14),0),
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local pill=New("Frame",row,{
        Size=UDim2.fromOffset(self:_s(72),self:_s(28)),
        Position=UDim2.new(1,-self:_s(86),0.5,-self:_s(14)),
        BackgroundColor3=Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(pill,self:_s(8))
    Stroke(pill,Theme.Primary,0.38,1)

    local label=Text(pill,cfg.Keybind and cfg.Keybind.Name or "None",10,Theme.Text,Enum.Font.GothamBold,{
        Size=UDim2.fromScale(1,1),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    return {
        Element=row,
        SetKeybind=function(v)
            label.Text=v and v.Name or "None"
        end
    }
end

function Library:Notify(title,message,kind,duration)
    duration=duration or 3.2
    kind=kind or "info"

    local color=kind=="success" and Theme.Success
        or kind=="error" and Theme.Danger
        or kind=="warning" and Theme.Warning
        or Theme.Primary

    if not self.NotificationHolder then
        self.NotificationHolder=New("Frame",self.ScreenGui,{
            Name="Notifications",
            Size=UDim2.fromOffset(self:_s(330),self:_s(500)),
            Position=UDim2.new(1,-self:_s(18),1,-self:_s(18)),
            AnchorPoint=Vector2.new(1,1),
            BackgroundTransparency=1,
            ZIndex=1000
        })

        New("UIListLayout",self.NotificationHolder,{
            VerticalAlignment=Enum.VerticalAlignment.Bottom,
            HorizontalAlignment=Enum.HorizontalAlignment.Right,
            Padding=UDim.new(0,self:_s(8)),
            SortOrder=Enum.SortOrder.LayoutOrder
        })
    end

    local notification=New("Frame",self.NotificationHolder,{
        Size=UDim2.new(1,0,0,self:_s(68)),
        BackgroundColor3=Theme.Card,
        BackgroundTransparency=0.04,
        BorderSizePixel=0,
        ZIndex=1001
    })

    Corner(notification,self:_s(13))
    Stroke(notification,color,0.28,1.2)

    New("Frame",notification,{
        Size=UDim2.fromOffset(self:_s(3),self:_s(50)),
        Position=UDim2.fromOffset(0,self:_s(9)),
        BackgroundColor3=color,
        BorderSizePixel=0,
        ZIndex=1002
    })

    Text(notification,title,12,Theme.Text,Enum.Font.GothamBold,{
        Size=UDim2.new(1,-28,0,20),
        Position=UDim2.fromOffset(16,9),
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=1002
    })

    Text(notification,message,10,Theme.Text2,Enum.Font.Gotham,{
        Size=UDim2.new(1,-28,0,30),
        Position=UDim2.fromOffset(16,30),
        TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=1002
    })

    notification.Position=UDim2.new(1,40,0,0)

    Play(notification,Tween.Spring,{
        Position=UDim2.new(0,0,0,0)
    })

    task.delay(duration,function()
        if notification.Parent then
            local tween=Play(notification,Tween.Fast,{
                BackgroundTransparency=1,
                Position=UDim2.new(1,40,0,0)
            })

            if tween then
                tween.Completed:Wait()
            end

            if notification.Parent then
                notification:Destroy()
            end
        end
    end)
end

function Library:Minimize()
    self.Minimized=not self.Minimized

    if self.Minimized then
        self.NormalSize=self.NormalSize or self.Main.Size

        Play(self.Main,Tween.Spring,{
            Size=UDim2.fromOffset(self:_s(360),self:_s(84))
        })

        self.Pages.Visible=false
        self.Nav.Visible=false
        self.WindowButtons.Minimize.Text="+"
    else
        Play(self.Main,Tween.Spring,{
            Size=self.NormalSize
        })

        self.Pages.Visible=true
        self.Nav.Visible=true
        self.WindowButtons.Minimize.Text="−"
    end
end

function Library:Maximize()
    self.Maximized=not self.Maximized

    local camera=workspace.CurrentCamera

    if self.Maximized then
        self.NormalSize=self.NormalSize or self.Main.Size
        self.NormalPosition=self.NormalPosition or self.Main.Position

        local viewport=camera and camera.ViewportSize or Vector2.new(1920,1080)

        Play(self.Main,Tween.Spring,{
            Size=UDim2.fromOffset(viewport.X-32,viewport.Y-32),
            Position=UDim2.fromOffset(16,16)
        })

        self.WindowButtons.Maximize.Text="◱"
    else
        Play(self.Main,Tween.Spring,{
            Size=self.NormalSize or UDim2.fromOffset(self:_s(1040),self:_s(690)),
            Position=self.NormalPosition or UDim2.fromScale(0.5,0.5)
        })

        self.WindowButtons.Maximize.Text="□"
    end
end

function Library:Toggle()
    self.Visible=not self.Visible

    if not self.Visible then
        Play(self.Main,Tween.Fade,{
            BackgroundTransparency=1
        })

        task.delay(0.25,function()
            if self.ScreenGui then
                self.ScreenGui.Enabled=false
            end
        end)
    else
        self.ScreenGui.Enabled=true
        self.Main.BackgroundTransparency=1

        Play(self.Main,Tween.Spring,{
            BackgroundTransparency=0
        })
    end
end

function Library:GetConfigPath(name)
    return self.ConfigFolderName.."/"..name..".json"
end

function Library:SaveConfig(name)
    if not HasFileApi() then return false end

    name=CleanName(name or self.CurrentConfigName)

    if name=="" then return false end

    local folderOk=Safe(function()
        if not isfolder(self.ConfigFolderName) then
            makefolder(self.ConfigFolderName)
        end
    end)

    if not folderOk then return false end

    local data={}

    for _,entry in ipairs(self.Registry) do
        local ok,value=Safe(entry.Get)

        if ok then
            data[entry.Key]=Serialize(value)
        end
    end

    local ok,encoded=Safe(function()
        return HttpService:JSONEncode(data)
    end)

    if not ok then return false end

    local written=Safe(function()
        writefile(self:GetConfigPath(name),encoded)
    end)

    if written then
        self.CurrentConfigName=name

        Safe(function()
            writefile(self.ConfigFolderName.."/.lastconfig.txt",name)
        end)

        return true
    end

    return false
end

function Library:LoadConfig(name)
    if not HasFileApi() then return false end

    name=CleanName(name or self.CurrentConfigName)

    if name=="" then return false end

    local ok,content=Safe(function()
        return readfile(self:GetConfigPath(name))
    end)

    if not ok or not content then return false end

    local decodedOk,data=Safe(function()
        return HttpService:JSONDecode(content)
    end)

    if not decodedOk or type(data)~="table" then
        return false
    end

    self.LoadingConfig=true

    local applied=false

    for _,entry in ipairs(self.Registry) do
        if data[entry.Key]~=nil then
            local value=Deserialize(data[entry.Key])
            local setOk=Safe(entry.Set,value)

            if setOk then
                applied=true
            end
        end
    end

    self.LoadingConfig=false
    self.CurrentConfigName=name

    Safe(function()
        if not isfolder(self.ConfigFolderName) then
            makefolder(self.ConfigFolderName)
        end

        writefile(self.ConfigFolderName.."/.lastconfig.txt",name)
    end)

    return applied or #self.Registry==0
end

function Library:GetConfigList()
    if typeof(listfiles)~="function" then return {} end

    local ok,list=Safe(function()
        return listfiles(self.ConfigFolderName)
    end)

    if not ok or type(list)~="table" then
        return {}
    end

    local names={}

    for _,path in ipairs(list) do
        local name=tostring(path):match("([^/\\]+)%.json$")

        if name then
            table.insert(names,name)
        end
    end

    table.sort(names)

    return names
end

function Library:DeleteConfig(name)
    if not HasFileApi() then return false end

    name=CleanName(name)

    if name=="" then return false end

    return Safe(function()
        local path=self:GetConfigPath(name)

        if isfile(path) then
            delfile(path)
        end
    end)
end

function Library:RenameConfig(oldName,newName)
    if not HasFileApi() then return false end

    oldName=CleanName(oldName)
    newName=CleanName(newName)

    if oldName=="" or newName=="" then
        return false
    end

    local ok,content=Safe(function()
        return readfile(self:GetConfigPath(oldName))
    end)

    if not ok then return false end

    local written=Safe(function()
        writefile(self:GetConfigPath(newName),content)
        delfile(self:GetConfigPath(oldName))
    end)

    if written and self.CurrentConfigName==oldName then
        self.CurrentConfigName=newName
    end

    return written
end

function Library:ExportConfig()
    local data={}

    for _,entry in ipairs(self.Registry) do
        local ok,value=Safe(entry.Get)

        if ok then
            data[entry.Key]=Serialize(value)
        end
    end

    local ok,text=Safe(function()
        return HttpService:JSONEncode(data)
    end)

    if not ok then
        return false,nil
    end

    local clipboard=(typeof(setclipboard)=="function" and setclipboard)
        or (typeof(toclipboard)=="function" and toclipboard)

    if clipboard then
        Safe(clipboard,text)
    end

    return true,text
end

function Library:ImportConfig(text)
    local ok,data=Safe(function()
        return HttpService:JSONDecode(text)
    end)

    if not ok or type(data)~="table" then
        return false
    end

    self.LoadingConfig=true

    local applied=false

    for _,entry in ipairs(self.Registry) do
        if data[entry.Key]~=nil then
            local setOk=Safe(entry.Set,Deserialize(data[entry.Key]))

            if setOk then
                applied=true
            end
        end
    end

    self.LoadingConfig=false

    return applied
end

function Library:ResetAllToDefault()
    self.LoadingConfig=true

    for _,entry in ipairs(self.Registry) do
        if entry.Default~=nil then
            Safe(entry.Set,entry.Default)
        end
    end

    self.LoadingConfig=false
end

function Library:CreateConfigTab()
    local tab=self:CreateTab("Configs")

    local active=tab:CreateSection("Active Config","Fast local config controls")

    local nameBox=active:TSTextBox({
        Text="Config Name",
        Placeholder="my-config",
        Default=self.CurrentConfigName
    })

    active:TSButton({
        Text="Save Current",
        Callback=function()
            local name=nameBox.GetText()

            if self:SaveConfig(name) then
                self:Notify("Config","Saved "..CleanName(name),"success")
            else
                self:Notify("Config","Could not save config","error")
            end
        end
    })

    active:TSButton({
        Text="Export JSON",
        Style="ghost",
        Callback=function()
            local ok=self:ExportConfig()

            self:Notify(
                "Config",
                ok and "JSON copied to clipboard" or "Export failed",
                ok and "success" or "error"
            )
        end
    })

    active:TSButton({
        Text="Reset Defaults",
        Style="ghost",
        Color=Theme.Danger,
        Callback=function()
            self:ResetAllToDefault()
            self:Notify("Config","Values reset","warning")
        end
    })

    local manage=tab:CreateSection("Manage","Load, delete and rename saved configs")

    local selected=""
    local dropdown=manage:TSDropdown({
        Text="Saved Config",
        Options=self:GetConfigList(),
        Callback=function(value)
            selected=value
        end
    })

    manage:TSButton({
        Text="Load Selected",
        Callback=function()
            if selected~="" and self:LoadConfig(selected) then
                self:Notify("Config","Loaded "..selected,"success")
            else
                self:Notify("Config","Load failed","error")
            end
        end
    })

    manage:TSButton({
        Text="Delete Selected",
        Style="ghost",
        Color=Theme.Danger,
        Callback=function()
            if selected~="" and self:DeleteConfig(selected) then
                self:Notify("Config","Deleted "..selected,"warning")
                dropdown.SetOptions(self:GetConfigList())
            else
                self:Notify("Config","Delete failed","error")
            end
        end
    })

    local renameBox=manage:TSTextBox({
        Text="New Name",
        Placeholder="new-config"
    })

    manage:TSButton({
        Text="Rename Selected",
        Style="ghost",
        Callback=function()
            local newName=renameBox.GetText()

            if selected~="" and self:RenameConfig(selected,newName) then
                self:Notify("Config","Renamed successfully","success")
                selected=CleanName(newName)
                dropdown.SetOptions(self:GetConfigList())
            else
                self:Notify("Config","Rename failed","error")
            end
        end
    })

    local automation=tab:CreateSection("Automation","Optional autosave and autoload")

    automation:TSToggle({
        Text="Auto Save",
        Default=self.AutoSaveEnabled,
        Callback=function(value)
            self.AutoSaveEnabled=value
        end
    })

    automation:TSToggle({
        Text="Auto Load",
        Default=self.AutoLoadConfigEnabled,
        Callback=function(value)
            self.AutoLoadConfigEnabled=value

            if value and self.AutoLoadConfigName~="" then
                self:LoadConfig(self.AutoLoadConfigName)
            end
        end
    })

    automation:TSDropdown({
        Text="Auto Load Config",
        Options=self:GetConfigList(),
        Default=self.AutoLoadConfigName~="" and self.AutoLoadConfigName or nil,
        Callback=function(value)
            self.AutoLoadConfigName=value or ""
        end
    })

    local import=tab:CreateSection("Import","Paste JSON exported from Termin Scripts")

    local json=import:TSTextBox({
        Text="JSON",
        Placeholder="Paste config JSON...",
        Multiline=true
    })

    import:TSButton({
        Text="Apply JSON",
        Callback=function()
            local ok=self:ImportConfig(json.GetText())
            self:Notify("Config",ok and "Imported successfully" or "Invalid JSON",ok and "success" or "error")
        end
    })

    import:TSButton({
        Text="Paste Clipboard",
        Style="ghost",
        Callback=function()
            local clipboard=typeof(getclipboard)=="function" and getclipboard

            if clipboard then
                local ok,value=Safe(clipboard)

                if ok and type(value)=="string" then
                    json.SetText(value)
                    self:Notify("Clipboard","JSON pasted","success",1.8)
                end
            end
        end
    })

    return tab
end

local KeyApi="https://terminkeys.vercel.app/api"
local KeyFolder="TerminScriptsLib"
local KeyPath=KeyFolder.."/SavedKey.txt"

local function SaveKey(key)
    if not HasFileApi() then return end

    Safe(function()
        if not isfolder(KeyFolder) then
            makefolder(KeyFolder)
        end

        writefile(KeyPath,key)
    end)
end

local function LoadKey()
    if not HasFileApi() then return nil end

    local ok,value=Safe(function()
        if isfile(KeyPath) then
            return readfile(KeyPath)
        end
    end)

    if ok and value and value~="" then
        return value
    end

    return nil
end

local function VerifyKey(key)
    local ok,response=Request({
        Url=KeyApi.."/verify",
        Method="POST",
        Headers={
            ["Content-Type"]="application/json"
        },
        Body=HttpService:JSONEncode({
            action="verify-key",
            key=key,
            hwid=GetHwid(),
            userId=Player.UserId,
            username=Player.Name,
            displayName=Player.DisplayName
        })
    })

    if not ok or type(response)~="table" or not response.Body then
        return false,nil,"License server unavailable"
    end

    local decodedOk,data=Safe(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not decodedOk or type(data)~="table" then
        return false,nil,"Invalid license response"
    end

    if data.valid then
        return true,data,nil
    end

    return false,data,data.message or "Invalid key"
end

local function CreateKeyGui()
    local camera=workspace.CurrentCamera
    local viewport=camera and camera.ViewportSize or Vector2.new(1920,1080)
    local scale=math.clamp(math.sqrt((viewport.X/1920)*(viewport.Y/1080)),0.55,1.45)

    local gui=New("ScreenGui",PlayerGui,{
        Name="TerminKeySystemV6",
        ResetOnSpawn=false,
        IgnoreGuiInset=true,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        DisplayOrder=999
    })

    local overlay=New("Frame",gui,{
        Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.35,
        BorderSizePixel=0
    })

    local card=New("Frame",overlay,{
        Size=UDim2.fromOffset(0,0),
        Position=UDim2.fromScale(0.5,0.5),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=Theme.Background,
        BorderSizePixel=0,
        ClipsDescendants=true
    })

    Corner(card,22*scale)
    Stroke(card,Theme.Primary,0.25,1.4)
    Gradient(card,Theme.Background,Theme.Surface,135)

    Play(card,Tween.Spring,{
        Size=UDim2.fromOffset(480*scale,390*scale)
    })

    local logo=New("Frame",card,{
        Size=UDim2.fromOffset(54*scale,54*scale),
        Position=UDim2.new(0.5,-27*scale,0,28*scale),
        BackgroundColor3=Theme.Primary,
        BackgroundTransparency=0.08,
        BorderSizePixel=0
    })

    Corner(logo,17*scale)

    Text(logo,"TS",18,Contrast(Theme.Primary),Enum.Font.GothamBlack,{
        Size=UDim2.fromScale(1,1),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    Text(card,"TERMIN SCRIPTS",20,Theme.Text,Enum.Font.GothamBlack,{
        Size=UDim2.new(1,-40*scale,0,30*scale),
        Position=UDim2.fromOffset(20*scale,92*scale),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    Text(card,"Secure license authentication",11,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.new(1,-50*scale,0,20*scale),
        Position=UDim2.fromOffset(25*scale,123*scale),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    local inputFrame=New("Frame",card,{
        Size=UDim2.new(1,-60*scale,0,50*scale),
        Position=UDim2.fromOffset(30*scale,162*scale),
        BackgroundColor3=Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(inputFrame,12*scale)

    local inputStroke=Stroke(inputFrame,Theme.BorderStrong,0.35,1.2)

    local keyBox=New("TextBox",inputFrame,{
        Size=UDim2.new(1,-24*scale,1,0),
        Position=UDim2.fromOffset(12*scale,0),
        BackgroundTransparency=1,
        Text="",
        PlaceholderText="TERMIN-XXXX-XXXX-XXXX",
        PlaceholderColor3=Theme.Muted,
        TextColor3=Theme.Text,
        TextSize=13*scale,
        Font=Enum.Font.GothamMedium,
        ClearTextOnFocus=false
    })

    keyBox.Focused:Connect(function()
        Play(inputStroke,Tween.Fast,{
            Color=Theme.Primary,
            Transparency=0.08
        })
    end)

    keyBox.FocusLost:Connect(function()
        Play(inputStroke,Tween.Fast,{
            Color=Theme.BorderStrong,
            Transparency=0.35
        })
    end)

    local status=Text(card,"",11,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.new(1,-60*scale,0,26*scale),
        Position=UDim2.fromOffset(30*scale,218*scale),
        TextXAlignment=Enum.TextXAlignment.Center,
        TextWrapped=true
    })

    local submit=New("TextButton",card,{
        Size=UDim2.new(1,-60*scale,0,48*scale),
        Position=UDim2.fromOffset(30*scale,255*scale),
        BackgroundColor3=Theme.Primary,
        BorderSizePixel=0,
        Text="Authenticate",
        TextColor3=Contrast(Theme.Primary),
        TextSize=14*scale,
        Font=Enum.Font.GothamBold,
        AutoButtonColor=false
    })

    Corner(submit,12*scale)

    local deviceButton=New("TextButton",card,{
        Size=UDim2.fromOffset(155*scale,24*scale),
        Position=UDim2.new(0.5,-77.5*scale,1,-38*scale),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        Text="Copy Device ID",
        TextColor3=Theme.Muted,
        TextSize=10*scale,
        Font=Enum.Font.GothamMedium,
        AutoButtonColor=false
    })

    local api={}

    api.ScreenGui=gui
    api.Input=keyBox
    api.Submit=submit

    api.SetStatus=function(message,kind)
        status.Text=message or ""

        if kind=="success" then
            status.TextColor3=Theme.Success
        elseif kind=="error" then
            status.TextColor3=Theme.Danger
        else
            status.TextColor3=Theme.Muted
        end
    end

    api.SetLoading=function(loading)
        keyBox.TextEditable=not loading
        submit.Active=not loading
        submit.Text=loading and "Verifying..." or "Authenticate"
    end

    api.Destroy=function()
        if gui.Parent then
            gui:Destroy()
        end
    end

    deviceButton.MouseButton1Click:Connect(function()
        local clipboard=(typeof(setclipboard)=="function" and setclipboard)
            or (typeof(toclipboard)=="function" and toclipboard)

        if clipboard then
            Safe(clipboard,GetHwid())
            deviceButton.Text="Copied"
            task.delay(1.2,function()
                if deviceButton.Parent then
                    deviceButton.Text="Copy Device ID"
                end
            end)
        end
    end)

    return api
end

local function CreateLoader(onComplete)
    local camera=workspace.CurrentCamera
    local viewport=camera and camera.ViewportSize or Vector2.new(1920,1080)
    local scale=math.clamp(math.sqrt((viewport.X/1920)*(viewport.Y/1080)),0.55,1.45)

    local gui=New("ScreenGui",PlayerGui,{
        Name="TerminLoaderV6",
        ResetOnSpawn=false,
        IgnoreGuiInset=true,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        DisplayOrder=998
    })

    local overlay=New("Frame",gui,{
        Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.45,
        BorderSizePixel=0
    })

    local card=New("Frame",overlay,{
        Size=UDim2.fromOffset(430*scale,210*scale),
        Position=UDim2.fromScale(0.5,0.5),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=Theme.Background,
        BorderSizePixel=0
    })

    Corner(card,22*scale)
    Stroke(card,Theme.Primary,0.3,1.3)

    Text(card,"TERMIN SCRIPTS",22,Theme.Text,Enum.Font.GothamBlack,{
        Size=UDim2.new(1,-50*scale,0,30*scale),
        Position=UDim2.fromOffset(25*scale,35*scale),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    Text(card,"Initializing your interface",11,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.new(1,-50*scale,0,20*scale),
        Position=UDim2.fromOffset(25*scale,70*scale),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    local track=New("Frame",card,{
        Size=UDim2.new(1,-50*scale,0,6*scale),
        Position=UDim2.fromOffset(25*scale,115*scale),
        BackgroundColor3=Theme.Surface2,
        BorderSizePixel=0
    })

    Corner(track,4*scale)

    local fill=New("Frame",track,{
        Size=UDim2.new(0,0,1,0),
        BackgroundColor3=Theme.Primary,
        BorderSizePixel=0
    })

    Corner(fill,4*scale)
    Gradient(fill,Theme.Primary,Theme.PrimaryHover,0)

    local state=Text(card,"Starting...",10,Theme.Muted,Enum.Font.GothamMedium,{
        Size=UDim2.new(1,-50*scale,0,20*scale),
        Position=UDim2.fromOffset(25*scale,137*scale),
        TextXAlignment=Enum.TextXAlignment.Center
    })

    local phases={
        {"Connecting",0.25,0.42},
        {"Building interface",0.55,0.55},
        {"Applying configuration",0.82,0.48},
        {"Ready",1,0.38}
    }

    task.spawn(function()
        for _,phase in ipairs(phases) do
            state.Text=phase[1]

            Play(fill,Tween.Smooth,{
                Size=UDim2.new(phase[2],0,1,0)
            })

            task.wait(phase[3])
        end

        Play(card,Tween.Smooth,{
            Position=UDim2.new(0.5,0,0.5,-15*scale),
            BackgroundTransparency=1
        })

        task.wait(0.3)

        if gui.Parent then
            gui:Destroy()
        end

        if onComplete then
            onComplete()
        end
    end)
end

function Library.RunKeySystem(onSuccess)
    local gui=CreateKeyGui()
    local busy=false

    local function verify(key,automatic)
        if busy or not key or key=="" then
            if not automatic then
                gui.SetStatus("Enter a license key","error")
            end
            return
        end

        busy=true
        gui.SetLoading(true)
        gui.SetStatus(automatic and "Checking saved key..." or "Verifying key...","info")

        task.spawn(function()
            local ok,data,message=VerifyKey(key)

            busy=false
            gui.SetLoading(false)

            if ok then
                SaveKey(key)
                gui.SetStatus("Key verified. Loading...","success")

                task.delay(0.35,function()
                    gui.Destroy()

                    CreateLoader(function()
                        if onSuccess then
                            onSuccess(data)
                        end
                    end)
                end)
            else
                gui.SetStatus(
                    automatic and "" or (message or "Verification failed"),
                    automatic and "info" or "error"
                )
            end
        end)
    end

    gui.Submit.MouseButton1Click:Connect(function()
        verify(gui.Input.Text,false)
    end)

    gui.Input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            verify(gui.Input.Text,false)
        end
    end)

    local savedKey=LoadKey()

    if savedKey then
        verify(savedKey,true)
    end
end

function Library:Destroy()
    if self.Destroyed then return end

    self.Destroyed=true

    for _,connection in ipairs(self.Connections) do
        Safe(function()
            connection:Disconnect()
        end)
    end

    for _,close in ipairs(ActiveDropdowns) do
        Safe(close)
    end

    table.clear(ActiveDropdowns)

    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Library
