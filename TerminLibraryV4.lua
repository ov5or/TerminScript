local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local C = {
	WinBg        = Color3.fromRGB(8, 5, 18),
	HeaderBg     = Color3.fromRGB(12, 8, 26),
	SidebarBg    = Color3.fromRGB(11, 7, 24),
	Panel        = Color3.fromRGB(16, 11, 34),
	Elem         = Color3.fromRGB(22, 15, 46),
	ElemHover    = Color3.fromRGB(32, 22, 64),
	ElemActive   = Color3.fromRGB(44, 30, 85),
	Border       = Color3.fromRGB(55, 32, 100),
	BorderHi     = Color3.fromRGB(120, 60, 220),
	Violet       = Color3.fromRGB(130, 25, 255),
	VioletLt     = Color3.fromRGB(168, 76, 255),
	VioletDk     = Color3.fromRGB(95, 15, 190),
	VioletGlow   = Color3.fromRGB(200, 140, 255),
	Blue         = Color3.fromRGB(50, 90, 255),
	BlueLt       = Color3.fromRGB(90, 135, 255),
	Neon         = Color3.fromRGB(215, 130, 255),
	Green        = Color3.fromRGB(30, 210, 100),
	Red          = Color3.fromRGB(235, 50, 70),
	Yellow       = Color3.fromRGB(255, 190, 35),
	Cyan         = Color3.fromRGB(35, 195, 225),
	TextPri      = Color3.fromRGB(250, 246, 255),
	TextSec      = Color3.fromRGB(185, 160, 220),
	TextMut      = Color3.fromRGB(110, 88, 150),
	ToggleOff    = Color3.fromRGB(35, 22, 65),
	TrackBg      = Color3.fromRGB(26, 16, 52),
	Separator    = Color3.fromRGB(42, 26, 78),
	DropBg       = Color3.fromRGB(13, 8, 28),
	White        = Color3.fromRGB(255, 255, 255),
	Black        = Color3.fromRGB(0, 0, 0),
}

local function Tw(Obj, Props, Dur, Sty, Dir)
	TweenService:Create(Obj, TweenInfo.new(Dur or 0.15, Sty or Enum.EasingStyle.Quad, Dir or Enum.EasingDirection.Out), Props):Play()
end

local function N(Class, Props)
	local O = Instance.new(Class)
	for K, V in pairs(Props or {}) do
		if K ~= "Parent" then pcall(function() O[K] = V end) end
	end
	if Props and Props.Parent then O.Parent = Props.Parent end
	return O
end

local function Rnd(P, R)
	return N("UICorner", {Parent = P, CornerRadius = UDim.new(0, R or 6)})
end

local function Str(P, Color, Thick)
	return N("UIStroke", {Parent = P, Color = Color or C.Border, Thickness = Thick or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end

local function Pad(P, T, R, B, L)
	return N("UIPadding", {Parent = P, PaddingTop = UDim.new(0, T or 6), PaddingRight = UDim.new(0, R or 6), PaddingBottom = UDim.new(0, B or 6), PaddingLeft = UDim.new(0, L or 6)})
end

local function Lst(P, Gap, Dir)
	return N("UIListLayout", {Parent = P, SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Dir or Enum.FillDirection.Vertical, Padding = UDim.new(0, Gap or 5)})
end

local function Grad(P, A, B, Rot)
	return N("UIGradient", {Parent = P, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, A), ColorSequenceKeypoint.new(1, B)}), Rotation = Rot or 0})
end

local function GradAlpha(P, A, B, Rot)
	return N("UIGradient", {Parent = P, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, A), NumberSequenceKeypoint.new(1, B)}), Rotation = Rot or 0})
end

local function Drag(Frame, Handle)
	local On, Org, Start = false, nil, nil
	Handle.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then On = true Org = I.Position Start = Frame.Position end end)
	Handle.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then On = false end end)
	UserInputService.InputChanged:Connect(function(I) if On and I.UserInputType == Enum.UserInputType.MouseMovement then local D = I.Position - Org Frame.Position = UDim2.new(Start.X.Scale, Start.X.Offset + D.X, Start.Y.Scale, Start.Y.Offset + D.Y) end end)
end

local function ToHex(Clr)
	return string.format("%02X%02X%02X", math.floor(Clr.R*255+0.5), math.floor(Clr.G*255+0.5), math.floor(Clr.B*255+0.5))
end

local function FromHex(Hex)
	Hex = Hex:gsub("[^%x]","")
	if #Hex == 6 then
		local R, G, B = tonumber(Hex:sub(1,2),16), tonumber(Hex:sub(3,4),16), tonumber(Hex:sub(5,6),16)
		if R and G and B then return Color3.fromRGB(R, G, B) end
	end
end

local NotifGui = nil
local NotifHolder = nil
local NotifIdx = 0

local function GetNotifHolder()
	if NotifHolder and NotifHolder.Parent then return NotifHolder end
	NotifGui = N("ScreenGui", {Name="__Notif", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=(pcall(function() return CoreGui end)) and CoreGui or LocalPlayer.PlayerGui})
	NotifHolder = N("Frame", {Parent=NotifGui, Size=UDim2.fromOffset(320,0), Position=UDim2.new(1,-330,1,-10), AnchorPoint=Vector2.new(0,1), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y})
	Lst(NotifHolder, 6)
	NotifHolder:FindFirstChildOfClass("UIListLayout").VerticalAlignment = Enum.VerticalAlignment.Bottom
	return NotifHolder
end

local NotifTypeColor = {
	Success = C.Green,
	Error   = C.Red,
	Warning = C.Yellow,
	Info    = C.Cyan,
}

local function Notify(Opts)
	Opts = Opts or {}
	local Holder = GetNotifHolder()
	local TypeClr = NotifTypeColor[Opts.Type or "Info"] or C.Cyan
	local Dur = Opts.Duration or 4
	NotifIdx = NotifIdx + 1

	local Card = N("Frame", {Parent=Holder, Size=UDim2.fromOffset(320, 72), BackgroundColor3=C.Panel, BorderSizePixel=0, LayoutOrder=NotifIdx, BackgroundTransparency=1, ClipsDescendants=true})
	Rnd(Card, 9)
	Str(Card, TypeClr, 1)
	Card:FindFirstChildOfClass("UIStroke").Transparency = 0.4

	local SideBar = N("Frame", {Parent=Card, Size=UDim2.new(0,4,1,0), BackgroundColor3=TypeClr, BorderSizePixel=0})
	Rnd(SideBar, 2)

	N("TextLabel", {Parent=Card, Size=UDim2.new(1,-50,0,22), Position=UDim2.new(0,14,0,10), BackgroundTransparency=1, Text=Opts.Title or Opts.Type or "Info", TextColor3=TypeClr, TextSize=13, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left})
	N("TextLabel", {Parent=Card, Size=UDim2.new(1,-20,0,28), Position=UDim2.new(0,14,0,33), BackgroundTransparency=1, Text=Opts.Content or "", TextColor3=C.TextSec, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true})

	local Bar = N("Frame", {Parent=Card, Size=UDim2.new(1,0,0,3), Position=UDim2.new(0,0,1,-3), BackgroundColor3=TypeClr, BorderSizePixel=0})
	Tw(Card, {BackgroundTransparency=0}, 0.22, Enum.EasingStyle.Quart)
	Tw(Bar, {Size=UDim2.new(0,0,0,3)}, Dur, Enum.EasingStyle.Linear)

	task.delay(Dur, function()
		Tw(Card, {BackgroundTransparency=1, Position=UDim2.new(1,15,0,0)}, 0.28, Enum.EasingStyle.Quart)
		task.delay(0.3, function() Card:Destroy() end)
	end)
