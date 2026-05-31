local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Palette = {
	WindowBg      = Color3.fromRGB(10, 7, 20),
	SidebarBg     = Color3.fromRGB(15, 10, 30),
	PanelBg       = Color3.fromRGB(20, 14, 40),
	ElementBg     = Color3.fromRGB(28, 19, 54),
	ElementHover  = Color3.fromRGB(38, 26, 70),
	Border        = Color3.fromRGB(65, 38, 110),
	Accent        = Color3.fromRGB(148, 52, 236),
	AccentHover   = Color3.fromRGB(170, 90, 255),
	AccentDark    = Color3.fromRGB(105, 35, 190),
	AccentText    = Color3.fromRGB(210, 170, 255),
	TextPrimary   = Color3.fromRGB(248, 244, 255),
	TextSecondary = Color3.fromRGB(180, 158, 215),
	TextMuted     = Color3.fromRGB(115, 95, 158),
	ToggleOff     = Color3.fromRGB(42, 28, 72),
	ToggleOn      = Color3.fromRGB(148, 52, 236),
	TrackBg       = Color3.fromRGB(32, 20, 60),
	Separator     = Color3.fromRGB(48, 30, 85),
	DropdownBg    = Color3.fromRGB(16, 10, 32),
	White         = Color3.fromRGB(255, 255, 255),
	Black         = Color3.fromRGB(0, 0, 0),
}

local function Tween(Object, Props, Duration, Style, Dir)
	TweenService:Create(
		Object,
		TweenInfo.new(Duration or 0.15, Style or Enum.EasingStyle.Quad, Dir or Enum.EasingDirection.Out),
		Props
	):Play()
end

local function New(Class, Props)
	local Obj = Instance.new(Class)
	for K, V in pairs(Props or {}) do
		if K ~= "Parent" then
			pcall(function() Obj[K] = V end)
		end
	end
	if Props and Props.Parent then
		Obj.Parent = Props.Parent
	end
	return Obj
end

local function Corner(Parent, Radius)
	return New("UICorner", {Parent = Parent, CornerRadius = UDim.new(0, Radius or 6)})
end

local function Stroke(Parent, Color, Thickness)
	return New("UIStroke", {
		Parent = Parent,
		Color = Color or Palette.Border,
		Thickness = Thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function Pad(Parent, Top, Right, Bottom, Left)
	return New("UIPadding", {
		Parent = Parent,
		PaddingTop    = UDim.new(0, Top    or 6),
		PaddingRight  = UDim.new(0, Right  or 6),
		PaddingBottom = UDim.new(0, Bottom or 6),
		PaddingLeft   = UDim.new(0, Left   or 6),
	})
end

local function List(Parent, Padding, Dir)
	return New("UIListLayout", {
		Parent = Parent,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Dir or Enum.FillDirection.Vertical,
		Padding = UDim.new(0, Padding or 6),
	})
end

local function MakeDraggable(Frame, Handle)
	local Active = false
	local Origin = nil
	local StartPos = nil

	Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Active = true
			Origin = Input.Position
			StartPos = Frame.Position
		end
	end)

	Handle.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Active = false
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Active and Input.UserInputType == Enum.UserInputType.MouseMovement then
			local Delta = Input.Position - Origin
			Frame.Position = UDim2.new(
				StartPos.X.Scale, StartPos.X.Offset + Delta.X,
				StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
			)
		end
	end)
end

local function ColorToHex(C)
	return string.format("%02X%02X%02X",
		math.floor(C.R * 255 + 0.5),
		math.floor(C.G * 255 + 0.5),
		math.floor(C.B * 255 + 0.5)
	)
end

local function HexToColor(Hex)
	Hex = Hex:gsub("[^%x]", "")
	if #Hex == 6 then
		local R = tonumber(Hex:sub(1, 2), 16)
		local G = tonumber(Hex:sub(3, 4), 16)
		local B = tonumber(Hex:sub(5, 6), 16)
		if R and G and B then
			return Color3.fromRGB(R, G, B)
		end
	end
	return nil
end

local Library = {}
Library.__index = Library

function Library.CreateWindow(Options)
	Options = Options or {}
	local Title    = Options.Title    or "UI Library"
	local Subtitle = Options.Subtitle or ""
	local Width    = Options.Width    or 580
	local Height   = Options.Height   or 450

	local Gui = New("ScreenGui", {
		Name            = Title,
		ResetOnSpawn    = false,
		ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
		Parent          = (pcall(function() return CoreGui end)) and CoreGui or LocalPlayer.PlayerGui,
	})

	local MainFrame = New("Frame", {
		Parent           = Gui,
		Name             = "MainFrame",
		Size             = UDim2.fromOffset(Width, Height),
		Position         = UDim2.fromScale(0.5, 0.5),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Palette.WindowBg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	})
	Corner(MainFrame, 10)
	Stroke(MainFrame, Palette.Border, 1)

	local TitleBar = New("Frame", {
		Parent           = MainFrame,
		Size             = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Palette.SidebarBg,
		BorderSizePixel  = 0,
	})

	New("Frame", {
		Parent           = TitleBar,
		Size             = UDim2.new(1, 0, 0, 10),
		Position         = UDim2.new(0, 0, 1, -10),
		BackgroundColor3 = Palette.SidebarBg,
		BorderSizePixel  = 0,
	})

	New("Frame", {
		Parent           = TitleBar,
		Size             = UDim2.new(0, 3, 0.55, 0),
		Position         = UDim2.new(0, 0, 0.225, 0),
		BackgroundColor3 = Palette.Accent,
		BorderSizePixel  = 0,
	})

	New("Frame", {
		Parent           = TitleBar,
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = Palette.Separator,
		BorderSizePixel  = 0,
	})

	local TitleLabel = New("TextLabel", {
		Parent               = TitleBar,
		Size                 = UDim2.new(0, 280, 0, 26),
		Position             = UDim2.new(0, 18, 0, 6),
		BackgroundTransparency = 1,
		Text                 = Title,
		TextColor3           = Palette.TextPrimary,
		TextSize             = 15,
		Font                 = Enum.Font.GothamBold,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	if Subtitle ~= "" then
		TitleLabel.Size = UDim2.new(0, 280, 0, 20)
		TitleLabel.Position = UDim2.new(0, 18, 0, 5)
		TitleLabel.TextSize = 14

		New("TextLabel", {
			Parent               = TitleBar,
			Size                 = UDim2.new(0, 280, 0, 16),
			Position             = UDim2.new(0, 18, 0, 28),
			BackgroundTransparency = 1,
			Text                 = Subtitle,
			TextColor3           = Palette.TextMuted,
			TextSize             = 11,
			Font                 = Enum.Font.Gotham,
			TextXAlignment       = Enum.TextXAlignment.Left,
		})
	end

	local CloseBtn = New("TextButton", {
		Parent               = TitleBar,
		Size                 = UDim2.fromOffset(26, 26),
		Position             = UDim2.new(1, -36, 0.5, -13),
		BackgroundColor3     = Color3.fromRGB(55, 28, 75),
		BorderSizePixel      = 0,
		Text                 = "✕",
		TextColor3           = Palette.TextMuted,
		TextSize             = 13,
		Font                 = Enum.Font.GothamBold,
		AutoButtonColor      = false,
	})
	Corner(CloseBtn, 5)

	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(200, 45, 75), TextColor3 = Palette.White})
	end)
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(55, 28, 75), TextColor3 = Palette.TextMuted})
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		Gui:Destroy()
	end)

	local MinBtn = New("TextButton", {
		Parent               = TitleBar,
		Size                 = UDim2.fromOffset(26, 26),
		Position             = UDim2.new(1, -66, 0.5, -13),
		BackgroundColor3     = Color3.fromRGB(40, 26, 68),
		BorderSizePixel      = 0,
		Text                 = "—",
		TextColor3           = Palette.TextMuted,
		TextSize             = 14,
		Font                 = Enum.Font.GothamBold,
		AutoButtonColor      = false,
	})
	Corner(MinBtn, 5)

	local Minimized = false
	MinBtn.MouseEnter:Connect(function()
		Tween(MinBtn, {BackgroundColor3 = Palette.ElementHover, TextColor3 = Palette.TextPrimary})
	end)
	MinBtn.MouseLeave:Connect(function()
		Tween(MinBtn, {BackgroundColor3 = Color3.fromRGB(40, 26, 68), TextColor3 = Palette.TextMuted})
	end)
	MinBtn.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		if Minimized then
			Tween(MainFrame, {Size = UDim2.fromOffset(Width, 50)}, 0.25, Enum.EasingStyle.Quart)
		else
			Tween(MainFrame, {Size = UDim2.fromOffset(Width, Height)}, 0.25, Enum.EasingStyle.Quart)
		end
	end)

	local Body = New("Frame", {
		Parent           = MainFrame,
		Size             = UDim2.new(1, 0, 1, -50),
		Position         = UDim2.new(0, 0, 0, 50),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})

	local Sidebar = New("Frame", {
		Parent           = Body,
		Size             = UDim2.new(0, 145, 1, 0),
		BackgroundColor3 = Palette.SidebarBg,
		BorderSizePixel  = 0,
	})

	New("Frame", {
		Parent           = Sidebar,
		Size             = UDim2.new(0, 1, 1, 0),
		Position         = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Palette.Separator,
		BorderSizePixel  = 0,
	})

	local TabScroll = New("ScrollingFrame", {
		Parent                = Sidebar,
		Size                  = UDim2.new(1, 0, 1, -8),
		Position              = UDim2.new(0, 0, 0, 8),
		BackgroundTransparency = 1,
		BorderSizePixel       = 0,
		ScrollBarThickness    = 2,
		ScrollBarImageColor3  = Palette.Accent,
		CanvasSize            = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize   = Enum.AutomaticSize.Y,
		ScrollingDirection    = Enum.ScrollingDirection.Y,
	})
	Pad(TabScroll, 4, 8, 4, 8)
	List(TabScroll, 3)

	local ContentArea = New("Frame", {
		Parent           = Body,
		Size             = UDim2.new(1, -145, 1, 0),
		Position         = UDim2.new(0, 145, 0, 0),
		BackgroundTransparency = 1,
	})

	MakeDraggable(MainFrame, TitleBar)

	local Window = {
		Gui         = Gui,
		Frame       = MainFrame,
		ActiveTab   = nil,
		AllTabs     = {},
	}

	function Window:CreateTab(TabOptions)
		TabOptions = TabOptions or {}
		local TabName = TabOptions.Name or "Tab"

		local TabBtn = New("TextButton", {
			Parent           = TabScroll,
			Size             = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Palette.SidebarBg,
			BorderSizePixel  = 0,
			Text             = "",
			AutoButtonColor  = false,
			ClipsDescendants = true,
		})
		Corner(TabBtn, 6)

		local ActiveBar = New("Frame", {
			Parent           = TabBtn,
			Size             = UDim2.new(0, 3, 0.5, 0),
			Position         = UDim2.new(0, 0, 0.25, 0),
			BackgroundColor3 = Palette.Accent,
			BorderSizePixel  = 0,
			Visible          = false,
		})
		Corner(ActiveBar, 2)

		local TabBtnLabel = New("TextLabel", {
			Parent               = TabBtn,
			Size                 = UDim2.new(1, -18, 1, 0),
			Position             = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1,
			Text                 = TabName,
			TextColor3           = Palette.TextMuted,
			TextSize             = 12,
			Font                 = Enum.Font.Gotham,
			TextXAlignment       = Enum.TextXAlignment.Left,
		})

		local TabContent = New("ScrollingFrame", {
			Parent                = ContentArea,
			Size                  = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel       = 0,
			ScrollBarThickness    = 3,
			ScrollBarImageColor3  = Palette.Accent,
			CanvasSize            = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize   = Enum.AutomaticSize.Y,
			ScrollingDirection    = Enum.ScrollingDirection.Y,
			Visible               = false,
		})
		Pad(TabContent, 10, 14, 10, 14)
		List(TabContent, 8)

		local Tab = {
			Button  = TabBtn,
			Content = TabContent,
		}

		local function ActivateTab()
			if Window.ActiveTab and Window.ActiveTab ~= Tab then
				local Prev = Window.ActiveTab
				Tween(Prev.Button, {BackgroundColor3 = Palette.SidebarBg})
				Prev.Button:FindFirstChild("TextLabel").Font = Enum.Font.Gotham
				Tween(Prev.Button:FindFirstChild("TextLabel"), {TextColor3 = Palette.TextMuted})
				Prev.Button:FindFirstChild("Frame").Visible = false
				Prev.Content.Visible = false
			end
			Window.ActiveTab = Tab
			Tween(TabBtn, {BackgroundColor3 = Palette.ElementBg})
			TabBtnLabel.Font = Enum.Font.GothamBold
			Tween(TabBtnLabel, {TextColor3 = Palette.TextPrimary})
			ActiveBar.Visible = true
			TabContent.Visible = true
		end

		TabBtn.MouseButton1Click:Connect(ActivateTab)

		TabBtn.MouseEnter:Connect(function()
			if Window.ActiveTab ~= Tab then
				Tween(TabBtn, {BackgroundColor3 = Palette.ElementHover})
				Tween(TabBtnLabel, {TextColor3 = Palette.TextSecondary})
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if Window.ActiveTab ~= Tab then
				Tween(TabBtn, {BackgroundColor3 = Palette.SidebarBg})
				Tween(TabBtnLabel, {TextColor3 = Palette.TextMuted})
			end
		end)

		if #Window.AllTabs == 0 then
			ActivateTab()
		end

		table.insert(Window.AllTabs, Tab)

		function Tab:CreateSection(SectionOptions)
			SectionOptions = SectionOptions or {}

			local SectionFrame = New("Frame", {
				Parent           = TabContent,
				Size             = UDim2.new(1, 0, 0, 0),
				BackgroundColor3 = Palette.PanelBg,
				BorderSizePixel  = 0,
				AutomaticSize    = Enum.AutomaticSize.Y,
			})
			Corner(SectionFrame, 8)
			Stroke(SectionFrame, Palette.Border, 1)
			Pad(SectionFrame, 10, 10, 10, 10)
			List(SectionFrame, 5)

			local Order = 0
			local function NextOrder()
				Order = Order + 1
				return Order
			end

			if SectionOptions.Name then
				local Header = New("Frame", {
					Parent           = SectionFrame,
					Size             = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					LayoutOrder      = NextOrder(),
				})

				New("TextLabel", {
					Parent               = Header,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = SectionOptions.Name:upper(),
					TextColor3           = Palette.Accent,
					TextSize             = 10,
					Font                 = Enum.Font.GothamBold,
					TextXAlignment       = Enum.TextXAlignment.Left,
				})

				New("Frame", {
					Parent           = Header,
					Size             = UDim2.new(1, 0, 0, 1),
					Position         = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Palette.Separator,
					BorderSizePixel  = 0,
				})
			end

			local Section = {}

			local function ElementRow(Height)
				return New("Frame", {
					Parent           = SectionFrame,
					Size             = UDim2.new(1, 0, 0, Height or 34),
					BackgroundColor3 = Palette.ElementBg,
					BorderSizePixel  = 0,
					LayoutOrder      = NextOrder(),
					ClipsDescendants = true,
				})
			end

			function Section:CreateLabel(LabelOptions)
				LabelOptions = LabelOptions or {}
				local Row = New("Frame", {
					Parent           = SectionFrame,
					Size             = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					LayoutOrder      = NextOrder(),
				})
				local Label = New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = LabelOptions.Text or "",
					TextColor3           = LabelOptions.Color or Palette.TextMuted,
					TextSize             = 12,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Left,
				})
				local Obj = {}
				function Obj:Set(Text)
					Label.Text = Text
				end
				return Obj
			end

			function Section:CreateButton(ButtonOptions)
				ButtonOptions = ButtonOptions or {}
				local Row = ElementRow(36)
				Corner(Row, 6)
				Stroke(Row, Palette.Border, 1)

				New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(1, -36, 1, 0),
					Position             = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                 = ButtonOptions.Name or "Button",
					TextColor3           = Palette.TextPrimary,
					TextSize             = 13,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Left,
				})

				New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.fromOffset(22, 36),
					Position             = UDim2.new(1, -26, 0, 0),
					BackgroundTransparency = 1,
					Text                 = "›",
					TextColor3           = Palette.Accent,
					TextSize             = 20,
					Font                 = Enum.Font.GothamBold,
					TextXAlignment       = Enum.TextXAlignment.Center,
				})

				local Hitbox = New("TextButton", {
					Parent               = Row,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 2,
				})

				Hitbox.MouseEnter:Connect(function()
					Tween(Row, {BackgroundColor3 = Palette.ElementHover})
				end)
				Hitbox.MouseLeave:Connect(function()
					Tween(Row, {BackgroundColor3 = Palette.ElementBg})
				end)
				Hitbox.MouseButton1Click:Connect(function()
					Tween(Row, {BackgroundColor3 = Palette.AccentDark}, 0.08)
					task.delay(0.14, function()
						Tween(Row, {BackgroundColor3 = Palette.ElementBg})
					end)
					if ButtonOptions.Callback then
						pcall(ButtonOptions.Callback)
					end
				end)

				return {}
			end

			function Section:CreateToggle(ToggleOptions)
				ToggleOptions = ToggleOptions or {}
				local State = ToggleOptions.Default == true

				local Row = ElementRow(36)
				Corner(Row, 6)
				Stroke(Row, Palette.Border, 1)

				New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(1, -64, 1, 0),
					Position             = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                 = ToggleOptions.Name or "Toggle",
					TextColor3           = Palette.TextPrimary,
					TextSize             = 13,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Left,
				})

				local Track = New("Frame", {
					Parent           = Row,
					Size             = UDim2.fromOffset(40, 22),
					Position         = UDim2.new(1, -50, 0.5, -11),
					BackgroundColor3 = State and Palette.ToggleOn or Palette.ToggleOff,
					BorderSizePixel  = 0,
				})
				Corner(Track, 11)
				local TrackStroke = Stroke(Track, State and Palette.Accent or Palette.Border, 1)

				local Knob = New("Frame", {
					Parent           = Track,
					Size             = UDim2.fromOffset(16, 16),
					Position         = State and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = Palette.White,
					BorderSizePixel  = 0,
				})
				Corner(Knob, 8)

				local Hitbox = New("TextButton", {
					Parent               = Row,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 2,
				})

				local function ApplyState(NewState, Fire)
					State = NewState
					if State then
						Tween(Track, {BackgroundColor3 = Palette.ToggleOn})
						Tween(Knob, {Position = UDim2.new(1, -19, 0.5, -8)})
						TrackStroke.Color = Palette.Accent
					else
						Tween(Track, {BackgroundColor3 = Palette.ToggleOff})
						Tween(Knob, {Position = UDim2.new(0, 3, 0.5, -8)})
						TrackStroke.Color = Palette.Border
					end
					if Fire and ToggleOptions.Callback then
						pcall(ToggleOptions.Callback, State)
					end
				end

				Hitbox.MouseEnter:Connect(function()
					Tween(Row, {BackgroundColor3 = Palette.ElementHover})
				end)
				Hitbox.MouseLeave:Connect(function()
					Tween(Row, {BackgroundColor3 = Palette.ElementBg})
				end)
				Hitbox.MouseButton1Click:Connect(function()
					ApplyState(not State, true)
				end)

				local Obj = {}
				function Obj:Set(Value)
					ApplyState(Value == true, true)
				end
				function Obj:Get()
					return State
				end
				return Obj
			end

			function Section:CreateSlider(SliderOptions)
				SliderOptions = SliderOptions or {}
				local Min     = SliderOptions.Min     or 0
				local Max     = SliderOptions.Max     or 100
				local Default = SliderOptions.Default or Min
				local Suffix  = SliderOptions.Suffix  or ""
				local IsInt   = SliderOptions.Integer ~= false
				local Value   = math.clamp(Default, Min, Max)

				local Row = New("Frame", {
					Parent           = SectionFrame,
					Size             = UDim2.new(1, 0, 0, 52),
					BackgroundColor3 = Palette.ElementBg,
					BorderSizePixel  = 0,
					LayoutOrder      = NextOrder(),
				})
				Corner(Row, 6)
				Stroke(Row, Palette.Border, 1)

				New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(0.6, 0, 0, 26),
					Position             = UDim2.new(0, 12, 0, 4),
					BackgroundTransparency = 1,
					Text                 = SliderOptions.Name or "Slider",
					TextColor3           = Palette.TextPrimary,
					TextSize             = 13,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Left,
				})

				local ValLabel = New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(0.4, -12, 0, 26),
					Position             = UDim2.new(0.6, 0, 0, 4),
					BackgroundTransparency = 1,
					Text                 = tostring(Value) .. Suffix,
					TextColor3           = Palette.AccentText,
					TextSize             = 12,
					Font                 = Enum.Font.GothamBold,
					TextXAlignment       = Enum.TextXAlignment.Right,
				})

				local SliderTrack = New("Frame", {
					Parent           = Row,
					Size             = UDim2.new(1, -24, 0, 6),
					Position         = UDim2.new(0, 12, 0, 38),
					BackgroundColor3 = Palette.TrackBg,
					BorderSizePixel  = 0,
				})
				Corner(SliderTrack, 3)

				local FillRatio = (Value - Min) / (Max - Min)

				local SliderFill = New("Frame", {
					Parent           = SliderTrack,
					Size             = UDim2.new(FillRatio, 0, 1, 0),
					BackgroundColor3 = Palette.Accent,
					BorderSizePixel  = 0,
				})
				Corner(SliderFill, 3)

				local Thumb = New("Frame", {
					Parent           = SliderTrack,
					Size             = UDim2.fromOffset(14, 14),
					Position         = UDim2.new(FillRatio, -7, 0.5, -7),
					BackgroundColor3 = Palette.White,
					BorderSizePixel  = 0,
					ZIndex           = 2,
				})
				Corner(Thumb, 7)
				New("UIStroke", {Parent = Thumb, Color = Palette.Accent, Thickness = 2})

				local Dragging = false

				local function ComputeValue(InputX)
					local Ratio = math.clamp((InputX - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
					if IsInt then
						return math.round(Min + (Max - Min) * Ratio), Ratio
					else
						return math.floor((Min + (Max - Min) * Ratio) * 10 + 0.5) / 10, Ratio
					end
				end

				local function ApplyValue(InputX)
					local NewVal, Ratio = ComputeValue(InputX)
					Value = NewVal
					ValLabel.Text = tostring(Value) .. Suffix
					SliderFill.Size = UDim2.new(Ratio, 0, 1, 0)
					Thumb.Position = UDim2.new(Ratio, -7, 0.5, -7)
					if SliderOptions.Callback then
						pcall(SliderOptions.Callback, Value)
					end
				end

				local SliderBtn = New("TextButton", {
					Parent               = SliderTrack,
					Size                 = UDim2.new(1, 0, 4, -16),
					Position             = UDim2.new(0, 0, 0, -16),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 3,
				})

				SliderBtn.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
						ApplyValue(Input.Position.X)
					end
				end)
				SliderBtn.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
					end
				end)
				UserInputService.InputChanged:Connect(function(Input)
					if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						ApplyValue(Input.Position.X)
					end
				end)

				local Obj = {}
				function Obj:Set(NewVal)
					Value = math.clamp(NewVal, Min, Max)
					local Ratio = (Value - Min) / (Max - Min)
					ValLabel.Text = tostring(Value) .. Suffix
					SliderFill.Size = UDim2.new(Ratio, 0, 1, 0)
					Thumb.Position = UDim2.new(Ratio, -7, 0.5, -7)
				end
				function Obj:Get()
					return Value
				end
				return Obj
			end

			function Section:CreateDropdown(DropdownOptions)
				DropdownOptions = DropdownOptions or {}
				local Items    = DropdownOptions.Items   or {}
				local Selected = DropdownOptions.Default or Items[1] or ""
				local Open     = false

				local Row = New("Frame", {
					Parent           = SectionFrame,
					Size             = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Palette.ElementBg,
					BorderSizePixel  = 0,
					LayoutOrder      = NextOrder(),
					ZIndex           = 2,
					ClipsDescendants = false,
				})
				Corner(Row, 6)
				Stroke(Row, Palette.Border, 1)

				New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(1, -130, 1, 0),
					Position             = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                 = DropdownOptions.Name or "Dropdown",
					TextColor3           = Palette.TextPrimary,
					TextSize             = 13,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Left,
					ZIndex               = 2,
				})

				local SelectionLabel = New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.fromOffset(110, 36),
					Position             = UDim2.new(1, -118, 0, 0),
					BackgroundTransparency = 1,
					Text                 = tostring(Selected),
					TextColor3           = Palette.AccentText,
					TextSize             = 12,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Right,
					ZIndex               = 2,
				})

				local ArrowLabel = New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.fromOffset(14, 36),
					Position             = UDim2.new(1, -18, 0, 0),
					BackgroundTransparency = 1,
					Text                 = "▾",
					TextColor3           = Palette.TextMuted,
					TextSize             = 12,
					Font                 = Enum.Font.GothamBold,
					TextXAlignment       = Enum.TextXAlignment.Center,
					ZIndex               = 2,
				})

				local DropPanel = New("Frame", {
					Parent           = Row,
					Size             = UDim2.new(1, 2, 0, 0),
					Position         = UDim2.new(0, -1, 1, 4),
					BackgroundColor3 = Palette.DropdownBg,
					BorderSizePixel  = 0,
					ZIndex           = 12,
					Visible          = false,
					ClipsDescendants = true,
				})
				Corner(DropPanel, 6)
				Stroke(DropPanel, Palette.Border, 1)

				local DropList = New("ScrollingFrame", {
					Parent               = DropPanel,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					BorderSizePixel      = 0,
					ScrollBarThickness   = 2,
					ScrollBarImageColor3 = Palette.Accent,
					CanvasSize           = UDim2.new(0, 0, 0, 0),
					AutomaticCanvasSize  = Enum.AutomaticSize.Y,
					ZIndex               = 12,
				})
				Pad(DropList, 4, 6, 4, 6)
				List(DropList, 2)

				local function BuildList()
					for _, C in ipairs(DropList:GetChildren()) do
						if C:IsA("TextButton") then C:Destroy() end
					end
					for _, Item in ipairs(Items) do
						local IsSelected = tostring(Item) == tostring(Selected)
						local ItemBtn = New("TextButton", {
							Parent               = DropList,
							Size                 = UDim2.new(1, 0, 0, 28),
							BackgroundColor3     = IsSelected and Palette.AccentDark or Palette.DropdownBg,
							BackgroundTransparency = IsSelected and 0 or 1,
							Text                 = tostring(Item),
							TextColor3           = IsSelected and Palette.TextPrimary or Palette.TextSecondary,
							TextSize             = 12,
							Font                 = Enum.Font.Gotham,
							BorderSizePixel      = 0,
							AutoButtonColor      = false,
							ZIndex               = 13,
						})
						Corner(ItemBtn, 4)

						ItemBtn.MouseEnter:Connect(function()
							if not IsSelected then
								Tween(ItemBtn, {BackgroundTransparency = 0, BackgroundColor3 = Palette.ElementHover})
								Tween(ItemBtn, {TextColor3 = Palette.TextPrimary})
							end
						end)
						ItemBtn.MouseLeave:Connect(function()
							if not IsSelected then
								Tween(ItemBtn, {BackgroundTransparency = 1})
								Tween(ItemBtn, {TextColor3 = Palette.TextSecondary})
							end
						end)
						ItemBtn.MouseButton1Click:Connect(function()
							Selected = Item
							SelectionLabel.Text = tostring(Selected)
							BuildList()
							if DropdownOptions.Callback then
								pcall(DropdownOptions.Callback, Selected)
							end
						end)
					end
				end
				BuildList()

				local function ToggleDrop()
					Open = not Open
					local ItemHeight = math.min(#Items, 6) * 30 + 8
					if Open then
						DropPanel.Visible = true
						Tween(DropPanel, {Size = UDim2.new(1, 2, 0, ItemHeight)}, 0.2, Enum.EasingStyle.Quart)
						Tween(ArrowLabel, {Rotation = 180}, 0.2)
					else
						Tween(DropPanel, {Size = UDim2.new(1, 2, 0, 0)}, 0.15)
						Tween(ArrowLabel, {Rotation = 0}, 0.15)
						task.delay(0.16, function()
							if not Open then DropPanel.Visible = false end
						end)
					end
				end

				local Hitbox = New("TextButton", {
					Parent               = Row,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 3,
				})
				Hitbox.MouseButton1Click:Connect(ToggleDrop)

				local Obj = {}
				function Obj:Set(Value)
					Selected = Value
					SelectionLabel.Text = tostring(Value)
					BuildList()
				end
				function Obj:Get()
					return Selected
				end
				function Obj:SetItems(NewItems)
					Items = NewItems
					BuildList()
				end
				return Obj
			end

			function Section:CreateColorPicker(ColorOptions)
				ColorOptions = ColorOptions or {}
				local CurrentColor = ColorOptions.Default or Color3.fromRGB(148, 52, 236)
				local H, S, V = Color3.toHSV(CurrentColor)
				local Open = false

				local Row = New("Frame", {
					Parent           = SectionFrame,
					Size             = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Palette.ElementBg,
					BorderSizePixel  = 0,
					LayoutOrder      = NextOrder(),
					ZIndex           = 2,
					ClipsDescendants = false,
				})
				Corner(Row, 6)
				Stroke(Row, Palette.Border, 1)

				New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(1, -90, 1, 0),
					Position             = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                 = ColorOptions.Name or "Color Picker",
					TextColor3           = Palette.TextPrimary,
					TextSize             = 13,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Left,
					ZIndex               = 2,
				})

				local Preview = New("Frame", {
					Parent           = Row,
					Size             = UDim2.fromOffset(32, 18),
					Position         = UDim2.new(1, -44, 0.5, -9),
					BackgroundColor3 = CurrentColor,
					BorderSizePixel  = 0,
					ZIndex           = 2,
				})
				Corner(Preview, 4)
				Stroke(Preview, Palette.Border, 1)

				local PickerPanel = New("Frame", {
					Parent           = Row,
					Size             = UDim2.new(1, 2, 0, 0),
					Position         = UDim2.new(0, -1, 1, 4),
					BackgroundColor3 = Palette.DropdownBg,
					BorderSizePixel  = 0,
					ZIndex           = 12,
					Visible          = false,
					ClipsDescendants = true,
				})
				Corner(PickerPanel, 8)
				Stroke(PickerPanel, Palette.Border, 1)

				local PickerInner = New("Frame", {
					Parent               = PickerPanel,
					Size                 = UDim2.new(1, -18, 0, 195),
					Position             = UDim2.new(0, 9, 0, 9),
					BackgroundTransparency = 1,
					ZIndex               = 12,
				})

				local SVBox = New("Frame", {
					Parent           = PickerInner,
					Size             = UDim2.new(1, 0, 0, 125),
					BackgroundColor3 = Color3.fromHSV(H, 1, 1),
					BorderSizePixel  = 0,
					ZIndex           = 12,
					ClipsDescendants = true,
				})
				Corner(SVBox, 6)

				New("UIGradient", {
					Parent       = SVBox,
					Color        = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Rotation     = 0,
				})

				local BlackLayer = New("Frame", {
					Parent           = SVBox,
					Size             = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Palette.Black,
					BorderSizePixel  = 0,
					ZIndex           = 13,
				})
				Corner(BlackLayer, 6)
				New("UIGradient", {
					Parent       = BlackLayer,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
					Rotation     = 90,
				})

				local SVCursor = New("Frame", {
					Parent           = SVBox,
					Size             = UDim2.fromOffset(13, 13),
					Position         = UDim2.new(S, -6, 1 - V, -6),
					BackgroundColor3 = Palette.White,
					BorderSizePixel  = 0,
					ZIndex           = 15,
				})
				Corner(SVCursor, 7)
				New("UIStroke", {Parent = SVCursor, Color = Color3.fromRGB(20, 20, 20), Thickness = 1.5})

				local HueBar = New("Frame", {
					Parent           = PickerInner,
					Size             = UDim2.new(1, 0, 0, 14),
					Position         = UDim2.new(0, 0, 0, 133),
					BorderSizePixel  = 0,
					ZIndex           = 12,
					ClipsDescendants = true,
				})
				Corner(HueBar, 4)
				New("UIGradient", {
					Parent = HueBar,
					Color  = ColorSequence.new({
						ColorSequenceKeypoint.new(0/6,   Color3.fromHSV(0/6,   1, 1)),
						ColorSequenceKeypoint.new(1/6,   Color3.fromHSV(1/6,   1, 1)),
						ColorSequenceKeypoint.new(2/6,   Color3.fromHSV(2/6,   1, 1)),
						ColorSequenceKeypoint.new(3/6,   Color3.fromHSV(3/6,   1, 1)),
						ColorSequenceKeypoint.new(4/6,   Color3.fromHSV(4/6,   1, 1)),
						ColorSequenceKeypoint.new(5/6,   Color3.fromHSV(5/6,   1, 1)),
						ColorSequenceKeypoint.new(1,     Color3.fromHSV(1,     1, 1)),
					}),
					Rotation = 0,
				})

				local HueCursor = New("Frame", {
					Parent           = HueBar,
					Size             = UDim2.fromOffset(8, 14),
					Position         = UDim2.new(H, -4, 0, 0),
					BackgroundColor3 = Palette.White,
					BorderSizePixel  = 0,
					ZIndex           = 14,
				})
				Corner(HueCursor, 3)
				New("UIStroke", {Parent = HueCursor, Color = Color3.fromRGB(20, 20, 20), Thickness = 1.5})

				local HexRow = New("Frame", {
					Parent           = PickerInner,
					Size             = UDim2.new(1, 0, 0, 28),
					Position         = UDim2.new(0, 0, 0, 156),
					BackgroundColor3 = Palette.ElementBg,
					BorderSizePixel  = 0,
					ZIndex           = 12,
				})
				Corner(HexRow, 6)
				Stroke(HexRow, Palette.Border, 1)

				New("TextLabel", {
					Parent               = HexRow,
					Size                 = UDim2.fromOffset(28, 28),
					BackgroundTransparency = 1,
					Text                 = "#",
					TextColor3           = Palette.TextMuted,
					TextSize             = 13,
					Font                 = Enum.Font.GothamBold,
					TextXAlignment       = Enum.TextXAlignment.Center,
					ZIndex               = 12,
				})

				local HexInput = New("TextBox", {
					Parent               = HexRow,
					Size                 = UDim2.new(1, -36, 1, 0),
					Position             = UDim2.new(0, 30, 0, 0),
					BackgroundTransparency = 1,
					Text                 = ColorToHex(CurrentColor),
					TextColor3           = Palette.TextPrimary,
					TextSize             = 12,
					Font                 = Enum.Font.GothamBold,
					BorderSizePixel      = 0,
					ZIndex               = 12,
					TextXAlignment       = Enum.TextXAlignment.Left,
					ClearTextOnFocus     = false,
				})

				local function RefreshColor()
					CurrentColor = Color3.fromHSV(H, S, V)
					Preview.BackgroundColor3 = CurrentColor
					SVBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
					SVCursor.Position = UDim2.new(S, -6, 1 - V, -6)
					HueCursor.Position = UDim2.new(H, -4, 0, 0)
					HexInput.Text = ColorToHex(CurrentColor)
					if ColorOptions.Callback then
						pcall(ColorOptions.Callback, CurrentColor)
					end
				end

				local SVDragging = false
				local SVHitbox = New("TextButton", {
					Parent               = SVBox,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 14,
				})

				SVHitbox.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						SVDragging = true
						local Rel = Input.Position - SVBox.AbsolutePosition
						S = math.clamp(Rel.X / SVBox.AbsoluteSize.X, 0, 1)
						V = 1 - math.clamp(Rel.Y / SVBox.AbsoluteSize.Y, 0, 1)
						RefreshColor()
					end
				end)
				SVHitbox.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						SVDragging = false
					end
				end)
				UserInputService.InputChanged:Connect(function(Input)
					if SVDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						local Rel = Input.Position - SVBox.AbsolutePosition
						S = math.clamp(Rel.X / SVBox.AbsoluteSize.X, 0, 1)
						V = 1 - math.clamp(Rel.Y / SVBox.AbsoluteSize.Y, 0, 1)
						RefreshColor()
					end
				end)

				local HueDragging = false
				local HueHitbox = New("TextButton", {
					Parent               = HueBar,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 14,
				})

				HueHitbox.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						HueDragging = true
						local Rel = Input.Position - HueBar.AbsolutePosition
						H = math.clamp(Rel.X / HueBar.AbsoluteSize.X, 0, 1)
						RefreshColor()
					end
				end)
				HueHitbox.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						HueDragging = false
					end
				end)
				UserInputService.InputChanged:Connect(function(Input)
					if HueDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						local Rel = Input.Position - HueBar.AbsolutePosition
						H = math.clamp(Rel.X / HueBar.AbsoluteSize.X, 0, 1)
						RefreshColor()
					end
				end)

				HexInput.FocusLost:Connect(function()
					local Parsed = HexToColor(HexInput.Text)
					if Parsed then
						CurrentColor = Parsed
						H, S, V = Color3.toHSV(Parsed)
						RefreshColor()
					else
						HexInput.Text = ColorToHex(CurrentColor)
					end
				end)

				local ToggleHitbox = New("TextButton", {
					Parent               = Row,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 3,
				})
				ToggleHitbox.MouseButton1Click:Connect(function()
					Open = not Open
					if Open then
						PickerPanel.Visible = true
						Tween(PickerPanel, {Size = UDim2.new(1, 2, 0, 213)}, 0.2, Enum.EasingStyle.Quart)
					else
						Tween(PickerPanel, {Size = UDim2.new(1, 2, 0, 0)}, 0.15)
						task.delay(0.16, function()
							if not Open then PickerPanel.Visible = false end
						end)
					end
				end)

				local Obj = {}
				function Obj:Set(Color)
					CurrentColor = Color
					H, S, V = Color3.toHSV(Color)
					RefreshColor()
				end
				function Obj:Get()
					return CurrentColor
				end
				return Obj
			end

			function Section:CreateKeybind(KeybindOptions)
				KeybindOptions = KeybindOptions or {}
				local VarName    = KeybindOptions.Variable or "Key"
				local DefaultKey = KeybindOptions.Default  or Enum.KeyCode.Unknown
				local Listening  = false

				getgenv()[VarName] = DefaultKey

				local Row = ElementRow(36)
				Corner(Row, 6)
				Stroke(Row, Palette.Border, 1)

				New("TextLabel", {
					Parent               = Row,
					Size                 = UDim2.new(1, -112, 1, 0),
					Position             = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                 = KeybindOptions.Name or "Keybind",
					TextColor3           = Palette.TextPrimary,
					TextSize             = 13,
					Font                 = Enum.Font.Gotham,
					TextXAlignment       = Enum.TextXAlignment.Left,
				})

				local Badge = New("Frame", {
					Parent           = Row,
					Size             = UDim2.fromOffset(88, 22),
					Position         = UDim2.new(1, -96, 0.5, -11),
					BackgroundColor3 = Palette.PanelBg,
					BorderSizePixel  = 0,
				})
				Corner(Badge, 5)
				Stroke(Badge, Palette.Border, 1)

				local BadgeLabel = New("TextLabel", {
					Parent               = Badge,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = DefaultKey.Name,
					TextColor3           = Palette.AccentText,
					TextSize             = 11,
					Font                 = Enum.Font.GothamBold,
					TextXAlignment       = Enum.TextXAlignment.Center,
				})

				local Hitbox = New("TextButton", {
					Parent               = Row,
					Size                 = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                 = "",
					ZIndex               = 2,
				})

				Hitbox.MouseEnter:Connect(function()
					Tween(Row, {BackgroundColor3 = Palette.ElementHover})
				end)
				Hitbox.MouseLeave:Connect(function()
					Tween(Row, {BackgroundColor3 = Palette.ElementBg})
				end)

				Hitbox.MouseButton1Click:Connect(function()
					if Listening then return end
					Listening = true
					BadgeLabel.Text = "..."
					BadgeLabel.TextColor3 = Palette.AccentHover
					Tween(Badge, {BackgroundColor3 = Palette.AccentDark})
				end)

				UserInputService.InputBegan:Connect(function(Input, GameProcessed)
					if Listening and Input.UserInputType == Enum.UserInputType.Keyboard then
						Listening = false
						getgenv()[VarName] = Input.KeyCode
						BadgeLabel.Text = Input.KeyCode.Name
						BadgeLabel.TextColor3 = Palette.AccentText
						Tween(Badge, {BackgroundColor3 = Palette.PanelBg})
					elseif not Listening and not GameProcessed and Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode == getgenv()[VarName] then
							if KeybindOptions.Callback then
								pcall(KeybindOptions.Callback)
							end
						end
					end
				end)

				local Obj = {}
				function Obj:Set(KeyCode)
					getgenv()[VarName] = KeyCode
					BadgeLabel.Text = KeyCode.Name
				end
				function Obj:Get()
					return getgenv()[VarName]
				end
				return Obj
			end

			function Section:CreateTextbox(TextboxOptions)
				TextboxOptions = TextboxOptions or {}

				local Row = ElementRow(36)
				Corner(Row, 6)
				Stroke(Row, Palette.Border, 1)

				if TextboxOptions.Name then
					New("TextLabel", {
						Parent               = Row,
						Size                 = UDim2.new(0.45, 0, 1, 0),
						Position             = UDim2.new(0, 12, 0, 0),
						BackgroundTransparency = 1,
						Text                 = TextboxOptions.Name,
						TextColor3           = Palette.TextPrimary,
						TextSize             = 13,
						Font                 = Enum.Font.Gotham,
						TextXAlignment       = Enum.TextXAlignment.Left,
					})
				end

				local InputBox = New("TextBox", {
					Parent               = Row,
					Size                 = TextboxOptions.Name and UDim2.new(0.55, -12, 1, 0) or UDim2.new(1, -24, 1, 0),
					Position             = TextboxOptions.Name and UDim2.new(0.45, 0, 0, 0) or UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                 = TextboxOptions.Default or "",
					TextColor3           = Palette.TextPrimary,
					PlaceholderText      = TextboxOptions.Placeholder or "Type here...",
					PlaceholderColor3    = Palette.TextMuted,
					TextSize             = 13,
					Font                 = Enum.Font.Gotham,
					BorderSizePixel      = 0,
					TextXAlignment       = TextboxOptions.Name and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
					ClearTextOnFocus     = false,
				})

				InputBox.FocusLost:Connect(function(EnterPressed)
					if TextboxOptions.Callback then
						pcall(TextboxOptions.Callback, InputBox.Text, EnterPressed)
					end
				end)

				local Obj = {}
				function Obj:Set(Text)
					InputBox.Text = Text
				end
				function Obj:Get()
					return InputBox.Text
				end
				return Obj
			end

			return Section
		end

		return Tab
	end

	return Window
end

return Library