end

local Library = {Notify = Notify}

function Library.CreateWatermark(Text)
	local WGui = N("ScreenGui", {Name="__Watermark", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=(pcall(function() return CoreGui end)) and CoreGui or LocalPlayer.PlayerGui})
	local Mark = N("Frame", {Parent=WGui, Size=UDim2.fromOffset(0,28), Position=UDim2.new(0,10,0,10), BackgroundColor3=C.Panel, AutomaticSize=Enum.AutomaticSize.X, BorderSizePixel=0})
	Rnd(Mark, 7)
	Str(Mark, C.Violet, 1)
	Mark:FindFirstChildOfClass("UIStroke").Transparency = 0.5
	Pad(Mark, 0, 12, 0, 12)

	local Bg = N("Frame", {Parent=Mark, Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Violet, BackgroundTransparency=0.88, BorderSizePixel=0})
	Grad(Bg, C.Violet, C.Blue, 0)

	local Lbl = N("TextLabel", {Parent=Mark, Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X, BackgroundTransparency=1, Text=Text or "", TextColor3=C.TextSec, TextSize=12, Font=Enum.Font.GothamBold})

	local Obj = {}
	function Obj:SetText(T) Lbl.Text = T end
	function Obj:Destroy() WGui:Destroy() end
	return Obj
end

function Library.SaveConfig(Name, Data)
	pcall(function() writefile(Name..".json", HttpService:JSONEncode(Data)) end)
end

function Library.LoadConfig(Name)
	local Ok, Res = pcall(function() return HttpService:JSONDecode(readfile(Name..".json")) end)
	return Ok and Res or nil
end

function Library.CreateWindow(Opts)
	Opts = Opts or {}
	local Title     = Opts.Title     or "UI Library"
	local Subtitle  = Opts.Subtitle  or ""
	local Width     = Opts.Width     or 610
	local Height    = Opts.Height    or 465
	local ToggleKey = Opts.ToggleKey

	local Root = (pcall(function() return CoreGui end)) and CoreGui or LocalPlayer.PlayerGui
	local Gui = N("ScreenGui", {Name=Title, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=Root})

	local Win = N("Frame", {Parent=Gui, Size=UDim2.fromOffset(Width, Height), Position=UDim2.fromScale(0.5, 0.5), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=C.WinBg, BorderSizePixel=0, ClipsDescendants=true})
	Rnd(Win, 12)
	Str(Win, C.Violet, 1)
	Win:FindFirstChildOfClass("UIStroke").Transparency = 0.45

	local TopStrip = N("Frame", {Parent=Win, Size=UDim2.new(1,0,0,3), BackgroundColor3=C.Violet, BorderSizePixel=0, ZIndex=6})
	Grad(TopStrip, C.Blue, C.Violet, 0)

	local TopGlow = N("Frame", {Parent=Win, Size=UDim2.new(1,0,0,60), BackgroundColor3=C.Violet, BackgroundTransparency=0.94, BorderSizePixel=0, ZIndex=2})
	Grad(TopGlow, C.Violet, C.WinBg, 90)

	local Header = N("Frame", {Parent=Win, Size=UDim2.new(1,0,0,54), Position=UDim2.new(0,0,0,3), BackgroundColor3=C.HeaderBg, BorderSizePixel=0, ZIndex=3})

	N("Frame", {Parent=Header, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1), BackgroundColor3=C.Separator, BorderSizePixel=0, ZIndex=4})

	local TitleLbl = N("TextLabel", {Parent=Header, Size=UDim2.new(0,320,0,26), Position=UDim2.new(0,16,0,Subtitle~="" and 4 or 14), BackgroundTransparency=1, Text=Title, TextColor3=C.TextPri, TextSize=15, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4})

	if Subtitle ~= "" then
		TitleLbl.TextSize = 14
		N("TextLabel", {Parent=Header, Size=UDim2.new(0,320,0,15), Position=UDim2.new(0,16,0,30), BackgroundTransparency=1, Text=Subtitle, TextColor3=C.TextMut, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4})
	end

	local function MkBtn(OffX, Icon, NormBg, HoverBg, HoverTxt)
		local Btn = N("TextButton", {Parent=Header, Size=UDim2.fromOffset(26,26), Position=UDim2.new(1,OffX,0.5,-13), BackgroundColor3=NormBg, BorderSizePixel=0, Text=Icon, TextColor3=C.TextMut, TextSize=13, Font=Enum.Font.GothamBold, AutoButtonColor=false, ZIndex=4})
		Rnd(Btn, 6)
		Btn.MouseEnter:Connect(function() Tw(Btn, {BackgroundColor3=HoverBg, TextColor3=HoverTxt or C.White}) end)
		Btn.MouseLeave:Connect(function() Tw(Btn, {BackgroundColor3=NormBg, TextColor3=C.TextMut}) end)
		return Btn
	end

	local BtnClose = MkBtn(-34, "✕", Color3.fromRGB(48,20,65), C.Red)
	local BtnMin   = MkBtn(-64, "—", Color3.fromRGB(35,22,60), C.ElemHover, C.TextPri)
	local BtnPin   = MkBtn(-94, "⊞", Color3.fromRGB(35,22,60), C.ElemHover, C.TextPri)

	local Pinned = false
	BtnPin.MouseButton1Click:Connect(function()
		Pinned = not Pinned
		BtnPin.TextColor3 = Pinned and C.VioletLt or C.TextMut
	end)

	local Minimized = false
	BtnMin.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		if Minimized then
			Tw(Win, {Size=UDim2.fromOffset(Width,57)}, 0.28, Enum.EasingStyle.Quart)
		else
			Tw(Win, {Size=UDim2.fromOffset(Width,Height)}, 0.28, Enum.EasingStyle.Quart)
		end
	end)

	BtnClose.MouseButton1Click:Connect(function()
		Tw(Win, {BackgroundTransparency=1, Size=UDim2.fromOffset(Width*0.92,Height*0.92)}, 0.2, Enum.EasingStyle.Quart)
		task.delay(0.22, function() Gui:Destroy() end)
	end)

	local GuiVisible = true
	if ToggleKey then
		UserInputService.InputBegan:Connect(function(Input, GP)
			if GP or Pinned then return end
			if Input.KeyCode == ToggleKey then
				GuiVisible = not GuiVisible
				if GuiVisible then
					Win.Visible = true
					Tw(Win, {BackgroundTransparency=0, Size=UDim2.fromOffset(Width,Height)}, 0.22, Enum.EasingStyle.Quart)
				else
					Tw(Win, {BackgroundTransparency=1, Size=UDim2.fromOffset(Width*0.96,Height*0.96)}, 0.18, Enum.EasingStyle.Quart)
					task.delay(0.2, function() if not GuiVisible then Win.Visible = false end end)
				end
			end
		end)
	end

	local Body = N("Frame", {Parent=Win, Size=UDim2.new(1,0,1,-57), Position=UDim2.new(0,0,0,57), BackgroundTransparency=1, ClipsDescendants=true})

	local Sidebar = N("Frame", {Parent=Body, Size=UDim2.new(0,152,1,0), BackgroundColor3=C.SidebarBg, BorderSizePixel=0})
	N("Frame", {Parent=Sidebar, Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,0,0,0), BackgroundColor3=C.Separator, BorderSizePixel=0})

	local SideGlow = N("Frame", {Parent=Sidebar, Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Violet, BackgroundTransparency=0.96, BorderSizePixel=0})
	Grad(SideGlow, C.Violet, C.SidebarBg, 0)

	local TabScroll = N("ScrollingFrame", {Parent=Sidebar, Size=UDim2.new(1,0,1,-6), Position=UDim2.new(0,0,0,8), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=0, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollingDirection=Enum.ScrollingDirection.Y})
	Pad(TabScroll, 0, 8, 4, 8)
	Lst(TabScroll, 3)

	local ContentArea = N("Frame", {Parent=Body, Size=UDim2.new(1,-152,1,0), Position=UDim2.new(0,152,0,0), BackgroundTransparency=1})

	Drag(Win, Header)

	local Window = {Gui=Gui, Frame=Win, ActiveTab=nil, AllTabs={}}

	function Window:CreateTab(TabOpts)
		TabOpts = TabOpts or {}
		local Name = TabOpts.Name or "Tab"
		local Icon = TabOpts.Icon or ""

		local TabBtn = N("TextButton", {Parent=TabScroll, Size=UDim2.new(1,0,0,36), BackgroundColor3=C.SidebarBg, BorderSizePixel=0, Text="", AutoButtonColor=false, ClipsDescendants=true})
		Rnd(TabBtn, 7)

		local IndBar = N("Frame", {Parent=TabBtn, Size=UDim2.new(0,3,0.55,0), Position=UDim2.new(0,0,0.225,0), BackgroundColor3=C.Violet, BorderSizePixel=0, Visible=false})
		Rnd(IndBar, 2)

		local IndGlow = N("Frame", {Parent=TabBtn, Size=UDim2.new(0,28,1,0), BackgroundColor3=C.Violet, BackgroundTransparency=1, BorderSizePixel=0})
		GradAlpha(IndGlow, 0.78, 1, 0)

		local IcoLbl = N("TextLabel", {Parent=TabBtn, Size=UDim2.fromOffset(22,36), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=Icon, TextColor3=C.TextMut, TextSize=14, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Center})
		local NameLbl = N("TextLabel", {Parent=TabBtn, Size=UDim2.new(1, Icon~="" and -38 or -18, 1, 0), Position=UDim2.new(0, Icon~="" and 34 or 12, 0, 0), BackgroundTransparency=1, Text=Name, TextColor3=C.TextMut, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left})

		local TabContent = N("ScrollingFrame", {Parent=ContentArea, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=C.Violet, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollingDirection=Enum.ScrollingDirection.Y, Visible=false})
		Pad(TabContent, 10, 14, 10, 14)
		Lst(TabContent, 8)

		local Tab = {Button=TabBtn, Content=TabContent}

		local function Activate()
			if Window.ActiveTab and Window.ActiveTab ~= Tab then
				local Prev = Window.ActiveTab
				Tw(Prev.Button, {BackgroundColor3=C.SidebarBg})
				for _, Ch in pairs(Prev.Button:GetDescendants()) do
					if Ch:IsA("TextLabel") then Tw(Ch, {TextColor3=C.TextMut}) end
					if Ch.Name == "Frame" then Ch.Visible = false end
				end
				Prev.Content.Visible = false
			end
			Window.ActiveTab = Tab
			Tw(TabBtn, {BackgroundColor3=C.Elem})
			NameLbl.Font = Enum.Font.GothamBold
			Tw(NameLbl, {TextColor3=C.TextPri})
			Tw(IcoLbl, {TextColor3=C.VioletLt})
			IndBar.Visible = true
			Tw(IndGlow, {BackgroundTransparency=0.78})
			TabContent.Visible = true
		end

		TabBtn.MouseButton1Click:Connect(Activate)
		TabBtn.MouseEnter:Connect(function() if Window.ActiveTab ~= Tab then Tw(TabBtn, {BackgroundColor3=C.ElemHover}) Tw(NameLbl, {TextColor3=C.TextSec}) end end)
		TabBtn.MouseLeave:Connect(function() if Window.ActiveTab ~= Tab then Tw(TabBtn, {BackgroundColor3=C.SidebarBg}) Tw(NameLbl, {TextColor3=C.TextMut}) end end)

		if #Window.AllTabs == 0 then Activate() end
		table.insert(Window.AllTabs, Tab)

		function Tab:CreateSection(SecOpts)
			SecOpts = SecOpts or {}

			local SecFrame = N("Frame", {Parent=TabContent, Size=UDim2.new(1,0,0,0), BackgroundColor3=C.Panel, BorderSizePixel=0, AutomaticSize=Enum.AutomaticSize.Y, ClipsDescendants=true})
			Rnd(SecFrame, 9)
			Str(SecFrame, C.Border, 1)

			local ElemsContainer = N("Frame", {Parent=SecFrame, Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y})
			Pad(ElemsContainer, 8, 10, 10, 10)
			Lst(ElemsContainer, 5)

			local SecHeaderHeight = 0

			if SecOpts.Name then
				SecHeaderHeight = 32
				ElemsContainer.Position = UDim2.new(0,0,0,32)

				local SHdr = N("Frame", {Parent=SecFrame, Size=UDim2.new(1,0,0,32), BackgroundColor3=C.Elem, BorderSizePixel=0, ZIndex=2})
				Rnd(SHdr, 9)
				N("Frame", {Parent=SHdr, Size=UDim2.new(1,0,0,9), Position=UDim2.new(0,0,1,-9), BackgroundColor3=C.Elem, BorderSizePixel=0, ZIndex=2})

				local AccLine = N("Frame", {Parent=SHdr, Size=UDim2.new(0,3,0.5,0), Position=UDim2.new(0,0,0.25,0), BackgroundColor3=C.Violet, BorderSizePixel=0})
				Rnd(AccLine, 2)

				N("TextLabel", {Parent=SHdr, Size=UDim2.new(1,-50,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=SecOpts.Name:upper(), TextColor3=C.VioletGlow, TextSize=10, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3})

				local CollapseArrow = N("TextLabel", {Parent=SHdr, Size=UDim2.fromOffset(22,32), Position=UDim2.new(1,-26,0,0), BackgroundTransparency=1, Text="▾", TextColor3=C.TextMut, TextSize=13, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=3})

				local IsCollapsed = SecOpts.Collapsed == true
				if IsCollapsed then
					CollapseArrow.Rotation = -90
					SecFrame.AutomaticSize = Enum.AutomaticSize.None
					SecFrame.Size = UDim2.new(1,0,0,32)
				end

				local CollapseBtn = N("TextButton", {Parent=SHdr, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=4})
				CollapseBtn.MouseButton1Click:Connect(function()
					IsCollapsed = not IsCollapsed
					if IsCollapsed then
						SecFrame.AutomaticSize = Enum.AutomaticSize.None
						Tw(SecFrame, {Size=UDim2.new(1,0,0,32)}, 0.2, Enum.EasingStyle.Quart)
						Tw(CollapseArrow, {Rotation=-90}, 0.2)
					else
						Tw(CollapseArrow, {Rotation=0}, 0.2)
						task.delay(0.18, function() SecFrame.AutomaticSize = Enum.AutomaticSize.Y end)
					end
				end)

				N("Frame", {Parent=SecFrame, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,32), BackgroundColor3=C.Separator, BorderSizePixel=0})
			end

			local Section = {}
			local EOrder = 0
			local function NextOrd() EOrder = EOrder + 1 return EOrder end

			local function ERow(H, Options)
				local Row = N("Frame", {Parent=ElemsContainer, Size=UDim2.new(1,0,0,H or 35), BackgroundColor3=C.Elem, BorderSizePixel=0, LayoutOrder=NextOrd(), ClipsDescendants=true})
				Rnd(Row, 7)
				Str(Row, C.Border, 1)
				if Options and Options.Gradient then
					local GF = N("Frame", {Parent=Row, Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Violet, BackgroundTransparency=1, BorderSizePixel=0})
					Grad(GF, C.Violet, C.Blue, 0)
					return Row, GF
				end
				return Row
			end

			function Section:CreateSeparator(Label)
				local Row = N("Frame", {Parent=ElemsContainer, Size=UDim2.new(1,0,0,Label and 22 or 8), BackgroundTransparency=1, LayoutOrder=NextOrd()})
				if Label then
					N("TextLabel", {Parent=Row, Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, Text=Label:upper(), TextColor3=C.TextMut, TextSize=9, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left})
				end
				N("Frame", {Parent=Row, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1), BackgroundColor3=C.Separator, BorderSizePixel=0})
			end

			function Section:CreateLabel(LblOpts)
				LblOpts = LblOpts or {}
				local Row = N("Frame", {Parent=ElemsContainer, Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, LayoutOrder=NextOrd(), AutomaticSize=Enum.AutomaticSize.Y})
				local Lbl = N("TextLabel", {Parent=Row, Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, Text=LblOpts.Text or "", TextColor3=LblOpts.Color or C.TextMut, TextSize=12, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y})
				local Obj = {}
				function Obj:Set(T) Lbl.Text = T end
				function Obj:SetColor(Col) Lbl.TextColor3 = Col end
				return Obj
			end

			function Section:CreateButton(BtnOpts)
				BtnOpts = BtnOpts or {}
				local Row, GF = ERow(36, {Gradient=true})

				N("TextLabel", {Parent=Row, Size=UDim2.new(1,-36,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=BtnOpts.Name or "Button", TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2})
				N("TextLabel", {Parent=Row, Size=UDim2.fromOffset(22,36), Position=UDim2.new(1,-26,0,0), BackgroundTransparency=1, Text="›", TextColor3=C.Violet, TextSize=22, Font=Enum.Font.GothamBold, ZIndex=2})

				if BtnOpts.Description then
					N("TextLabel", {Parent=Row, Size=UDim2.new(1,-80,0,14), Position=UDim2.new(0,12,1,-16), BackgroundTransparency=1, Text=BtnOpts.Description, TextColor3=C.TextMut, TextSize=10, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2})
					Row.Size = UDim2.new(1,0,0,46)
				end

				local Hit = N("TextButton", {Parent=Row, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=3})
				Hit.MouseEnter:Connect(function() Tw(Row, {BackgroundColor3=C.ElemHover}) Tw(GF, {BackgroundTransparency=0.9}) end)
				Hit.MouseLeave:Connect(function() Tw(Row, {BackgroundColor3=C.Elem}) Tw(GF, {BackgroundTransparency=1}) end)
				Hit.MouseButton1Click:Connect(function()
					Tw(GF, {BackgroundTransparency=0.8}, 0.07)
					task.delay(0.14, function() Tw(GF, {BackgroundTransparency=1}) Tw(Row, {BackgroundColor3=C.Elem}) end)
					if BtnOpts.Callback then pcall(BtnOpts.Callback) end
				end)
				return {}
			end

			function Section:CreateToggle(TglOpts)
				TglOpts = TglOpts or {}
				local State = TglOpts.Default == true

				local Row = ERow(36)
				N("TextLabel", {Parent=Row, Size=UDim2.new(1,-70,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=TglOpts.Name or "Toggle", TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left})

				local Track = N("Frame", {Parent=Row, Size=UDim2.fromOffset(44,24), Position=UDim2.new(1,-54,0.5,-12), BackgroundColor3=State and C.Violet or C.ToggleOff, BorderSizePixel=0})
				Rnd(Track, 12)
				local TrkStr = Str(Track, State and C.Violet or C.Border, 1)

				local Glow = N("Frame", {Parent=Track, Size=UDim2.new(1,10,1,10), Position=UDim2.new(0,-5,0,-5), BackgroundColor3=C.Violet, BackgroundTransparency=State and 0.72 or 1, BorderSizePixel=0, ZIndex=0})
				Rnd(Glow, 14)

				local Knob = N("Frame", {Parent=Track, Size=UDim2.fromOffset(18,18), Position=State and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9), BackgroundColor3=C.White, BorderSizePixel=0, ZIndex=2})
				Rnd(Knob, 9)

				local Hit = N("TextButton", {Parent=Row, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=2})

				local function Apply(NS, Fire)
					State = NS
					if State then
						Tw(Track, {BackgroundColor3=C.Violet})
						Tw(Knob, {Position=UDim2.new(1,-21,0.5,-9)})
						Tw(Glow, {BackgroundTransparency=0.72})
						TrkStr.Color = C.Violet
					else
						Tw(Track, {BackgroundColor3=C.ToggleOff})
						Tw(Knob, {Position=UDim2.new(0,3,0.5,-9)})
						Tw(Glow, {BackgroundTransparency=1})
						TrkStr.Color = C.Border
					end
					if Fire and TglOpts.Callback then pcall(TglOpts.Callback, State) end
				end

				Hit.MouseEnter:Connect(function() Tw(Row, {BackgroundColor3=C.ElemHover}) end)
				Hit.MouseLeave:Connect(function() Tw(Row, {BackgroundColor3=C.Elem}) end)
				Hit.MouseButton1Click:Connect(function() Apply(not State, true) end)

				local Obj = {}
				function Obj:Set(V) Apply(V==true, true) end
				function Obj:Get() return State end
				return Obj
			end

			function Section:CreateSlider(SldOpts)
				SldOpts = SldOpts or {}
				local Min   = SldOpts.Min     or 0
				local Max   = SldOpts.Max     or 100
				local Suf   = SldOpts.Suffix  or ""
				local IsInt = SldOpts.Integer ~= false
				local Value = math.clamp(SldOpts.Default or Min, Min, Max)

				local Row = N("Frame", {Parent=ElemsContainer, Size=UDim2.new(1,0,0,54), BackgroundColor3=C.Elem, BorderSizePixel=0, LayoutOrder=NextOrd()})
				Rnd(Row, 7)
				Str(Row, C.Border, 1)

				N("TextLabel", {Parent=Row, Size=UDim2.new(0.62,0,0,28), Position=UDim2.new(0,12,0,4), BackgroundTransparency=1, Text=SldOpts.Name or "Slider", TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left})
				local ValLbl = N("TextLabel", {Parent=Row, Size=UDim2.new(0.38,-12,0,28), Position=UDim2.new(0.62,0,0,4), BackgroundTransparency=1, Text=tostring(Value)..Suf, TextColor3=C.VioletGlow, TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Right})

				local Track = N("Frame", {Parent=Row, Size=UDim2.new(1,-24,0,6), Position=UDim2.new(0,12,0,40), BackgroundColor3=C.TrackBg, BorderSizePixel=0})
				Rnd(Track, 3)

				local Ratio0 = (Value - Min) / (Max - Min)
				local Fill = N("Frame", {Parent=Track, Size=UDim2.new(Ratio0,0,1,0), BackgroundColor3=C.Violet, BorderSizePixel=0})
				Rnd(Fill, 3)
				Grad(Fill, C.Blue, C.Violet, 0)

				local Thumb = N("Frame", {Parent=Track, Size=UDim2.fromOffset(16,16), Position=UDim2.new(Ratio0,-8,0.5,-8), BackgroundColor3=C.White, BorderSizePixel=0, ZIndex=2})
				Rnd(Thumb, 8)
				N("UIStroke", {Parent=Thumb, Color=C.Violet, Thickness=2})

				local Dragging = false
				local function ApplySlider(IX)
					local Ratio = math.clamp((IX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
					Value = IsInt and math.round(Min+(Max-Min)*Ratio) or (math.floor((Min+(Max-Min)*Ratio)*10+0.5)/10)
					ValLbl.Text = tostring(Value)..Suf
					Fill.Size = UDim2.new(Ratio,0,1,0)
					Thumb.Position = UDim2.new(Ratio,-8,0.5,-8)
					if SldOpts.Callback then pcall(SldOpts.Callback, Value) end
				end

				local SBtn = N("TextButton", {Parent=Track, Size=UDim2.new(1,0,4,-16), Position=UDim2.new(0,0,0,-16), BackgroundTransparency=1, Text="", ZIndex=3})
				SBtn.InputBegan:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Dragging=true ApplySlider(I.Position.X) end end)
				SBtn.InputEnded:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Dragging=false end end)
				UserInputService.InputChanged:Connect(function(I) if Dragging and I.UserInputType==Enum.UserInputType.MouseMovement then ApplySlider(I.Position.X) end end)

				local Obj = {}
				function Obj:Set(NV)
					Value = math.clamp(NV, Min, Max)
					local R = (Value-Min)/(Max-Min)
					ValLbl.Text = tostring(Value)..Suf
					Fill.Size = UDim2.new(R,0,1,0)
					Thumb.Position = UDim2.new(R,-8,0.5,-8)
				end
				function Obj:Get() return Value end
				return Obj
			end

			function Section:CreateDropdown(DdOpts)
				DdOpts = DdOpts or {}
				local Items    = DdOpts.Items   or {}
				local Selected = DdOpts.Default or Items[1] or ""
				local Open     = false

				local Row = N("Frame", {Parent=ElemsContainer, Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Elem, BorderSizePixel=0, LayoutOrder=NextOrd(), ZIndex=2, ClipsDescendants=false})
				Rnd(Row, 7)
				Str(Row, C.Border, 1)

				N("TextLabel", {Parent=Row, Size=UDim2.new(1,-130,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=DdOpts.Name or "Dropdown", TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2})
				local SelLbl = N("TextLabel", {Parent=Row, Size=UDim2.fromOffset(108,36), Position=UDim2.new(1,-116,0,0), BackgroundTransparency=1, Text=tostring(Selected), TextColor3=C.VioletGlow, TextSize=12, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Right, ZIndex=2})
				local Arrow = N("TextLabel", {Parent=Row, Size=UDim2.fromOffset(16,36), Position=UDim2.new(1,-18,0,0), BackgroundTransparency=1, Text="▾", TextColor3=C.TextMut, TextSize=12, Font=Enum.Font.GothamBold, ZIndex=2})

				local Panel = N("Frame", {Parent=Row, Size=UDim2.new(1,2,0,0), Position=UDim2.new(0,-1,1,5), BackgroundColor3=C.DropBg, BorderSizePixel=0, ZIndex=14, Visible=false, ClipsDescendants=true})
				Rnd(Panel, 8)
				Str(Panel, C.Border, 1)

				local SearchRow = N("Frame", {Parent=Panel, Size=UDim2.new(1,-12,0,28), Position=UDim2.new(0,6,0,5), BackgroundColor3=C.Elem, BorderSizePixel=0, ZIndex=15})
				Rnd(SearchRow, 5)
				Str(SearchRow, C.Border, 1)
				N("TextLabel", {Parent=SearchRow, Size=UDim2.fromOffset(24,28), BackgroundTransparency=1, Text="⌕", TextColor3=C.TextMut, TextSize=14, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=15})
				local SearchBox = N("TextBox", {Parent=SearchRow, Size=UDim2.new(1,-28,1,0), Position=UDim2.new(0,26,0,0), BackgroundTransparency=1, Text="", PlaceholderText="Search...", PlaceholderColor3=C.TextMut, TextColor3=C.TextPri, TextSize=12, Font=Enum.Font.Gotham, BorderSizePixel=0, ClearTextOnFocus=false, ZIndex=16})

				local DropList = N("ScrollingFrame", {Parent=Panel, Size=UDim2.new(1,0,1,-40), Position=UDim2.new(0,0,0,38), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, ScrollBarImageColor3=C.Violet, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=14})
				Pad(DropList, 2, 6, 4, 6)
				Lst(DropList, 2)

				local function Build(Filter)
					for _, Ch in pairs(DropList:GetChildren()) do if Ch:IsA("TextButton") then Ch:Destroy() end end
					for _, Item in ipairs(Items) do
						local Str2 = tostring(Item)
						if Filter and Filter ~= "" and not Str2:lower():find(Filter:lower(),1,true) then continue end
						local IsSel = Str2 == tostring(Selected)
						local IBtn = N("TextButton", {Parent=DropList, Size=UDim2.new(1,0,0,28), BackgroundColor3=IsSel and C.VioletDk or C.DropBg, BackgroundTransparency=IsSel and 0 or 1, Text=Str2, TextColor3=IsSel and C.TextPri or C.TextSec, TextSize=12, Font=IsSel and Enum.Font.GothamBold or Enum.Font.Gotham, BorderSizePixel=0, AutoButtonColor=false, ZIndex=15})
						Rnd(IBtn, 5)
						IBtn.MouseEnter:Connect(function() if not IsSel then Tw(IBtn,{BackgroundTransparency=0,BackgroundColor3=C.ElemHover}) Tw(IBtn,{TextColor3=C.TextPri}) end end)
						IBtn.MouseLeave:Connect(function() if not IsSel then Tw(IBtn,{BackgroundTransparency=1}) Tw(IBtn,{TextColor3=C.TextSec}) end end)
						IBtn.MouseButton1Click:Connect(function()
							Selected = Item
							SelLbl.Text = tostring(Selected)
							Build(SearchBox.Text)
							if DdOpts.Callback then pcall(DdOpts.Callback, Selected) end
						end)
					end
				end

				SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Build(SearchBox.Text) end)
				Build()

				local function Toggle()
					Open = not Open
					local PH = math.min(#Items,6)*30+48
					if Open then
						SearchBox.Text = ""
						Build()
						Panel.Visible = true
						Tw(Panel, {Size=UDim2.new(1,2,0,PH)}, 0.22, Enum.EasingStyle.Quart)
						Tw(Arrow, {Rotation=180}, 0.2)
					else
						Tw(Panel, {Size=UDim2.new(1,2,0,0)}, 0.15)
						Tw(Arrow, {Rotation=0}, 0.15)
						task.delay(0.16, function() if not Open then Panel.Visible = false end end)
					end
				end

				local Hit = N("TextButton", {Parent=Row, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=3})
				Hit.MouseButton1Click:Connect(Toggle)

				local Obj = {}
				function Obj:Set(V) Selected=V SelLbl.Text=tostring(V) Build() end
				function Obj:Get() return Selected end
				function Obj:SetItems(NI) Items=NI Build() end
				return Obj
			end

			function Section:CreateColorPicker(CPOpts)
				CPOpts = CPOpts or {}
				local CurColor = CPOpts.Default or Color3.fromRGB(130,25,255)
				local H, S, V = Color3.toHSV(CurColor)
				local Open = false

				local Row = N("Frame", {Parent=ElemsContainer, Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Elem, BorderSizePixel=0, LayoutOrder=NextOrd(), ZIndex=2, ClipsDescendants=false})
				Rnd(Row, 7)
				Str(Row, C.Border, 1)

				N("TextLabel", {Parent=Row, Size=UDim2.new(1,-90,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=CPOpts.Name or "Color Picker", TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2})
				local Preview = N("Frame", {Parent=Row, Size=UDim2.fromOffset(34,20), Position=UDim2.new(1,-46,0.5,-10), BackgroundColor3=CurColor, BorderSizePixel=0, ZIndex=2})
				Rnd(Preview, 5)
				Str(Preview, C.Border, 1)

				local PickPanel = N("Frame", {Parent=Row, Size=UDim2.new(1,2,0,0), Position=UDim2.new(0,-1,1,5), BackgroundColor3=C.DropBg, BorderSizePixel=0, ZIndex=14, Visible=false, ClipsDescendants=true})
				Rnd(PickPanel, 9)
				Str(PickPanel, C.Border, 1)

				local Inner = N("Frame", {Parent=PickPanel, Size=UDim2.new(1,-18,0,205), Position=UDim2.new(0,9,0,9), BackgroundTransparency=1, ZIndex=14})

				local SVBox = N("Frame", {Parent=Inner, Size=UDim2.new(1,0,0,126), BackgroundColor3=Color3.fromHSV(H,1,1), BorderSizePixel=0, ZIndex=14, ClipsDescendants=true})
				Rnd(SVBox, 6)
				N("UIGradient", {Parent=SVBox, Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.White),ColorSequenceKeypoint.new(1,C.White)}), Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}), Rotation=0})
				local BL = N("Frame", {Parent=SVBox, Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Black, BorderSizePixel=0, ZIndex=15})
				Rnd(BL,6)
				GradAlpha(BL, 1, 0, 90)

				local SVCur = N("Frame", {Parent=SVBox, Size=UDim2.fromOffset(14,14), Position=UDim2.new(S,-7,1-V,-7), BackgroundColor3=C.White, BorderSizePixel=0, ZIndex=17})
				Rnd(SVCur, 7)
				N("UIStroke", {Parent=SVCur, Color=Color3.fromRGB(15,15,15), Thickness=1.5})

				local HueBar = N("Frame", {Parent=Inner, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,134), BorderSizePixel=0, ZIndex=14, ClipsDescendants=true})
				Rnd(HueBar, 4)
				N("UIGradient", {Parent=HueBar, Color=ColorSequence.new({ColorSequenceKeypoint.new(0/6,Color3.fromHSV(0/6,1,1)),ColorSequenceKeypoint.new(1/6,Color3.fromHSV(1/6,1,1)),ColorSequenceKeypoint.new(2/6,Color3.fromHSV(2/6,1,1)),ColorSequenceKeypoint.new(3/6,Color3.fromHSV(3/6,1,1)),ColorSequenceKeypoint.new(4/6,Color3.fromHSV(4/6,1,1)),ColorSequenceKeypoint.new(5/6,Color3.fromHSV(5/6,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))}), Rotation=0})
				local HueCur = N("Frame", {Parent=HueBar, Size=UDim2.fromOffset(8,14), Position=UDim2.new(H,-4,0,0), BackgroundColor3=C.White, BorderSizePixel=0, ZIndex=16})
				Rnd(HueCur, 3)
				N("UIStroke", {Parent=HueCur, Color=Color3.fromRGB(15,15,15), Thickness=1.5})

				local BotRow = N("Frame", {Parent=Inner, Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,156), BackgroundColor3=C.Elem, BorderSizePixel=0, ZIndex=14})
				Rnd(BotRow, 6)
				Str(BotRow, C.Border, 1)
				N("TextLabel", {Parent=BotRow, Size=UDim2.fromOffset(26,30), BackgroundTransparency=1, Text="#", TextColor3=C.TextMut, TextSize=13, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=15})
				local HexBox = N("TextBox", {Parent=BotRow, Size=UDim2.new(0.55,-30,1,0), Position=UDim2.new(0,28,0,0), BackgroundTransparency=1, Text=ToHex(CurColor), TextColor3=C.TextPri, TextSize=12, Font=Enum.Font.GothamBold, BorderSizePixel=0, ZIndex=15, TextXAlignment=Enum.TextXAlignment.Left, ClearTextOnFocus=false})
				local CopyBtn = N("TextButton", {Parent=BotRow, Size=UDim2.new(0.45,-6,0,22), Position=UDim2.new(0.55,2,0.5,-11), BackgroundColor3=C.VioletDk, BorderSizePixel=0, Text="Copy Hex", TextColor3=C.TextPri, TextSize=10, Font=Enum.Font.GothamBold, AutoButtonColor=false, ZIndex=15})
				Rnd(CopyBtn, 5)
				CopyBtn.MouseButton1Click:Connect(function()
					pcall(function() setclipboard("#"..ToHex(CurColor)) end)
					CopyBtn.Text = "Copied!"
					task.delay(1.4, function() CopyBtn.Text = "Copy Hex" end)
				end)

				local function Refresh()
					CurColor = Color3.fromHSV(H, S, V)
					Preview.BackgroundColor3 = CurColor
					SVBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
					SVCur.Position = UDim2.new(S, -7, 1-V, -7)
					HueCur.Position = UDim2.new(H, -4, 0, 0)
					HexBox.Text = ToHex(CurColor)
					if CPOpts.Callback then pcall(CPOpts.Callback, CurColor) end
				end

				local SVDrag = false
				local SVHit = N("TextButton", {Parent=SVBox, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=16})
				SVHit.InputBegan:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then SVDrag=true local R=I.Position-SVBox.AbsolutePosition S=math.clamp(R.X/SVBox.AbsoluteSize.X,0,1) V=1-math.clamp(R.Y/SVBox.AbsoluteSize.Y,0,1) Refresh() end end)
				SVHit.InputEnded:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then SVDrag=false end end)
				UserInputService.InputChanged:Connect(function(I) if SVDrag and I.UserInputType==Enum.UserInputType.MouseMovement then local R=I.Position-SVBox.AbsolutePosition S=math.clamp(R.X/SVBox.AbsoluteSize.X,0,1) V=1-math.clamp(R.Y/SVBox.AbsoluteSize.Y,0,1) Refresh() end end)

				local HueDrag = false
				local HueHit = N("TextButton", {Parent=HueBar, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=16})
				HueHit.InputBegan:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then HueDrag=true H=math.clamp((I.Position.X-HueBar.AbsolutePosition.X)/HueBar.AbsoluteSize.X,0,1) Refresh() end end)
				HueHit.InputEnded:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then HueDrag=false end end)
				UserInputService.InputChanged:Connect(function(I) if HueDrag and I.UserInputType==Enum.UserInputType.MouseMovement then H=math.clamp((I.Position.X-HueBar.AbsolutePosition.X)/HueBar.AbsoluteSize.X,0,1) Refresh() end end)

				HexBox.FocusLost:Connect(function()
					local Parsed = FromHex(HexBox.Text)
					if Parsed then CurColor=Parsed H,S,V=Color3.toHSV(Parsed) Refresh() else HexBox.Text=ToHex(CurColor) end
				end)

				local Hit = N("TextButton", {Parent=Row, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=3})
				Hit.MouseButton1Click:Connect(function()
					Open = not Open
					if Open then
						PickPanel.Visible = true
						Tw(PickPanel, {Size=UDim2.new(1,2,0,223)}, 0.22, Enum.EasingStyle.Quart)
					else
						Tw(PickPanel, {Size=UDim2.new(1,2,0,0)}, 0.16)
						task.delay(0.17, function() if not Open then PickPanel.Visible = false end end)
					end
				end)

				local Obj = {}
				function Obj:Set(Col) CurColor=Col H,S,V=Color3.toHSV(Col) Refresh() end
				function Obj:Get() return CurColor end
				return Obj
			end

			function Section:CreateKeybind(KBOpts)
				KBOpts = KBOpts or {}
				local VarName    = KBOpts.Variable or "Key"
				local DefaultKey = KBOpts.Default  or Enum.KeyCode.Unknown
				local Listening  = false

				getgenv()[VarName] = DefaultKey

				local Row = ERow(36)
				N("TextLabel", {Parent=Row, Size=UDim2.new(1,-115,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=KBOpts.Name or "Keybind", TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left})

				local Badge = N("Frame", {Parent=Row, Size=UDim2.fromOffset(94,24), Position=UDim2.new(1,-102,0.5,-12), BackgroundColor3=C.Panel, BorderSizePixel=0})
				Rnd(Badge, 5)
				Str(Badge, C.Border, 1)
				local BadgeBg = N("Frame", {Parent=Badge, Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Violet, BackgroundTransparency=0.84, BorderSizePixel=0})
				Grad(BadgeBg, C.Violet, C.Blue, 0)

				local BadgeLbl = N("TextLabel", {Parent=Badge, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=DefaultKey.Name, TextColor3=C.VioletGlow, TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=2})

				local Hit = N("TextButton", {Parent=Row, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=2})
				Hit.MouseEnter:Connect(function() Tw(Row, {BackgroundColor3=C.ElemHover}) end)
				Hit.MouseLeave:Connect(function() Tw(Row, {BackgroundColor3=C.Elem}) end)
				Hit.MouseButton1Click:Connect(function()
					if Listening then return end
					Listening = true
					BadgeLbl.Text = "..."
					BadgeLbl.TextColor3 = C.Neon
					Tw(Badge, {BackgroundColor3=C.VioletDk})
				end)

				UserInputService.InputBegan:Connect(function(Input, GP)
					if Listening and Input.UserInputType == Enum.UserInputType.Keyboard then
						Listening = false
						getgenv()[VarName] = Input.KeyCode
						BadgeLbl.Text = Input.KeyCode.Name
						BadgeLbl.TextColor3 = C.VioletGlow
						Tw(Badge, {BackgroundColor3=C.Panel})
					elseif not Listening and not GP and Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode == getgenv()[VarName] then
							if KBOpts.Callback then pcall(KBOpts.Callback) end
						end
					end
				end)

				local Obj = {}
				function Obj:Set(KeyCode) getgenv()[VarName]=KeyCode BadgeLbl.Text=KeyCode.Name end
				function Obj:Get() return getgenv()[VarName] end
				return Obj
			end

			function Section:CreateTextbox(TBOpts)
				TBOpts = TBOpts or {}
				local Row = ERow(36)

				if TBOpts.Name then
					N("TextLabel", {Parent=Row, Size=UDim2.new(0.45,0,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=TBOpts.Name, TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left})
				end
				local IBox = N("TextBox", {Parent=Row, Size=TBOpts.Name and UDim2.new(0.55,-12,1,0) or UDim2.new(1,-24,1,0), Position=TBOpts.Name and UDim2.new(0.45,0,0,0) or UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=TBOpts.Default or "", TextColor3=C.TextPri, PlaceholderText=TBOpts.Placeholder or "Type here...", PlaceholderColor3=C.TextMut, TextSize=13, Font=Enum.Font.Gotham, BorderSizePixel=0, TextXAlignment=TBOpts.Name and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left, ClearTextOnFocus=false})

				local RowStr = Row:FindFirstChildOfClass("UIStroke")
				IBox.Focused:Connect(function() if RowStr then Tw(RowStr, {Color=C.Violet}) end end)
				IBox.FocusLost:Connect(function(Enter)
					if RowStr then Tw(RowStr, {Color=C.Border}) end
					if TBOpts.Callback then pcall(TBOpts.Callback, IBox.Text, Enter) end
				end)

				local Obj = {}
				function Obj:Set(T) IBox.Text = T end
				function Obj:Get() return IBox.Text end
				return Obj
			end

			function Section:CreateMultiSelect(MSO)
				MSO = MSO or {}
				local Items    = MSO.Items   or {}
				local Selected = {}
				if MSO.Default then for _, V in pairs(MSO.Default) do Selected[tostring(V)] = true end end

				local Container = N("Frame", {Parent=ElemsContainer, Size=UDim2.new(1,0,0,0), BackgroundColor3=C.Elem, BorderSizePixel=0, LayoutOrder=NextOrd(), AutomaticSize=Enum.AutomaticSize.Y})
				Rnd(Container, 7)
				Str(Container, C.Border, 1)

				local function CountSel() local N2=0 for _ in pairs(Selected) do N2=N2+1 end return N2 end

				local HeaderLbl = N("TextLabel", {Parent=Container, Size=UDim2.new(1,-12,0,32), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=(MSO.Name or "Multi Select").."  ·  0 selected", TextColor3=C.TextPri, TextSize=13, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left})
				N("Frame", {Parent=Container, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,32), BackgroundColor3=C.Separator, BorderSizePixel=0})

				local ItemsFrame = N("Frame", {Parent=Container, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,33), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y})
				Pad(ItemsFrame, 4, 10, 6, 10)
				Lst(ItemsFrame, 3)

				local function RefreshHeader()
					HeaderLbl.Text = (MSO.Name or "Multi Select").."  ·  "..tostring(CountSel()).." selected"
				end

				for _, Item in ipairs(Items) do
					local Key = tostring(Item)
					local Active = Selected[Key] == true
					local IRow = N("Frame", {Parent=ItemsFrame, Size=UDim2.new(1,0,0,28), BackgroundColor3=Active and C.VioletDk or C.Panel, BorderSizePixel=0})
					Rnd(IRow, 5)
					Str(IRow, Active and C.Violet or C.Border, 1)

					local Box = N("Frame", {Parent=IRow, Size=UDim2.fromOffset(16,16), Position=UDim2.new(0,8,0.5,-8), BackgroundColor3=Active and C.Violet or C.Panel, BorderSizePixel=0})
					Rnd(Box, 4)
					Str(Box, Active and C.VioletLt or C.Border, 1)
					local Check = N("TextLabel", {Parent=Box, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="✓", TextColor3=C.White, TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, TextTransparency=Active and 0 or 1})

					N("TextLabel", {Parent=IRow, Size=UDim2.new(1,-34,1,0), Position=UDim2.new(0,30,0,0), BackgroundTransparency=1, Text=Key, TextColor3=Active and C.TextPri or C.TextSec, TextSize=12, Font=Active and Enum.Font.GothamBold or Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left})

					local IBtn = N("TextButton", {Parent=IRow, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=2})
					IBtn.MouseButton1Click:Connect(function()
						Active = not Active
						if Active then
							Selected[Key] = true
							Tw(IRow, {BackgroundColor3=C.VioletDk})
							IRow:FindFirstChildOfClass("UIStroke").Color = C.Violet
							Tw(Box, {BackgroundColor3=C.Violet})
							Box:FindFirstChildOfClass("UIStroke").Color = C.VioletLt
							Tw(Check, {TextTransparency=0})
						else
							Selected[Key] = nil
							Tw(IRow, {BackgroundColor3=C.Panel})
							IRow:FindFirstChildOfClass("UIStroke").Color = C.Border
							Tw(Box, {BackgroundColor3=C.Panel})
							Box:FindFirstChildOfClass("UIStroke").Color = C.Border
							Tw(Check, {TextTransparency=1})
						end
						RefreshHeader()
						if MSO.Callback then
							local L = {} for K in pairs(Selected) do table.insert(L, K) end
							pcall(MSO.Callback, L)
						end
					end)
				end

				RefreshHeader()
				local Obj = {}
				function Obj:Get() local L={} for K in pairs(Selected) do table.insert(L,K) end return L end
				return Obj
			end

			return Section
		end

		return Tab
	end

	return Window
end

return Library
