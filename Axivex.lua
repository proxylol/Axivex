local Axivex = {
	Version = "1.0.0",
	Flags = {},
	Options = {},
	Themes = {},
	Windows = {},
	Folder = "Axivex",
	FontFamily = "rbxasset://fonts/families/GothamSSm.json",
	_connections = {},
	_themeListeners = {},
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local function ReadGlobal(name)
	local ok, value = pcall(function()
		if getgenv then
			local v = getgenv()[name]
			if v ~= nil then
				return v
			end
		end
		return _G[name]
	end)
	return ok and value or nil
end
Axivex.Secure = ReadGlobal("AXIVEX_SECURE") == true

local function Log(message)
	if not Axivex.Secure then
		warn("[Axivex] " .. message)
	end
end

local Fonts = {
	Regular = Font.new(Axivex.FontFamily, Enum.FontWeight.Regular),
	Medium = Font.new(Axivex.FontFamily, Enum.FontWeight.Medium),
	SemiBold = Font.new(Axivex.FontFamily, Enum.FontWeight.SemiBold),
	Bold = Font.new(Axivex.FontFamily, Enum.FontWeight.Bold),
}
Axivex.Fonts = Fonts

local BaseTheme = {
	Accent = Color3.fromRGB(205, 180, 255),
	AccentDark = Color3.fromRGB(135, 98, 245),
	OnAccent = Color3.fromRGB(30, 22, 44),
	Background = Color3.fromRGB(15, 15, 19),
	Sidebar = Color3.fromRGB(19, 19, 24),
	Element = Color3.fromRGB(24, 24, 30),
	ElementHover = Color3.fromRGB(31, 31, 39),
	Field = Color3.fromRGB(16, 16, 21),
	Stroke = Color3.fromRGB(42, 42, 52),
	Text = Color3.fromRGB(240, 240, 246),
	SubText = Color3.fromRGB(152, 152, 168),
	Muted = Color3.fromRGB(98, 98, 116),
	Success = Color3.fromRGB(112, 222, 152),
	Warning = Color3.fromRGB(255, 196, 92),
	Error = Color3.fromRGB(255, 99, 112),
	Info = Color3.fromRGB(120, 175, 255),
	Shadow = Color3.fromRGB(0, 0, 0),
}

local function MakeTheme(overrides)
	local theme = {}
	for k, v in pairs(BaseTheme) do
		theme[k] = v
	end
	for k, v in pairs(overrides or {}) do
		theme[k] = v
	end
	return theme
end
Axivex.MakeTheme = MakeTheme

Axivex.Themes.Lavender = MakeTheme()
Axivex.Themes.Ocean = MakeTheme({
	Accent = Color3.fromRGB(150, 140, 255),
	AccentDark = Color3.fromRGB(70, 150, 255),
	OnAccent = Color3.fromRGB(14, 18, 40),
	Background = Color3.fromRGB(13, 15, 22),
	Sidebar = Color3.fromRGB(16, 19, 28),
	Element = Color3.fromRGB(21, 25, 36),
	ElementHover = Color3.fromRGB(28, 33, 47),
	Field = Color3.fromRGB(14, 17, 25),
	Stroke = Color3.fromRGB(38, 44, 62),
})
Axivex.Themes.Rose = MakeTheme({
	Accent = Color3.fromRGB(255, 160, 190),
	AccentDark = Color3.fromRGB(240, 82, 128),
	OnAccent = Color3.fromRGB(46, 14, 26),
	Background = Color3.fromRGB(19, 14, 17),
	Sidebar = Color3.fromRGB(23, 17, 21),
	Element = Color3.fromRGB(30, 22, 27),
	ElementHover = Color3.fromRGB(39, 28, 35),
	Field = Color3.fromRGB(20, 15, 18),
	Stroke = Color3.fromRGB(54, 39, 47),
	SubText = Color3.fromRGB(168, 148, 158),
	Muted = Color3.fromRGB(114, 96, 106),
})
Axivex.Themes.Emerald = MakeTheme({
	Accent = Color3.fromRGB(130, 236, 180),
	AccentDark = Color3.fromRGB(32, 180, 140),
	OnAccent = Color3.fromRGB(10, 36, 26),
	Background = Color3.fromRGB(13, 17, 16),
	Sidebar = Color3.fromRGB(16, 21, 20),
	Element = Color3.fromRGB(21, 27, 26),
	ElementHover = Color3.fromRGB(28, 36, 34),
	Field = Color3.fromRGB(14, 19, 18),
	Stroke = Color3.fromRGB(37, 48, 46),
})
Axivex.Themes.Amber = MakeTheme({
	Accent = Color3.fromRGB(255, 205, 120),
	AccentDark = Color3.fromRGB(255, 130, 60),
	OnAccent = Color3.fromRGB(46, 28, 8),
	Background = Color3.fromRGB(18, 16, 13),
	Sidebar = Color3.fromRGB(22, 19, 15),
	Element = Color3.fromRGB(29, 25, 20),
	ElementHover = Color3.fromRGB(38, 33, 26),
	Field = Color3.fromRGB(19, 17, 14),
	Stroke = Color3.fromRGB(52, 45, 35),
	SubText = Color3.fromRGB(166, 156, 140),
	Muted = Color3.fromRGB(112, 104, 92),
})
Axivex.Themes.Mono = MakeTheme({
	Accent = Color3.fromRGB(235, 235, 240),
	AccentDark = Color3.fromRGB(150, 150, 160),
	OnAccent = Color3.fromRGB(18, 18, 22),
	Background = Color3.fromRGB(12, 12, 13),
	Sidebar = Color3.fromRGB(16, 16, 17),
	Element = Color3.fromRGB(22, 22, 24),
	ElementHover = Color3.fromRGB(29, 29, 32),
	Field = Color3.fromRGB(14, 14, 15),
	Stroke = Color3.fromRGB(40, 40, 44),
})
Axivex.Themes.Light = MakeTheme({
	Accent = Color3.fromRGB(132, 100, 248),
	AccentDark = Color3.fromRGB(92, 60, 225),
	OnAccent = Color3.fromRGB(255, 255, 255),
	Background = Color3.fromRGB(246, 246, 250),
	Sidebar = Color3.fromRGB(238, 238, 244),
	Element = Color3.fromRGB(255, 255, 255),
	ElementHover = Color3.fromRGB(243, 241, 252),
	Field = Color3.fromRGB(240, 240, 246),
	Stroke = Color3.fromRGB(222, 222, 232),
	Text = Color3.fromRGB(24, 24, 32),
	SubText = Color3.fromRGB(100, 100, 118),
	Muted = Color3.fromRGB(150, 150, 166),
	Success = Color3.fromRGB(40, 170, 100),
	Warning = Color3.fromRGB(220, 150, 30),
	Error = Color3.fromRGB(225, 60, 80),
	Shadow = Color3.fromRGB(80, 70, 120),
})

Axivex.Theme = Axivex.Themes.Lavender
Axivex.ThemeName = "Lavender"

local function Create(class, props, children)
	local obj = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then
			parent = v
		else
			obj[k] = v
		end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = obj
	end
	if parent then
		obj.Parent = parent
	end
	return obj
end

local function Tween(obj, goal, duration, style, direction)
	local info
	if typeof(duration) == "TweenInfo" then
		info = duration
	else
		info = TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
	end
	local tween = TweenService:Create(obj, info, goal)
	tween:Play()
	return tween
end

local function Connect(signal, fn)
	local conn = signal:Connect(fn)
	table.insert(Axivex._connections, conn)
	return conn
end

local function SafeCall(fn, ...)
	if type(fn) ~= "function" then
		return
	end
	local ok, err = pcall(fn, ...)
	if not ok then
		Log("Callback error: " .. tostring(err))
	end
end

local function Spawn(fn, ...)
	if type(fn) == "function" then
		task.spawn(SafeCall, fn, ...)
	end
end

local function Trim(s)
	return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function Decimals(n)
	local s = tostring(n)
	local d = s:match("%.(%d+)$")
	return d and #d or 0
end

local function IsClick(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function IsMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function ResolveIcon(icon)
	if icon == nil or icon == 0 or icon == "" then
		return nil
	end
	if type(icon) == "number" then
		if Axivex.Secure or icon < 0 then
			return nil
		end
		return string.format("rbxassetid://%d", icon)
	end
	if type(icon) ~= "string" then
		return nil
	end
	if icon:match("^rbxasset://.+") then
		return icon
	end
	if Axivex.Secure then
		return nil
	end
	if icon:match("^rbxassetid://%d+$") or icon:match("^rbxthumb://.+") then
		return icon
	end
	return nil
end

function Axivex:CustomAsset(path, url)
	if type(getcustomasset) ~= "function" or type(isfile) ~= "function" then
		return nil
	end
	local ok, asset = pcall(function()
		if not isfile(path) then
			if not url then
				return nil
			end
			local folder = path:match("^(.*)/[^/]+$")
			if folder and type(makefolder) == "function" then
				local current = ""
				for part in folder:gmatch("[^/]+") do
					current = current == "" and part or (current .. "/" .. part)
					if not (type(isfolder) == "function" and isfolder(current)) then
						makefolder(current)
					end
				end
			end
			writefile(path, game:HttpGet(url))
		end
		return getcustomasset(path)
	end)
	if not ok then
		Log("Couldn't load custom asset '" .. tostring(path) .. "': " .. tostring(asset))
		return nil
	end
	return asset
end

local Rich = {}
function Rich.Escape(text)
	return (tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end
function Rich.Color(text, color)
	if typeof(color) ~= "Color3" then
		color = Axivex.Theme[color] or Axivex.Theme.Text
	end
	return string.format('<font color="#%s">%s</font>', color:ToHex(), tostring(text))
end
function Rich.Bold(text)
	return "<b>" .. tostring(text) .. "</b>"
end
function Rich.Italic(text)
	return "<i>" .. tostring(text) .. "</i>"
end
function Rich.Strip(text)
	return (tostring(text):gsub("<[^>]->", ""))
end
Axivex.Rich = Rich

local Themed = {}

local function Resolve(key)
	if type(key) == "function" then
		return key(Axivex.Theme)
	end
	return Axivex.Theme[key]
end

local function Bind(obj, props)
	local bound = Themed[obj]
	if not bound then
		bound = {}
		pcall(function()
			obj.Destroying:Connect(function()
				Themed[obj] = nil
			end)
		end)
	end
	for prop, key in pairs(props) do
		if typeof(key) == "Color3" then
			local color = key
			key = function()
				return color
			end
		end
		bound[prop] = key
		obj[prop] = Resolve(key)
	end
	Themed[obj] = bound
	return obj
end

local Tweenable = { Color3 = true, number = true, UDim2 = true, UDim = true, Vector2 = true }

local function Restyle(obj, duration)
	local bound = Themed[obj]
	if not bound then
		return
	end
	local goal, any = {}, false
	for prop, key in pairs(bound) do
		local value = Resolve(key)
		if Tweenable[typeof(value)] then
			goal[prop] = value
			any = true
		else
			obj[prop] = value
		end
	end
	if any then
		Tween(obj, goal, duration or 0.25)
	end
end

function Axivex:SetTheme(theme)
	if type(theme) == "string" then
		self.ThemeName = theme
		theme = self.Themes[theme]
	else
		self.ThemeName = "Custom"
	end
	if type(theme) ~= "table" then
		return
	end
	self.Theme = MakeTheme(theme)
	local stale = {}
	for obj in pairs(Themed) do
		if obj.Parent then
			Restyle(obj, 0.35)
		else
			table.insert(stale, obj)
		end
	end
	for _, obj in ipairs(stale) do
		Themed[obj] = nil
	end
	for _, fn in ipairs(self._themeListeners) do
		Spawn(fn, self.Theme)
	end
end

function Axivex:SetAccent(color, darkColor)
	local theme = MakeTheme(self.Theme)
	theme.Accent = color
	if darkColor then
		theme.AccentDark = darkColor
	else
		local h, s, v = color:ToHSV()
		theme.AccentDark = Color3.fromHSV((h + 0.04) % 1, math.min(1, s + 0.3), v * 0.85)
	end
	local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
	theme.OnAccent = luminance > 0.6 and Color3.fromRGB(24, 20, 34) or Color3.fromRGB(255, 255, 255)
	local name = self.ThemeName
	self:SetTheme(theme)
	self.ThemeName = name
end

function Axivex:OnThemeChanged(fn)
	table.insert(self._themeListeners, fn)
end

local function Corner(parent, radius)
	return Create("UICorner", {
		CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius or 8),
		Parent = parent,
	})
end

local function Round(parent)
	return Corner(parent, UDim.new(1, 0))
end

local function Stroke(parent, key, thickness)
	local stroke = Create("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = thickness or 1,
		Parent = parent,
	})
	Bind(stroke, { Color = key or "Stroke" })
	return stroke
end

local function Pad(parent, top, bottom, left, right)
	return Create("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or top or 0),
		PaddingRight = UDim.new(0, right or left or top or 0),
		Parent = parent,
	})
end

local function List(parent, padding, direction, hAlign, vAlign)
	return Create("UIListLayout", {
		Padding = UDim.new(0, padding or 0),
		FillDirection = direction or Enum.FillDirection.Vertical,
		HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left,
		VerticalAlignment = vAlign or Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

local function Label(p)
	local label = Create("TextLabel", {
		Name = p.Name or "Label",
		BackgroundTransparency = 1,
		Text = p.Text or "",
		FontFace = p.Font or Fonts.Regular,
		TextSize = p.TextSize or 14,
		TextXAlignment = p.XAlign or Enum.TextXAlignment.Left,
		TextYAlignment = p.YAlign or Enum.TextYAlignment.Center,
		Size = p.Size or UDim2.fromScale(1, 1),
		Position = p.Position or UDim2.new(),
		AnchorPoint = p.AnchorPoint or Vector2.zero,
		AutomaticSize = p.AutomaticSize or Enum.AutomaticSize.None,
		TextWrapped = p.Wrapped or false,
		TextTruncate = p.Truncate or Enum.TextTruncate.None,
		RichText = p.RichText or false,
		LayoutOrder = p.LayoutOrder or 0,
		ZIndex = p.ZIndex or 1,
		Visible = p.Visible ~= false,
		Parent = p.Parent,
	})
	Bind(label, { TextColor3 = p.Color or "Text" })
	return label
end

local function AccentGradient(parent, rotation)
	local gradient = Create("UIGradient", { Rotation = rotation or 0, Parent = parent })
	Bind(gradient, {
		Color = function(t)
			return ColorSequence.new(t.AccentDark, t.Accent)
		end,
	})
	return gradient
end

local function Shimmer(parent)
	local shine = Create("Frame", {
		Name = "Shimmer",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = parent,
	})
	Round(shine)
	local gradient = Create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.4, 1),
			NumberSequenceKeypoint.new(0.5, 0.6),
			NumberSequenceKeypoint.new(0.6, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Offset = Vector2.new(-1, 0),
		Parent = shine,
	})
	TweenService:Create(
		gradient,
		TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false, 0.6),
		{ Offset = Vector2.new(1, 0) }
	):Play()
	return shine
end

local function Field(parent, size, position, p)
	p = p or {}
	local focused = false
	local frame = Create("Frame", {
		Size = size,
		Position = position or UDim2.new(),
		AnchorPoint = p.AnchorPoint or Vector2.zero,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = p.LayoutOrder or 0,
		Parent = parent,
	})
	Bind(frame, { BackgroundColor3 = "Field" })
	Corner(frame, 6)
	local stroke = Stroke(frame)
	Bind(stroke, {
		Color = function(t)
			return focused and t.Accent or t.Stroke
		end,
	})
	local box = Create("TextBox", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -20, 1, 0),
		Text = p.Text or "",
		PlaceholderText = p.Placeholder or "",
		ClearTextOnFocus = p.ClearOnFocus or false,
		FontFace = p.Font or Fonts.Regular,
		TextSize = p.TextSize or 13,
		TextXAlignment = p.XAlign or Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})
	Bind(box, { TextColor3 = "Text", PlaceholderColor3 = "Muted" })
	box.Focused:Connect(function()
		focused = true
		Restyle(stroke, 0.2)
	end)
	box.FocusLost:Connect(function()
		focused = false
		Restyle(stroke, 0.2)
	end)
	return frame, box
end

local ChevronShapes = {
	right = { { 45, 0, -2 }, { -45, 0, 2 } },
	left = { { -45, 0, -2 }, { 45, 0, 2 } },
	down = { { 45, -2, 0 }, { -45, 2, 0 } },
	up = { { -45, -2, 0 }, { 45, 2, 0 } },
}

local function Chevron(parent, direction, colorKey, position)
	local holder = Create("Frame", {
		Name = "Chevron",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = position or UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		Parent = parent,
	})
	local bars = {}
	for i = 1, 2 do
		local bar = Create("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(8, 2),
			Parent = holder,
		})
		Round(bar)
		Bind(bar, { BackgroundColor3 = colorKey or "SubText" })
		bars[i] = bar
	end
	local chevron = { Holder = holder, Bars = bars }
	function chevron:Set(dir, instant)
		for i, bar in ipairs(bars) do
			local shape = ChevronShapes[dir][i]
			local goal = { Rotation = shape[1], Position = UDim2.new(0.5, shape[2], 0.5, shape[3]) }
			if instant then
				bar.Rotation = goal.Rotation
				bar.Position = goal.Position
			else
				Tween(bar, goal, 0.3)
			end
		end
	end
	chevron:Set(direction or "right", true)
	return chevron
end

local function Ripple(button, position)
	local abs = button.AbsolutePosition
	local circle = Create("Frame", {
		Name = "Ripple",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(position.X - abs.X, position.Y - abs.Y),
		Size = UDim2.fromOffset(0, 0),
		ZIndex = 5,
		Parent = button,
	})
	Round(circle)
	local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
	Tween(circle, { Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1 }, 0.7)
	task.delay(0.7, function()
		circle:Destroy()
	end)
end

local function TrackDrag(area, onUpdate, onStart, onEnd)
	local dragging = false
	local function update(position)
		local abs, size = area.AbsolutePosition, area.AbsoluteSize
		onUpdate(
			math.clamp((position.X - abs.X) / math.max(size.X, 1), 0, 1),
			math.clamp((position.Y - abs.Y) / math.max(size.Y, 1), 0, 1)
		)
	end
	area.InputBegan:Connect(function(input)
		if IsClick(input) then
			dragging = true
			if onStart then
				onStart()
			end
			update(input.Position)
		end
	end)
	Connect(UserInputService.InputChanged, function(input)
		if dragging and IsMove(input) then
			update(input.Position)
		end
	end)
	Connect(UserInputService.InputEnded, function(input)
		if dragging and IsClick(input) then
			dragging = false
			if onEnd then
				onEnd()
			end
		end
	end)
end

local function MakeDraggable(handle, target)
	local dragging, start, startPos, moved = false, nil, nil, false
	handle.InputBegan:Connect(function(input)
		if IsClick(input) then
			dragging, moved = true, false
			start, startPos = input.Position, target.Position
		end
	end)
	Connect(UserInputService.InputChanged, function(input)
		if dragging and IsMove(input) then
			local delta = input.Position - start
			if delta.Magnitude > 4 then
				moved = true
			end
			Tween(target, {
				Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				),
			}, 0.12)
		end
	end)
	Connect(UserInputService.InputEnded, function(input)
		if IsClick(input) then
			dragging = false
		end
	end)
	return function()
		return moved
	end
end

local FadeProps = {
	Frame = { "BackgroundTransparency" },
	TextLabel = { "BackgroundTransparency", "TextTransparency" },
	TextButton = { "BackgroundTransparency", "TextTransparency" },
	TextBox = { "BackgroundTransparency", "TextTransparency" },
	ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
	ImageButton = { "BackgroundTransparency", "ImageTransparency" },
	ScrollingFrame = { "BackgroundTransparency", "ScrollBarImageTransparency" },
	UIStroke = { "Transparency" },
}
local FadeCache = setmetatable({}, { __mode = "k" })

local function FadeTree(root, visible, duration)
	local cache = FadeCache[root]
	if not cache then
		cache = {}
		local items = root:GetDescendants()
		table.insert(items, root)
		for _, inst in ipairs(items) do
			local props = FadeProps[inst.ClassName]
			if props then
				local saved = {}
				for _, prop in ipairs(props) do
					saved[prop] = inst[prop]
				end
				cache[inst] = saved
			end
		end
		FadeCache[root] = cache
	end
	for inst, saved in pairs(cache) do
		local goal = {}
		for prop, value in pairs(saved) do
			if visible then
				inst[prop] = 1
				goal[prop] = value
			else
				goal[prop] = 1
			end
		end
		Tween(inst, goal, duration or 0.25)
	end
end

local function ParentGui(gui)
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)
	if gethui then
		local ok, hui = pcall(gethui)
		if ok and hui then
			gui.Parent = hui
			return
		end
	end
	local ok = pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end)
	if not ok then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
end

local KeyNames = {
	LeftShift = "LShift",
	RightShift = "RShift",
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Return = "Enter",
	MouseButton1 = "MB1",
	MouseButton2 = "MB2",
	MouseButton3 = "MB3",
	Backquote = "`",
	CapsLock = "Caps",
	PageUp = "PgUp",
	PageDown = "PgDn",
}

local function KeyName(key)
	if not key then
		return "None"
	end
	return KeyNames[key.Name] or key.Name
end

local function ParseKey(value)
	if typeof(value) == "EnumItem" then
		return value
	end
	if type(value) ~= "string" or value == "" or value == "None" then
		return nil
	end
	local ok, key = pcall(function()
		return Enum.KeyCode[value]
	end)
	if ok and key then
		return key
	end
	ok, key = pcall(function()
		return Enum.UserInputType[value]
	end)
	return ok and key or nil
end

local function KeyMatches(input, key)
	if not key then
		return false
	end
	if key.EnumType == Enum.KeyCode then
		return input.KeyCode == key
	end
	return input.UserInputType == key
end

local FS = {
	Enabled = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function",
	Memory = {},
}
Axivex.FileSystem = FS

function FS.EnsureFolder(path)
	if not FS.Enabled or type(makefolder) ~= "function" then
		return
	end
	local current = ""
	for part in string.gmatch(path, "[^/]+") do
		current = current == "" and part or (current .. "/" .. part)
		local ok, exists = pcall(isfolder, current)
		if not (ok and exists) then
			pcall(makefolder, current)
		end
	end
end

function FS.Write(path, data)
	if FS.Enabled then
		return pcall(writefile, path, data)
	end
	FS.Memory[path] = data
	return true
end

function FS.Read(path)
	if FS.Enabled then
		local ok, exists = pcall(isfile, path)
		if ok and exists then
			local ok2, data = pcall(readfile, path)
			if ok2 then
				return data
			end
		end
		return nil
	end
	return FS.Memory[path]
end

function FS.Delete(path)
	if FS.Enabled then
		if type(delfile) == "function" then
			return pcall(delfile, path)
		end
		return false
	end
	FS.Memory[path] = nil
	return true
end

function FS.List(folder)
	if FS.Enabled then
		if type(listfiles) ~= "function" then
			return {}
		end
		local ok, files = pcall(listfiles, folder)
		return ok and files or {}
	end
	local out = {}
	for path in pairs(FS.Memory) do
		if path:sub(1, #folder + 1) == folder .. "/" then
			table.insert(out, path)
		end
	end
	return out
end

local function Encode(value)
	local kind = typeof(value)
	if value == nil then
		return { __t = "nil" }
	elseif kind == "Color3" then
		return { __t = "Color3", v = value:ToHex() }
	elseif kind == "EnumItem" then
		return { __t = "Enum", e = tostring(value.EnumType), n = value.Name }
	end
	return value
end

local function Decode(value)
	if type(value) == "table" and value.__t then
		if value.__t == "Color3" then
			local ok, color = pcall(Color3.fromHex, value.v)
			return ok and color or nil
		elseif value.__t == "Enum" then
			local ok, item = pcall(function()
				return Enum[value.e][value.n]
			end)
			return ok and item or nil
		end
		return nil
	end
	return value
end

local Element = {}
Element.__index = Element

function Element:_headerHeight()
	local hasDesc = self.Desc ~= nil and self.Desc ~= ""
	return self._heights[hasDesc and 2 or 1]
end

function Element:_relayout(animate)
	local h = self:_headerHeight()
	self.Header.Size = UDim2.new(1, 0, 0, h)
	self.Body.Position = UDim2.fromOffset(0, h)
	self.Body.Size = UDim2.new(1, 0, 1, -h)
	local size = UDim2.new(1, 0, 0, h + self._fixed + self._extra)
	if animate then
		Tween(self.Card, { Size = size }, 0.35)
	else
		self.Card.Size = size
	end
end

function Element:_fire(...)
	if self.Flag then
		Axivex.Flags[self.Flag] = self.Value
	end
	Spawn(self._onChange or self.Callback, ...)
	for _, fn in ipairs(self._listeners) do
		Spawn(fn, ...)
	end
	if self.Flag and self.Window then
		self.Window:_changed()
	end
end

function Element:Get()
	return self.Value
end

function Element:OnChanged(fn)
	table.insert(self._listeners, fn)
	return self
end

function Element:SetCallback(fn)
	self.Callback = fn
end

function Element:SetTitle(text)
	self.Title = text
	if self._titleLabel then
		self._titleLabel.Text = text
	end
end

function Element:SetDesc(text)
	self.Desc = text
	if self._descLabel then
		self._descLabel.Text = text or ""
		self._descLabel.Visible = text ~= nil and text ~= ""
		self:_relayout(true)
	end
end

function Element:SetVisible(visible)
	self.Card.Visible = visible
end

function Element:Lock(reason)
	if self._lock then
		return
	end
	local overlay = Create("TextButton", {
		Name = "Lock",
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 10,
		Parent = self.Card,
	})
	Bind(overlay, { BackgroundColor3 = "Background" })
	Corner(overlay, 8)
	local text = Label({
		Text = reason or "Locked",
		Font = Fonts.Medium,
		TextSize = 12,
		XAlign = Enum.TextXAlignment.Right,
		Size = UDim2.new(1, -16, 0, self._heights and self:_headerHeight() or 40),
		Color = "SubText",
		ZIndex = 11,
		Parent = overlay,
	})
	text.TextTransparency = 1
	Tween(overlay, { BackgroundTransparency = 0.3 }, 0.25)
	Tween(text, { TextTransparency = 0 }, 0.25)
	self._lock = overlay
	self.Locked = true
end

function Element:Unlock()
	local overlay = self._lock
	if not overlay then
		return
	end
	self._lock = nil
	self.Locked = false
	Tween(overlay, { BackgroundTransparency = 1 }, 0.25)
	for _, child in ipairs(overlay:GetChildren()) do
		if child:IsA("TextLabel") then
			Tween(child, { TextTransparency = 1 }, 0.2)
		end
	end
	task.delay(0.25, function()
		overlay:Destroy()
	end)
end

function Element:Destroy()
	if self.Flag then
		Axivex.Options[self.Flag] = nil
		Axivex.Flags[self.Flag] = nil
	end
	self.Card:Destroy()
end

local function NextOrder(container)
	container._order = container._order + 1
	return container._order
end

local function TagPill(parent, data, large, order)
	if type(data) ~= "table" then
		data = { Text = tostring(data) }
	end
	local color = function(t)
		return data.Color or t.Accent
	end
	local pill = Create("Frame", {
		Name = "Tag",
		BorderSizePixel = 0,
		BackgroundTransparency = 0.86,
		Size = UDim2.fromOffset(0, large and 24 or 16),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = order or 0,
		Parent = parent,
	})
	Corner(pill, large and 6 or 4)
	Bind(pill, { BackgroundColor3 = color })
	local stroke = Stroke(pill)
	stroke.Transparency = 0.65
	Bind(stroke, { Color = color })
	Pad(pill, 0, 0, large and 9 or 6, large and 9 or 6)
	List(pill, large and 5 or 4, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
	local iconImage = ResolveIcon(data.Icon)
	if iconImage then
		local size = large and 13 or 10
		local icon = Create("ImageLabel", {
			Name = "Icon",
			BackgroundTransparency = 1,
			Image = iconImage,
			Size = UDim2.fromOffset(size, size),
			LayoutOrder = 1,
			Parent = pill,
		})
		Bind(icon, { ImageColor3 = color })
	end
	Label({
		Text = large and tostring(data.Text) or tostring(data.Text):upper(),
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		Font = large and Fonts.Medium or Fonts.Bold,
		TextSize = large and 12 or 10,
		Color = color,
		LayoutOrder = 2,
		Parent = pill,
	})
	return pill
end

local function NewElement(container, opts, cfg)
	local primary = cfg.Primary
	local el = setmetatable({
		Type = cfg.Type,
		Title = opts.Title or opts.Name or cfg.Type,
		Desc = opts.Desc or opts.Description,
		Flag = opts.Flag,
		Callback = opts.Callback,
		Window = container.Window,
		_listeners = {},
		_heights = cfg.Height or { 40, 54 },
		_fixed = cfg.Fixed or 0,
		_extra = 0,
		_hover = false,
	}, Element)

	local card = Create("Frame", {
		Name = cfg.Type,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 40),
		LayoutOrder = NextOrder(container),
		Parent = container.Frame,
	})
	Corner(card, 8)
	local stroke = Stroke(card, primary and "Accent" or "Stroke")
	Bind(card, {
		BackgroundColor3 = function(t)
			if primary then
				return el._hover and t.Accent:Lerp(Color3.new(1, 1, 1), 0.15) or t.Accent
			end
			return el._hover and t.ElementHover or t.Element
		end,
	})

	local header = Create("TextButton", {
		Name = "Header",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 40),
		Parent = card,
	})
	local body = Create("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -40),
		Position = UDim2.fromOffset(0, 40),
		Parent = card,
	})

	local textX = 14
	local iconImage = ResolveIcon(opts.Icon)
	if iconImage then
		local icon = Create("ImageLabel", {
			Name = "Icon",
			BackgroundTransparency = 1,
			Image = iconImage,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 14, 0.5, 0),
			Size = UDim2.fromOffset(18, 18),
			Parent = header,
		})
		Bind(icon, { ImageColor3 = primary and "OnAccent" or "SubText" })
		textX = 42
	end

	local holder = Create("Frame", {
		Name = "Text",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(textX, 0),
		Size = UDim2.new(1, -(textX + (cfg.RightWidth or 14)), 1, 0),
		Parent = header,
	})
	List(holder, 2, nil, nil, Enum.VerticalAlignment.Center)

	local titleRow = Create("Frame", {
		Name = "TitleRow",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 18),
		LayoutOrder = 1,
		Parent = holder,
	})
	List(titleRow, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)

	el._titleLabel = Label({
		Name = "Title",
		Text = el.Title,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Font = Fonts.Medium,
		TextSize = 14,
		Color = primary and "OnAccent" or "Text",
		LayoutOrder = 1,
		Parent = titleRow,
	})

	local tags = opts.Tags or (opts.Tag and { opts.Tag }) or {}
	for i, tag in ipairs(tags) do
		TagPill(titleRow, tag, false, i + 1)
	end

	el._descLabel = Label({
		Name = "Desc",
		Text = el.Desc or "",
		Size = UDim2.new(1, 0, 0, 15),
		TextSize = 12,
		Truncate = Enum.TextTruncate.AtEnd,
		Color = primary and "OnAccent" or "SubText",
		Visible = el.Desc ~= nil and el.Desc ~= "",
		LayoutOrder = 2,
		Parent = holder,
	})
	if primary then
		el._descLabel.TextTransparency = 0.3
	end

	card.MouseEnter:Connect(function()
		el._hover = true
		Restyle(card, 0.2)
	end)
	card.MouseLeave:Connect(function()
		el._hover = false
		Restyle(card, 0.2)
	end)

	el.Card, el.Header, el.Body, el.Stroke = card, header, body, stroke
	el:_relayout(false)
	if opts.Visible == false then
		card.Visible = false
	end
	return el
end

local function Register(el, opts)
	if el.Flag then
		Axivex.Options[el.Flag] = el
		Axivex.Flags[el.Flag] = el.Value
	end
	if opts.Locked then
		el:Lock(opts.LockReason)
	end
	return el
end

local function Wrap(card, kind, container)
	return setmetatable({
		Type = kind,
		Card = card,
		Window = container.Window,
		_listeners = {},
	}, Element)
end

local function Opts(opts, callback)
	if type(opts) == "string" then
		return { Title = opts, Callback = callback }
	end
	return opts or {}
end

local Container = {}
local ContainerMeta = { __index = Container }

function Container:Section(opts)
	if type(opts) ~= "table" then
		opts = { Title = opts }
	end
	local frame = Create("Frame", {
		Name = "Section",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	List(frame, 8)
	local section = setmetatable({
		Type = "Section",
		Frame = frame,
		Window = self.Window,
		Title = opts.Title,
		_order = 0,
	}, ContainerMeta)
	if opts.Title then
		local row = Create("Frame", {
			Name = "SectionHeader",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 24),
			Parent = frame,
		})
		Pad(row, 0, 5, 2, 0)
		List(row, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Bottom)
		local iconImage = ResolveIcon(opts.Icon)
		if iconImage then
			local icon = Create("ImageLabel", {
				Name = "Icon",
				BackgroundTransparency = 1,
				Image = iconImage,
				Size = UDim2.fromOffset(13, 13),
				LayoutOrder = 1,
				Parent = row,
			})
			Bind(icon, { ImageColor3 = "Muted" })
		end
		section._header = Label({
			Name = "SectionTitle",
			Text = tostring(opts.Title):upper(),
			Size = UDim2.fromOffset(0, 13),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = Fonts.SemiBold,
			TextSize = 11,
			Color = "Muted",
			LayoutOrder = 2,
			Parent = row,
		})
	end
	return section
end

function Container:SetTitle(text)
	self.Title = text
	if self._header then
		self._header.Text = tostring(text):upper()
	end
end

function Container:SetVisible(visible)
	self.Frame.Visible = visible
end

function Container:Button(opts, callback)
	opts = Opts(opts, callback)
	local primary = opts.Primary or opts.Style == "Primary"
	local el = NewElement(self, opts, { Type = "Button", RightWidth = 36, Primary = primary })
	local scale = Create("UIScale", { Parent = el.Card })
	Chevron(el.Header, "right", primary and "OnAccent" or "SubText")

	el.Header.InputBegan:Connect(function(input)
		if IsClick(input) then
			Ripple(el.Card, input.Position)
			Tween(scale, { Scale = 0.985 }, 0.12)
		end
	end)
	el.Header.InputEnded:Connect(function(input)
		if IsClick(input) then
			Tween(scale, { Scale = 1 }, 0.3, Enum.EasingStyle.Back)
		end
	end)
	el.Header.MouseButton1Click:Connect(function()
		el:Fire()
	end)

	function el:Fire()
		if self.Locked then
			return
		end
		Spawn(self.Callback)
		for _, fn in ipairs(self._listeners) do
			Spawn(fn)
		end
	end

	return Register(el, opts)
end

function Container:Toggle(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "Toggle", RightWidth = 66 })
	el.Value = opts.Default == true or opts.Value == true

	local track = Create("Frame", {
		Name = "Track",
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(38, 20),
		Parent = el.Header,
	})
	Round(track)
	Bind(track, {
		BackgroundColor3 = function(t)
			return el.Value and t.Accent or t.Field
		end,
	})
	local trackStroke = Stroke(track)
	Bind(trackStroke, {
		Color = function(t)
			return el.Value and t.Accent or t.Stroke
		end,
	})
	local knob = Create("Frame", {
		Name = "Knob",
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(14, 14),
		Parent = track,
	})
	Round(knob)
	Bind(knob, {
		BackgroundColor3 = function(t)
			return el.Value and t.OnAccent or t.Muted
		end,
		Position = function()
			return el.Value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		end,
	})

	function el:Set(value, silent)
		value = value == true
		local changed = value ~= self.Value
		self.Value = value
		Restyle(track, 0.25)
		Restyle(trackStroke, 0.25)
		Restyle(knob, 0.3)
		if changed then
			Tween(knob, { Size = UDim2.fromOffset(18, 14) }, 0.12)
			task.delay(0.12, function()
				Tween(knob, { Size = UDim2.fromOffset(14, 14) }, 0.2)
			end)
		end
		if not silent then
			self:_fire(value)
		end
	end

	el.Header.MouseButton1Click:Connect(function()
		el:Set(not el.Value)
	end)

	return Register(el, opts)
end

function Container:Slider(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "Slider", Height = { 38, 52 }, Fixed = 18, RightWidth = 90 })
	el.Min = opts.Min or 0
	el.Max = opts.Max or 100
	el.Increment = opts.Increment or opts.Rounding or 1
	el.Suffix = opts.Suffix or ""
	local decimals = Decimals(el.Increment)

	local function format(v)
		if opts.Format then
			return opts.Format(v)
		end
		return string.format("%." .. decimals .. "f", v) .. el.Suffix
	end

	local valueFocused = false
	local valueFrame = Create("Frame", {
		Name = "ValueBox",
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(0, 22),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = el.Header,
	})
	Corner(valueFrame, 6)
	Bind(valueFrame, { BackgroundColor3 = "Field" })
	Create("UISizeConstraint", { MinSize = Vector2.new(42, 22), Parent = valueFrame })
	Pad(valueFrame, 0, 0, 8, 8)
	List(valueFrame, 0, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
	local valueStroke = Stroke(valueFrame)
	Bind(valueStroke, {
		Color = function(t)
			return valueFocused and t.Accent or t.Stroke
		end,
	})
	local valueBox = Create("TextBox", {
		Name = "Value",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = Fonts.Medium,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		ClearTextOnFocus = false,
		Text = "",
		Parent = valueFrame,
	})
	Bind(valueBox, { TextColor3 = "Text" })
	valueBox.Focused:Connect(function()
		valueFocused = true
		Restyle(valueStroke, 0.2)
	end)
	valueBox.FocusLost:Connect(function()
		valueFocused = false
		Restyle(valueStroke, 0.2)
	end)

	local bar = Create("Frame", {
		Name = "Bar",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 2),
		Size = UDim2.new(1, -28, 0, 6),
		Parent = el.Body,
	})
	Round(bar)
	Bind(bar, { BackgroundColor3 = "Field" })
	local fill = Create("Frame", {
		Name = "Fill",
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.fromScale(0, 1),
		Parent = bar,
	})
	Round(fill)
	AccentGradient(fill)
	local knob = Create("Frame", {
		Name = "Knob",
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(12, 12),
		ZIndex = 2,
		Parent = bar,
	})
	Round(knob)
	Bind(knob, { BackgroundColor3 = "Accent" })
	local hit = Create("TextButton", {
		Name = "Hit",
		Text = "",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, 22),
		ZIndex = 3,
		Parent = bar,
	})

	local dragging = false
	function el:Set(value, silent)
		value = tonumber(value) or self.Min
		local range = self.Max - self.Min
		value = math.floor((value - self.Min) / self.Increment + 0.5) * self.Increment + self.Min
		value = math.clamp(tonumber(string.format("%." .. decimals .. "f", value)), self.Min, self.Max)
		local changed = value ~= self.Value
		self.Value = value
		local alpha = range ~= 0 and (value - self.Min) / range or 0
		local speed = dragging and 0.08 or 0.3
		Tween(fill, { Size = UDim2.fromScale(alpha, 1) }, speed)
		Tween(knob, { Position = UDim2.fromScale(alpha, 0.5) }, speed)
		if not valueBox:IsFocused() then
			valueBox.Text = format(value)
		end
		if changed and not silent then
			self:_fire(value)
		end
	end

	function el:SetMin(min)
		self.Min = min
		self:Set(self.Value)
	end

	function el:SetMax(max)
		self.Max = max
		self:Set(self.Value)
	end

	TrackDrag(hit, function(x)
		if el.Locked then
			return
		end
		el:Set(el.Min + (el.Max - el.Min) * x)
	end, function()
		dragging = true
		Tween(knob, { Size = UDim2.fromOffset(16, 16) }, 0.2)
	end, function()
		dragging = false
		Tween(knob, { Size = UDim2.fromOffset(12, 12) }, 0.25)
	end)

	valueBox.FocusLost:Connect(function()
		local number = tonumber((valueBox.Text:gsub("[^%d%.%-]", "")))
		if number then
			el:Set(number)
		end
		valueBox.Text = format(el.Value)
	end)

	el:Set(opts.Default or opts.Value or el.Min, true)
	return Register(el, opts)
end

function Container:Dropdown(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "Dropdown", RightWidth = 200 })
	local initialOptions = opts.Options or opts.Values or {}
	el.Options = {}
	el.Multi = opts.Multi or opts.Multiple or false
	el.AllowNull = opts.AllowNull or el.Multi
	el.MaxVisible = opts.MaxVisible or 5
	el.Opened = false

	local selected = {}
	local rows = {}

	local valueLabel = Label({
		Name = "Value",
		Text = "None",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -36, 0.5, 0),
		Size = UDim2.fromOffset(150, 16),
		XAlign = Enum.TextXAlignment.Right,
		Truncate = Enum.TextTruncate.AtEnd,
		TextSize = 13,
		Color = "SubText",
		Parent = el.Header,
	})
	local chevron = Chevron(el.Header, "down")

	local separator = Create("Frame", {
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -28, 0, 1),
		Parent = el.Body,
	})
	Bind(separator, { BackgroundColor3 = "Stroke" })

	local searchable = opts.Search
	if searchable == nil then
		searchable = #initialOptions > 8
	end
	local searchBox
	local listY = 8
	if searchable then
		local _, box = Field(el.Body, UDim2.new(1, -28, 0, 28), UDim2.fromOffset(14, 9), { Placeholder = "Search..." })
		searchBox = box
		listY = 45
	end

	local list = Create("ScrollingFrame", {
		Name = "List",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, listY),
		Size = UDim2.new(1, -28, 0, 0),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = el.Body,
	})
	Bind(list, { ScrollBarImageColor3 = "Stroke" })
	List(list, 2)

	local function visibleCount()
		local count = 0
		for _, row in ipairs(rows) do
			if row.Button.Visible then
				count = count + 1
			end
		end
		return count
	end

	local function updateSize()
		local n = math.min(visibleCount(), el.MaxVisible)
		local listHeight = math.max(n * 32 - 2, 0)
		list.Size = UDim2.new(1, -28, 0, listHeight)
		if el.Opened then
			el._extra = listY + listHeight + 8
			el:_relayout(true)
		end
	end

	local function display()
		if el.Multi then
			local values = {}
			for _, option in ipairs(el.Options) do
				if selected[option] then
					table.insert(values, option)
				end
			end
			el.Value = values
			local names = {}
			for i, v in ipairs(values) do
				names[i] = tostring(v)
			end
			valueLabel.Text = #names > 0 and table.concat(names, ", ") or "None"
		else
			el.Value = nil
			for _, option in ipairs(el.Options) do
				if selected[option] then
					el.Value = option
					break
				end
			end
			valueLabel.Text = el.Value ~= nil and tostring(el.Value) or "None"
		end
		for _, row in ipairs(rows) do
			Restyle(row.Button, 0.2)
			Restyle(row.Text, 0.2)
			Restyle(row.Dot, 0.25)
		end
	end

	local function makeRow(option)
		local row = { Option = option, Hover = false }
		local button = Create("TextButton", {
			Name = "Option",
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			Parent = list,
		})
		Corner(button, 6)
		Bind(button, {
			BackgroundColor3 = function(t)
				return selected[option] and t.Accent or t.Text
			end,
			BackgroundTransparency = function()
				if selected[option] then
					return 0.88
				elseif row.Hover then
					return 0.95
				end
				return 1
			end,
		})
		local text = Label({
			Text = tostring(option),
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -30, 1, 0),
			Font = Fonts.Medium,
			TextSize = 13,
			Truncate = Enum.TextTruncate.AtEnd,
			Color = function(t)
				return selected[option] and t.Accent or t.SubText
			end,
			Parent = button,
		})
		local dot = Create("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Parent = button,
		})
		Round(dot)
		Bind(dot, {
			BackgroundColor3 = "Accent",
			Size = function()
				return selected[option] and UDim2.fromOffset(6, 6) or UDim2.fromOffset(0, 0)
			end,
		})
		button.MouseEnter:Connect(function()
			row.Hover = true
			Restyle(button, 0.15)
		end)
		button.MouseLeave:Connect(function()
			row.Hover = false
			Restyle(button, 0.15)
		end)
		button.MouseButton1Click:Connect(function()
			el:_choose(option)
		end)
		row.Button, row.Text, row.Dot = button, text, dot
		table.insert(rows, row)
	end

	function el:_choose(option)
		if self.Multi then
			selected[option] = not selected[option] or nil
		else
			if selected[option] then
				if not self.AllowNull then
					self:SetOpen(false)
					return
				end
				selected[option] = nil
			else
				for k in pairs(selected) do
					selected[k] = nil
				end
				selected[option] = true
			end
			if opts.CloseOnSelect ~= false then
				self:SetOpen(false)
			end
		end
		display()
		self:_fire(self.Value)
	end

	function el:SetOpen(state)
		if self.Locked then
			return
		end
		self.Opened = state
		local n = math.min(visibleCount(), self.MaxVisible)
		local listHeight = math.max(n * 32 - 2, 0)
		list.Size = UDim2.new(1, -28, 0, listHeight)
		self._extra = state and (listY + listHeight + 8) or 0
		self:_relayout(true)
		chevron:Set(state and "up" or "down")
		if not state and searchBox then
			searchBox:ReleaseFocus()
		end
	end

	function el:Open()
		self:SetOpen(true)
	end

	function el:Close()
		self:SetOpen(false)
	end

	function el:Set(value, silent)
		for k in pairs(selected) do
			selected[k] = nil
		end
		if type(value) == "table" then
			for k, v in pairs(value) do
				if type(k) == "number" then
					selected[v] = true
				elseif v == true then
					selected[k] = true
				end
			end
		elseif value ~= nil then
			selected[value] = true
		end
		local valid = {}
		for _, option in ipairs(self.Options) do
			valid[option] = true
		end
		for k in pairs(selected) do
			if not valid[k] then
				selected[k] = nil
			end
		end
		if not self.Multi then
			local first
			for _, option in ipairs(self.Options) do
				if selected[option] then
					first = option
					break
				end
			end
			for k in pairs(selected) do
				selected[k] = nil
			end
			if first ~= nil then
				selected[first] = true
			end
		end
		display()
		if not silent then
			self:_fire(self.Value)
		end
	end

	function el:Refresh(options, keepSelection)
		for _, row in ipairs(rows) do
			row.Button:Destroy()
		end
		table.clear(rows)
		self.Options = options or {}
		for _, option in ipairs(self.Options) do
			makeRow(option)
		end
		if searchBox then
			searchBox.Text = ""
		end
		if keepSelection then
			self:Set(self.Value, true)
		else
			for k in pairs(selected) do
				selected[k] = nil
			end
			display()
		end
		updateSize()
	end

	function el:Add(option)
		table.insert(self.Options, option)
		makeRow(option)
		display()
		updateSize()
	end

	function el:Remove(option)
		for i, v in ipairs(self.Options) do
			if v == option then
				table.remove(self.Options, i)
				break
			end
		end
		for i, row in ipairs(rows) do
			if row.Option == option then
				row.Button:Destroy()
				table.remove(rows, i)
				break
			end
		end
		selected[option] = nil
		display()
		updateSize()
	end

	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local query = searchBox.Text:lower()
			for _, row in ipairs(rows) do
				row.Button.Visible = query == "" or tostring(row.Option):lower():find(query, 1, true) ~= nil
			end
			updateSize()
		end)
	end

	el.Header.MouseButton1Click:Connect(function()
		el:SetOpen(not el.Opened)
	end)

	el:Refresh(initialOptions)
	if opts.Default ~= nil or opts.Value ~= nil then
		el:Set(opts.Default ~= nil and opts.Default or opts.Value, true)
	end
	return Register(el, opts)
end

function Container:Input(opts, callback)
	opts = Opts(opts, callback)
	local width = opts.Width or 160
	local el = NewElement(self, opts, { Type = "Input", RightWidth = width + 28 })
	local _, box = Field(el.Header, UDim2.fromOffset(width, 28), UDim2.new(1, -14, 0.5, 0), {
		AnchorPoint = Vector2.new(1, 0.5),
		Placeholder = opts.Placeholder or "Type here...",
		Text = tostring(opts.Default or opts.Value or ""),
		ClearOnFocus = opts.ClearOnFocus,
	})
	el.Value = box.Text
	el.TextBox = box
	local setting = false

	box:GetPropertyChangedSignal("Text"):Connect(function()
		local text = box.Text
		if opts.Numeric then
			local filtered = text:gsub("[^%d%.%-]", "")
			if filtered ~= text then
				box.Text = filtered
				return
			end
		end
		if opts.MaxLength and #text > opts.MaxLength then
			box.Text = text:sub(1, opts.MaxLength)
			return
		end
		if opts.Finished == false and not setting then
			el.Value = text
			el:_fire(text)
		end
	end)

	box.FocusLost:Connect(function(enterPressed)
		if opts.Finished ~= false then
			el.Value = box.Text
			el:_fire(box.Text, enterPressed)
		end
	end)

	el.Header.MouseButton1Click:Connect(function()
		if not el.Locked then
			box:CaptureFocus()
		end
	end)

	function el:Set(value, silent)
		setting = true
		value = tostring(value or "")
		self.Value = value
		box.Text = value
		setting = false
		if not silent then
			self:_fire(value)
		end
	end

	return Register(el, opts)
end

function Container:Keybind(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "Keybind", RightWidth = 120 })
	el.Value = ParseKey(opts.Default or opts.Value)
	el.Mode = opts.Mode or "Toggle"
	el.State = false
	el.Binding = false
	el._onChange = opts.ChangedCallback or function() end

	local pill = Create("TextButton", {
		Name = "Key",
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = el.Header,
	})
	Corner(pill, 6)
	Bind(pill, { BackgroundColor3 = "Field" })
	Create("UISizeConstraint", { MinSize = Vector2.new(46, 26), Parent = pill })
	Pad(pill, 0, 0, 10, 10)
	local pillStroke = Stroke(pill)
	Bind(pillStroke, {
		Color = function(t)
			return el.Binding and t.Accent or t.Stroke
		end,
	})
	local keyLabel = Label({
		Text = KeyName(el.Value),
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		XAlign = Enum.TextXAlignment.Center,
		Font = Fonts.Medium,
		TextSize = 12,
		Color = function(t)
			return el.Binding and t.Accent or t.SubText
		end,
		Parent = pill,
	})

	local function refresh()
		keyLabel.Text = el.Binding and "..." or KeyName(el.Value)
		Restyle(pillStroke, 0.2)
		Restyle(keyLabel, 0.2)
		if el.Binding then
			Axivex._activeBind = el
		elseif Axivex._activeBind == el then
			Axivex._activeBind = nil
			Axivex._lastBind = os.clock()
		end
	end

	function el:_cancelBinding()
		self.Binding = false
		refresh()
	end

	local function startBinding()
		if el.Locked then
			return
		end
		local other = Axivex._activeBind
		if other and other ~= el then
			other:_cancelBinding()
		end
		el.Binding = true
		refresh()
	end

	function el:Set(key, silent)
		self.Value = ParseKey(key)
		self.Binding = false
		refresh()
		if not silent then
			self:_fire(self.Value)
		end
	end

	function el:GetState()
		return self.State
	end

	pill.MouseButton1Click:Connect(startBinding)
	el.Header.MouseButton1Click:Connect(startBinding)

	Connect(UserInputService.InputBegan, function(input)
		if el.Binding then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Escape then
					el.Binding = false
					refresh()
				elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
					el:Set(nil)
				else
					el:Set(input.KeyCode)
				end
			elseif
				input.UserInputType == Enum.UserInputType.MouseButton2
				or input.UserInputType == Enum.UserInputType.MouseButton3
			then
				el:Set(input.UserInputType)
			end
			return
		end
		if el.Locked or UserInputService:GetFocusedTextBox() then
			return
		end
		if KeyMatches(input, el.Value) then
			if el.Mode == "Toggle" then
				el.State = not el.State
				Spawn(el.Callback, el.State)
			elseif el.Mode == "Hold" then
				el.State = true
				Spawn(el.Callback, true)
			else
				Spawn(el.Callback, true)
			end
		end
	end)

	Connect(UserInputService.InputEnded, function(input)
		if el.Mode == "Hold" and el.State and KeyMatches(input, el.Value) then
			el.State = false
			Spawn(el.Callback, false)
		end
	end)

	return Register(el, opts)
end

local function RainbowSequence()
	local points = {}
	for i = 0, 6 do
		table.insert(points, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i / 6) % 1, 1, 1)))
	end
	return ColorSequence.new(points)
end

function Container:ColorPicker(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "ColorPicker", RightWidth = 70 })
	local color = opts.Default or opts.Value or Color3.fromRGB(255, 255, 255)
	local h, s, v = color:ToHSV()
	el.Value = color
	el.Opened = false

	local swatch = Create("Frame", {
		Name = "Swatch",
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(38, 22),
		BackgroundColor3 = color,
		Parent = el.Header,
	})
	Corner(swatch, 6)
	Stroke(swatch)

	local separator = Create("Frame", {
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -28, 0, 1),
		Parent = el.Body,
	})
	Bind(separator, { BackgroundColor3 = "Stroke" })

	local sv = Create("Frame", {
		Name = "SaturationValue",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 12),
		Size = UDim2.new(1, -62, 0, 120),
		BackgroundColor3 = Color3.fromHSV(h, 1, 1),
		Parent = el.Body,
	})
	Corner(sv, 6)
	local white = Create("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.fromScale(1, 1),
		Parent = sv,
	})
	Corner(white, 6)
	Create("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = white })
	local black = Create("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.fromScale(1, 1),
		Parent = sv,
	})
	Corner(black, 6)
	Create("UIGradient", { Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = black })
	local svCursor = Create("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(12, 12),
		ZIndex = 3,
		Parent = sv,
	})
	Round(svCursor)
	Create("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2, Parent = svCursor })
	local svHit = Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 4,
		Parent = sv,
	})

	local hue = Create("Frame", {
		Name = "Hue",
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 12),
		Size = UDim2.fromOffset(18, 120),
		Parent = el.Body,
	})
	Corner(hue, 6)
	Create("UIGradient", { Color = RainbowSequence(), Rotation = 90, Parent = hue })
	local hueCursor = Create("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 4, 0, 4),
		ZIndex = 2,
		Parent = hue,
	})
	Round(hueCursor)
	Create("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.6, Parent = hueCursor })
	local hueHit = Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 3,
		Parent = hue,
	})

	local _, hexBox = Field(el.Body, UDim2.fromOffset(96, 26), UDim2.fromOffset(14, 142), {
		Font = Fonts.Medium,
		XAlign = Enum.TextXAlignment.Center,
	})
	local _, rgbBox = Field(el.Body, UDim2.new(1, -124, 0, 26), UDim2.fromOffset(118, 142), {
		Font = Fonts.Medium,
		XAlign = Enum.TextXAlignment.Center,
	})

	local function render()
		local c = Color3.fromHSV(h, s, v)
		el.Value = c
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svCursor.Position = UDim2.fromScale(s, 1 - v)
		svCursor.BackgroundColor3 = c
		hueCursor.Position = UDim2.fromScale(0.5, h)
		Tween(swatch, { BackgroundColor3 = c }, 0.15)
		if not hexBox:IsFocused() then
			hexBox.Text = "#" .. c:ToHex():upper()
		end
		if not rgbBox:IsFocused() then
			rgbBox.Text = string.format(
				"%d, %d, %d",
				math.floor(c.R * 255 + 0.5),
				math.floor(c.G * 255 + 0.5),
				math.floor(c.B * 255 + 0.5)
			)
		end
	end

	function el:Set(newColor, silent)
		if typeof(newColor) ~= "Color3" then
			return
		end
		h, s, v = newColor:ToHSV()
		render()
		if not silent then
			self:_fire(self.Value)
		end
	end

	function el:SetOpen(state)
		self.Opened = state
		self._extra = state and 180 or 0
		self:_relayout(true)
	end

	TrackDrag(svHit, function(x, y)
		s, v = x, 1 - y
		render()
		el:_fire(el.Value)
	end)
	TrackDrag(hueHit, function(_, y)
		h = y
		render()
		el:_fire(el.Value)
	end)

	hexBox.FocusLost:Connect(function()
		local ok, parsed = pcall(Color3.fromHex, (hexBox.Text:gsub("#", "")))
		if ok and parsed then
			el:Set(parsed)
		else
			render()
		end
	end)
	rgbBox.FocusLost:Connect(function()
		local r, g, b = rgbBox.Text:match("(%d+)%D+(%d+)%D+(%d+)")
		if r then
			el:Set(Color3.fromRGB(math.clamp(tonumber(r), 0, 255), math.clamp(tonumber(g), 0, 255), math.clamp(tonumber(b), 0, 255)))
		else
			render()
		end
	end)

	el.Header.MouseButton1Click:Connect(function()
		if not el.Locked then
			el:SetOpen(not el.Opened)
		end
	end)

	render()
	return Register(el, opts)
end

function Container:Progress(opts)
	opts = Opts(opts)
	local el = NewElement(self, opts, { Type = "Progress", Height = { 38, 52 }, Fixed = 18, RightWidth = 100 })
	el.Max = opts.Max or 100
	el.Value = 0
	local display = opts.Display or "Percent"
	local completed = false

	local valueLabel = Label({
		Name = "Value",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(90, 16),
		XAlign = Enum.TextXAlignment.Right,
		Font = Fonts.SemiBold,
		TextSize = 13,
		Color = opts.Color or "Accent",
		Parent = el.Header,
	})

	local bar = Create("Frame", {
		Name = "Bar",
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(14, 2),
		Size = UDim2.new(1, -28, 0, 6),
		Parent = el.Body,
	})
	Round(bar)
	Bind(bar, { BackgroundColor3 = "Field" })
	local fill = Create("Frame", {
		Name = "Fill",
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		ClipsDescendants = true,
		Size = UDim2.fromScale(0, 1),
		Parent = bar,
	})
	Round(fill)
	if opts.Color then
		local gradient = Create("UIGradient", { Parent = fill })
		gradient.Color = ColorSequence.new(opts.Color:Lerp(Color3.new(0, 0, 0), 0.3), opts.Color)
	else
		AccentGradient(fill)
	end
	if opts.Shimmer ~= false then
		Shimmer(fill)
	end

	local function text()
		if type(display) == "function" then
			return display(el.Value, el.Max)
		elseif display == "Fraction" then
			return string.format("%s/%s", tostring(el.Value), tostring(el.Max))
		elseif display == "None" then
			return ""
		end
		local pct = el.Max > 0 and el.Value / el.Max * 100 or 0
		return string.format("%d%%", math.floor(pct + 0.5))
	end

	function el:Set(value)
		value = math.clamp(tonumber(value) or 0, 0, self.Max)
		self.Value = value
		local alpha = self.Max > 0 and value / self.Max or 0
		Tween(fill, { Size = UDim2.fromScale(alpha, 1) }, 0.5)
		valueLabel.Text = text()
		if alpha >= 1 and not completed then
			completed = true
			Spawn(opts.OnComplete)
		elseif alpha < 1 then
			completed = false
		end
		for _, fn in ipairs(self._listeners) do
			Spawn(fn, value, self.Max)
		end
	end

	function el:SetMax(max)
		self.Max = max
		self:Set(self.Value)
	end

	function el:Increment(amount)
		self:Set(self.Value + (amount or 1))
	end

	el:Set(opts.Default or opts.Value or 0)
	return Register(el, opts)
end

function Container:Stats(opts)
	opts = opts or {}
	local items = opts.Items or opts
	local count = math.max(#items, 1)

	local card = Create("Frame", {
		Name = "Stats",
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	Corner(card, 8)
	Stroke(card)
	Bind(card, { BackgroundColor3 = "Element" })
	Pad(card, 12, 12, 12, 12)
	List(card, 10)

	local el = Wrap(card, "Stats", self)
	el.Tiles = {}

	if opts.Title then
		el._titleLabel = Label({
			Text = opts.Title,
			Size = UDim2.new(1, 0, 0, 16),
			Font = Fonts.Medium,
			TextSize = 14,
			Parent = card,
		})
		Pad(el._titleLabel, 0, 0, 2, 0)
	end

	local row = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 58),
		LayoutOrder = 1,
		Parent = card,
	})
	List(row, 8, Enum.FillDirection.Horizontal)

	local function format(tile, value)
		if tile.Format then
			return tile.Format(value)
		end
		return (tile.Prefix or "") .. tostring(value) .. (tile.Suffix or "")
	end

	for i, item in ipairs(items) do
		local tile = Create("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1 / count, -math.ceil(8 * (count - 1) / count), 1, 0),
			LayoutOrder = i,
			Parent = row,
		})
		Corner(tile, 8)
		Bind(tile, { BackgroundColor3 = "Field" })
		Pad(tile, 10, 10, 12, 12)
		Label({
			Text = tostring(item.Title or item.Name or ""):upper(),
			Size = UDim2.new(1, 0, 0, 12),
			Font = Fonts.SemiBold,
			TextSize = 10,
			Color = "Muted",
			Truncate = Enum.TextTruncate.AtEnd,
			Parent = tile,
		})
		local valueLabel = Label({
			Position = UDim2.fromOffset(0, 16),
			Size = UDim2.new(1, 0, 0, 22),
			Font = Fonts.Bold,
			TextSize = 20,
			Truncate = Enum.TextTruncate.AtEnd,
			Color = item.Color or "Text",
			Parent = tile,
		})
		local data = {
			Label = valueLabel,
			Raw = item.Value,
			Prefix = item.Prefix,
			Suffix = item.Suffix,
			Format = item.Format,
		}
		valueLabel.Text = format(data, item.Value or "-")
		el.Tiles[item.Title or item.Name or i] = data
		el.Tiles[i] = data
	end

	function el:Set(key, value)
		local tile = self.Tiles[key]
		if not tile then
			return
		end
		local old, new = tonumber(tile.Raw), tonumber(value)
		tile.Raw = value
		if tile.Anim then
			tile.Anim.Tween:Cancel()
			tile.Anim.Conn:Disconnect()
			tile.Anim.Value:Destroy()
			tile.Anim = nil
		end
		if old and new and old ~= new and not tile.Format then
			local places = math.max(Decimals(old), Decimals(new))
			local number = Instance.new("NumberValue")
			number.Value = old
			local conn = number.Changed:Connect(function(x)
				tile.Label.Text = format(tile, string.format("%." .. places .. "f", x))
			end)
			local tween = Tween(number, { Value = new }, 0.6)
			tile.Anim = { Tween = tween, Conn = conn, Value = number }
			tween.Completed:Connect(function(state)
				if state == Enum.PlaybackState.Completed and tile.Anim and tile.Anim.Tween == tween then
					conn:Disconnect()
					number:Destroy()
					tile.Anim = nil
					tile.Label.Text = format(tile, value)
				end
			end)
		else
			tile.Label.Text = format(tile, value)
		end
	end

	function el:Get(key)
		local tile = self.Tiles[key]
		return tile and tile.Raw
	end

	return el
end

function Container:Stat(opts)
	opts = opts or {}
	local stats = self:Stats({ { Title = opts.Title, Value = opts.Value, Prefix = opts.Prefix, Suffix = opts.Suffix, Color = opts.Color, Format = opts.Format } })
	local single = setmetatable({}, { __index = stats })
	function single:Set(value)
		stats:Set(1, value)
	end
	function single:Get()
		return stats:Get(1)
	end
	return single
end

function Container:Label(opts)
	if type(opts) ~= "table" then
		opts = { Text = tostring(opts) }
	end
	local label = Label({
		Name = "TextLabel",
		Text = opts.Text or "",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		RichText = true,
		TextSize = opts.TextSize or 13,
		Font = opts.Bold and Fonts.SemiBold or Fonts.Regular,
		XAlign = opts.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
		Color = opts.Color or "SubText",
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	Pad(label, 2, 2, 4, 4)
	local el = Wrap(label, "Label", self)
	function el:Set(text)
		label.Text = tostring(text)
	end
	return el
end

function Container:Paragraph(opts)
	if type(opts) ~= "table" then
		opts = { Content = tostring(opts) }
	end
	local card = Create("Frame", {
		Name = "Paragraph",
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	Corner(card, 8)
	Stroke(card)
	Bind(card, { BackgroundColor3 = "Element" })
	Pad(card, 12, 12, 14, 14)
	List(card, 4)
	local el = Wrap(card, "Paragraph", self)
	el._titleLabel = Label({
		Text = opts.Title or "",
		Size = UDim2.new(1, 0, 0, 18),
		Font = Fonts.Medium,
		TextSize = 14,
		Visible = opts.Title ~= nil,
		LayoutOrder = 1,
		Parent = card,
	})
	local content = Label({
		Text = opts.Content or opts.Text or "",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		RichText = true,
		TextSize = 13,
		Color = "SubText",
		LayoutOrder = 2,
		Parent = card,
	})
	function el:SetContent(text)
		content.Text = tostring(text)
	end
	el.Set = el.SetContent
	function el:SetTitle(text)
		self._titleLabel.Text = text
		self._titleLabel.Visible = text ~= nil
	end
	return el
end

function Container:Divider(text)
	if type(text) == "table" then
		text = text.Text or text.Title
	end
	local frame = Create("Frame", {
		Name = "Divider",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, text and 20 or 9),
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	local function line(anchorX, scaleX)
		local l = Create("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(anchorX, 0.5),
			Position = UDim2.fromScale(scaleX, 0.5),
			Size = UDim2.new(1, 0, 0, 1),
			Parent = frame,
		})
		Bind(l, { BackgroundColor3 = "Stroke" })
		return l
	end
	local left = line(0, 0)
	if text then
		local right = line(1, 1)
		local label = Label({
			Text = tostring(text):upper(),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = Fonts.SemiBold,
			TextSize = 10,
			Color = "Muted",
			Parent = frame,
		})
		local function fit()
			local gap = label.AbsoluteSize.X / 2 + 10
			left.Size = UDim2.new(0.5, -gap, 0, 1)
			right.Size = UDim2.new(0.5, -gap, 0, 1)
		end
		label:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
		fit()
	end
	return Wrap(frame, "Divider", self)
end

function Container:Space(height)
	local frame = Create("Frame", {
		Name = "Space",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, height or 8),
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	return Wrap(frame, "Space", self)
end

function Container:Tags(opts)
	opts = opts or {}
	local initial = opts.Tags or opts
	local frame = Create("Frame", {
		Name = "Tags",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	local layout = List(frame, 6, Enum.FillDirection.Horizontal)
	pcall(function()
		layout.Wraps = true
	end)
	local el = Wrap(frame, "Tags", self)
	el.Items = {}
	local order = 0

	function el:Add(tag, instant)
		order = order + 1
		local pill = TagPill(frame, tag, true, order)
		local text = type(tag) == "table" and tag.Text or tostring(tag)
		table.insert(self.Items, { Text = text, Pill = pill })
		if not instant then
			local scale = Create("UIScale", { Scale = 0.6, Parent = pill })
			Tween(scale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
		end
		return pill
	end

	function el:Remove(text)
		for i, item in ipairs(self.Items) do
			if item.Text == text then
				table.remove(self.Items, i)
				local scale = Create("UIScale", { Parent = item.Pill })
				Tween(scale, { Scale = 0 }, 0.2)
				task.delay(0.2, function()
					item.Pill:Destroy()
				end)
				return
			end
		end
	end

	function el:Clear()
		for _, item in ipairs(self.Items) do
			item.Pill:Destroy()
		end
		table.clear(self.Items)
	end

	for _, tag in ipairs(initial) do
		el:Add(tag, true)
	end
	return el
end

local LogKinds = {
	Log = "SubText",
	Info = "Accent",
	Success = "Success",
	Warn = "Warning",
	Warning = "Warning",
	Error = "Error",
	Debug = "Muted",
}

local function SmallButton(parent, text, xOffset)
	local hover = false
	local button = Create("TextButton", {
		Text = text,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, xOffset, 0.5, 0),
		Size = UDim2.fromOffset(0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = Fonts.Medium,
		TextSize = 12,
		Parent = parent,
	})
	Corner(button, 6)
	Pad(button, 0, 0, 10, 10)
	Stroke(button)
	Bind(button, {
		BackgroundColor3 = function(t)
			return hover and t.ElementHover or t.Field
		end,
		TextColor3 = function(t)
			return hover and t.Text or t.SubText
		end,
	})
	button.MouseEnter:Connect(function()
		hover = true
		Restyle(button, 0.15)
	end)
	button.MouseLeave:Connect(function()
		hover = false
		Restyle(button, 0.15)
	end)
	return button
end

function Container:Console(opts)
	opts = opts or {}
	local height = opts.Height or 200
	local card = Create("Frame", {
		Name = "Console",
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 52 + height),
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	Corner(card, 8)
	Stroke(card)
	Bind(card, { BackgroundColor3 = "Element" })

	local el = Wrap(card, "Console", self)
	el.Lines = {}
	el.MaxLines = opts.MaxLines or 200
	el.Prefix = opts.Prefix
	el.Timestamps = opts.Timestamps ~= false

	local header = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 42),
		Parent = card,
	})
	el._titleLabel = Label({
		Text = opts.Title or "Console",
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -180, 1, 0),
		Font = Fonts.Medium,
		TextSize = 14,
		Parent = header,
	})
	local clearButton = SmallButton(header, "Clear", -12)
	local copyButton = SmallButton(header, "Copy", -74)

	local scroller = Create("ScrollingFrame", {
		Name = "Output",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(10, 42),
		Size = UDim2.new(1, -20, 0, height),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = card,
	})
	Corner(scroller, 6)
	Stroke(scroller)
	Bind(scroller, { BackgroundColor3 = "Field", ScrollBarImageColor3 = "Stroke" })
	Pad(scroller, 8, 8, 8, 8)
	List(scroller, 4)

	local empty = Label({
		Text = opts.Placeholder or "Nothing logged yet.",
		Size = UDim2.new(1, 0, 0, height - 16),
		XAlign = Enum.TextXAlignment.Center,
		TextSize = 12,
		Color = "Muted",
		Parent = scroller,
	})

	local order = 0
	function el:Log(text, kind)
		kind = kind or "Log"
		local theme = Axivex.Theme
		local colorKey = LogKinds[kind] or "SubText"
		local parts = {}
		if self.Timestamps then
			table.insert(parts, Rich.Color(os.date("%H:%M:%S"), theme.Muted))
		end
		table.insert(parts, Rich.Color(self.Prefix or ("[" .. kind:lower() .. "]"), theme[colorKey]))
		table.insert(parts, Rich.Color(tostring(text), theme.Text))
		local line = table.concat(parts, " ")

		empty.Visible = false
		local atBottom = scroller.CanvasPosition.Y
			>= scroller.AbsoluteCanvasSize.Y - scroller.AbsoluteWindowSize.Y - 24

		order = order + 1
		local plain = Rich.Strip(line)
		local hover, copied = false, false
		local chip = Create("TextButton", {
			Name = "Line",
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = order,
			Parent = scroller,
		})
		Corner(chip, 5)
		Bind(chip, {
			BackgroundColor3 = function(t)
				return hover and t.ElementHover or t.Element
			end,
		})
		local chipStroke = Stroke(chip)
		Bind(chipStroke, {
			Color = function(t)
				return copied and t.Accent or t.Stroke
			end,
		})
		chipStroke.Transparency = 1
		chip.MouseEnter:Connect(function()
			hover = true
			Restyle(chip, 0.15)
		end)
		chip.MouseLeave:Connect(function()
			hover = false
			Restyle(chip, 0.15)
		end)
		chip.MouseButton1Click:Connect(function()
			if type(setclipboard) ~= "function" then
				Axivex:Toast({ Text = "Clipboard isn't available here", Type = "Error" })
				return
			end
			pcall(setclipboard, plain)
			copied = true
			Restyle(chipStroke, 0.15)
			Axivex:Toast({ Text = "Copied to clipboard", Type = "Success" })
			task.delay(0.8, function()
				copied = false
				Restyle(chipStroke, 0.4)
			end)
		end)
		Pad(chip, 5, 5, 9, 9)
		local label = Label({
			Text = line,
			RichText = true,
			Wrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 12,
			Font = Fonts.Medium,
			Parent = chip,
		})
		label.TextTransparency = 1
		Tween(chip, { BackgroundTransparency = 0 }, 0.3)
		Tween(chipStroke, { Transparency = 0 }, 0.3)
		Tween(label, { TextTransparency = 0 }, 0.3)

		table.insert(self.Lines, { Text = plain, Frame = chip })
		while #self.Lines > self.MaxLines do
			local old = table.remove(self.Lines, 1)
			old.Frame:Destroy()
		end

		if atBottom then
			task.delay(0.05, function()
				local target = math.max(0, scroller.AbsoluteCanvasSize.Y - scroller.AbsoluteWindowSize.Y)
				Tween(scroller, { CanvasPosition = Vector2.new(0, target) }, 0.3)
			end)
		end
		return chip
	end

	function el:Info(text)
		return self:Log(text, "Info")
	end
	function el:Success(text)
		return self:Log(text, "Success")
	end
	function el:Warn(text)
		return self:Log(text, "Warn")
	end
	function el:Error(text)
		return self:Log(text, "Error")
	end
	function el:Debug(text)
		return self:Log(text, "Debug")
	end
	function el:Print(...)
		local args = table.pack(...)
		for i = 1, args.n do
			args[i] = tostring(args[i])
		end
		return self:Log(table.concat(args, " "), "Log")
	end

	function el:Clear()
		for _, line in ipairs(self.Lines) do
			line.Frame:Destroy()
		end
		table.clear(self.Lines)
		empty.Visible = true
	end

	function el:GetText()
		local out = {}
		for i, line in ipairs(self.Lines) do
			out[i] = line.Text
		end
		return table.concat(out, "\n")
	end

	clearButton.MouseButton1Click:Connect(function()
		el:Clear()
	end)
	copyButton.MouseButton1Click:Connect(function()
		if type(setclipboard) == "function" then
			pcall(setclipboard, el:GetText())
			Axivex:Toast({ Text = "Console copied", Type = "Success" })
		else
			Axivex:Toast({ Text = "Clipboard isn't available here", Type = "Error" })
		end
	end)

	return el
end

do
	local names = {}
	for name in pairs(Container) do
		if name ~= "SetTitle" and name ~= "SetVisible" then
			table.insert(names, name)
		end
	end
	for _, name in ipairs(names) do
		Container["Add" .. name] = Container[name]
		Container["Create" .. name] = Container[name]
	end
end

local NotifyGui, NotifyHolder, ToastHolder
local ActiveNotifications = {}
local NotifyOrder = 0

local TypeKeys = { Info = "Accent", Success = "Success", Warning = "Warning", Error = "Error" }

local function EnsureNotifyGui()
	if NotifyGui and NotifyGui.Parent then
		return
	end
	NotifyGui = Create("ScreenGui", {
		Name = "AxivexNotifications",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = false,
		DisplayOrder = 1000,
	})
	ParentGui(NotifyGui)
	NotifyHolder = Create("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -18, 1, -8),
		Size = UDim2.new(0, 270, 1, -26),
		Parent = NotifyGui,
	})
	List(NotifyHolder, 0, nil, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
	ToastHolder = Create("Frame", {
		Name = "Toasts",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 12),
		Size = UDim2.new(0, 600, 1, -24),
		Parent = NotifyGui,
	})
	List(ToastHolder, 0, nil, Enum.HorizontalAlignment.Center)
end

local function TypeGradient(typeKey, customColor)
	return function(t)
		if customColor then
			return ColorSequence.new(customColor:Lerp(Color3.new(0, 0, 0), 0.3), customColor)
		end
		if typeKey == "Accent" then
			return ColorSequence.new(t.AccentDark, t.Accent)
		end
		return ColorSequence.new(t[typeKey]:Lerp(Color3.new(0, 0, 0), 0.3), t[typeKey])
	end
end

function Axivex:Notify(opts, content, duration)
	if type(opts) ~= "table" then
		opts = { Title = tostring(opts), Content = content, Duration = duration }
	end
	EnsureNotifyGui()

	local typeKey = TypeKeys[opts.Type or "Info"] or "Accent"
	local color = function(t)
		return opts.Color or t[typeKey]
	end
	local n = { Closed = false }
	NotifyOrder = NotifyOrder + 1

	local holder = Create("Frame", {
		Name = "Notification",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = NotifyOrder,
		Parent = NotifyHolder,
	})
	local canvas = Create("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Position = UDim2.fromOffset(40, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = holder,
	})
	Pad(canvas, 1, 1, 1, 1)
	local body = Create("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = canvas,
	})
	Bind(body, { BackgroundColor3 = "Background" })
	Corner(body, 10)
	Stroke(body)
	Pad(body, 10, 12, 12, 12)
	List(body, 4)

	local closable = opts.Closable ~= false and opts.Dismissable ~= false
	local closeWidth = closable and 24 or 0

	local top = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 14),
		LayoutOrder = 1,
		Visible = opts.Label ~= nil or opts.Status ~= nil,
		Parent = body,
	})
	local dot = Create("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(6, 6),
		Parent = top,
	})
	Round(dot)
	Bind(dot, { BackgroundColor3 = color })
	TweenService:Create(
		dot,
		TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{ BackgroundTransparency = 0.6 }
	):Play()
	local labelText = Label({
		Text = tostring(opts.Label or ""):upper(),
		Position = UDim2.fromOffset(13, 0),
		Size = UDim2.new(1, -110, 1, 0),
		Font = Fonts.Bold,
		TextSize = 10,
		Truncate = Enum.TextTruncate.AtEnd,
		Color = "SubText",
		Parent = top,
	})
	local statusText = Label({
		Text = tostring(opts.Status or ""):upper(),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -closeWidth, 0, 0),
		Size = UDim2.new(0, 96, 1, 0),
		XAlign = Enum.TextXAlignment.Right,
		Font = Fonts.Bold,
		TextSize = 10,
		Color = color,
		Parent = top,
	})

	local titleRow = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		LayoutOrder = 2,
		Parent = body,
	})
	local iconImage = ResolveIcon(opts.Icon)
	local iconWidth = iconImage and 22 or 0
	if iconImage then
		local icon = Create("ImageLabel", {
			Name = "Icon",
			BackgroundTransparency = 1,
			Image = iconImage,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromOffset(16, 16),
			Parent = titleRow,
		})
		Bind(icon, { ImageColor3 = "SubText" })
	end
	local titleText = Label({
		Text = opts.Title or "Notification",
		Position = UDim2.fromOffset(iconWidth, 0),
		Size = UDim2.new(1, -(closeWidth + 64 + iconWidth), 1, 0),
		Font = Fonts.SemiBold,
		TextSize = 14,
		Truncate = Enum.TextTruncate.AtEnd,
		Parent = titleRow,
	})
	local counter = Label({
		Text = "",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -closeWidth, 0, 0),
		Size = UDim2.new(0, 64, 1, 0),
		XAlign = Enum.TextXAlignment.Right,
		Font = Fonts.SemiBold,
		TextSize = 12,
		Color = color,
		Parent = titleRow,
	})
	local function layoutTitleRow()
		local reserve = (closable and not top.Visible) and closeWidth or 0
		counter.Position = UDim2.new(1, -reserve, 0, 0)
		titleText.Size = UDim2.new(1, -(reserve + 64 + iconWidth), 1, 0)
	end
	layoutTitleRow()

	local closeButton
	if closable then
		local hover = false
		closeButton = Create("TextButton", {
			Name = "Close",
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -9, 0, 9),
			Size = UDim2.fromOffset(20, 20),
			ZIndex = 2,
			Parent = canvas,
		})
		Corner(closeButton, 5)
		Bind(closeButton, {
			BackgroundColor3 = "Element",
			BackgroundTransparency = function()
				return hover and 0 or 1
			end,
		})
		local bars = {}
		for i, rotation in ipairs({ 45, -45 }) do
			local bar = Create("Frame", {
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(10, 2),
				Rotation = rotation,
				Parent = closeButton,
			})
			Round(bar)
			Bind(bar, {
				BackgroundColor3 = function(t)
					return hover and t.Text or t.Muted
				end,
			})
			bars[i] = bar
		end
		local function restyle()
			Restyle(closeButton, 0.15)
			for _, bar in ipairs(bars) do
				Restyle(bar, 0.15)
			end
		end
		closeButton.MouseEnter:Connect(function()
			hover = true
			restyle()
		end)
		closeButton.MouseLeave:Connect(function()
			hover = false
			restyle()
		end)
	end

	local contentText = Label({
		Text = opts.Content or opts.Text or "",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		RichText = true,
		TextSize = 12,
		Color = "SubText",
		Visible = (opts.Content or opts.Text) ~= nil,
		LayoutOrder = 3,
		Parent = body,
	})

	local barWrap = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 13),
		LayoutOrder = 4,
		Visible = false,
		Parent = body,
	})
	local bar = Create("Frame", {
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(0, 4),
		Size = UDim2.new(1, 0, 0, 5),
		Parent = barWrap,
	})
	Round(bar)
	Bind(bar, { BackgroundColor3 = "Field" })
	local fill = Create("Frame", {
		BorderSizePixel = 0,
		ClipsDescendants = true,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.fromScale(0, 1),
		Parent = bar,
	})
	Round(fill)
	local fillGradient = Create("UIGradient", { Parent = fill })
	Bind(fillGradient, { Color = TypeGradient(typeKey, opts.Color) })
	Shimmer(fill)

	local footer = Label({
		Text = opts.Footer or "",
		Size = UDim2.new(1, 0, 0, 15),
		TextSize = 11,
		Color = "Muted",
		Truncate = Enum.TextTruncate.AtEnd,
		Visible = opts.Footer ~= nil,
		LayoutOrder = 5,
		Parent = body,
	})

	local timer = Create("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 3),
		LayoutOrder = 6,
		Visible = false,
		Parent = body,
	})
	Round(timer)
	Bind(timer, { BackgroundColor3 = "Field" })
	local timerFill = Create("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.fromScale(1, 1),
		Parent = timer,
	})
	Round(timerFill)
	local timerGradient = Create("UIGradient", { Parent = timerFill })
	Bind(timerGradient, { Color = TypeGradient(typeKey, opts.Color) })

	local function fit()
		if n.Closed then
			return
		end
		Tween(holder, { Size = UDim2.new(1, 0, 0, canvas.AbsoluteSize.Y + 6) }, 0.35)
	end
	canvas:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)

	function n:Close()
		if self.Closed then
			return
		end
		self.Closed = true
		for i, other in ipairs(ActiveNotifications) do
			if other == self then
				table.remove(ActiveNotifications, i)
				break
			end
		end
		Tween(canvas, { Position = UDim2.fromOffset(40, 0), GroupTransparency = 1 }, 0.3)
		task.delay(0.15, function()
			Tween(holder, { Size = UDim2.new(1, 0, 0, 0) }, 0.35)
		end)
		task.delay(0.55, function()
			holder:Destroy()
		end)
		Spawn(opts.OnClose)
	end

	function n:SetProgress(value, max)
		max = max or self.Max or 100
		self.Max = max
		self.Value = value
		barWrap.Visible = true
		timer.Visible = false
		local alpha = max > 0 and math.clamp(value / max, 0, 1) or 0
		Tween(fill, { Size = UDim2.fromScale(alpha, 1) }, 0.5)
		counter.Text = string.format("%s/%s", tostring(value), tostring(max))
	end

	local timerToken = 0
	function n:SetDuration(seconds)
		timerToken = timerToken + 1
		local token = timerToken
		if not seconds or seconds <= 0 then
			timer.Visible = false
			return
		end
		if not barWrap.Visible then
			timer.Visible = true
			timerFill.Size = UDim2.fromScale(1, 1)
			Tween(timerFill, { Size = UDim2.fromScale(0, 1) }, seconds, Enum.EasingStyle.Linear)
		end
		task.delay(seconds, function()
			if token == timerToken then
				self:Close()
			end
		end)
	end

	function n:Set(update)
		if update.Title then
			titleText.Text = update.Title
		end
		if update.Content or update.Text then
			contentText.Text = update.Content or update.Text
			contentText.Visible = true
		end
		if update.Label then
			labelText.Text = tostring(update.Label):upper()
			top.Visible = true
		end
		if update.Status then
			statusText.Text = tostring(update.Status):upper()
			top.Visible = true
		end
		layoutTitleRow()
		if update.Footer then
			footer.Text = update.Footer
			footer.Visible = true
		end
		if update.Progress then
			self:SetProgress(update.Progress[1] or update.Progress.Value, update.Progress[2] or update.Progress.Max)
		end
		if update.Duration ~= nil then
			self:SetDuration(update.Duration)
		end
	end

	if closeButton then
		closeButton.MouseButton1Click:Connect(function()
			n:Close()
		end)
	end

	if opts.Progress then
		n:SetProgress(opts.Progress[1] or opts.Progress.Value or 0, opts.Progress[2] or opts.Progress.Max or 100)
	end

	local lifetime = opts.Duration
	if lifetime == nil then
		lifetime = opts.Progress and 0 or 5
	end
	n:SetDuration(lifetime or 0)

	table.insert(ActiveNotifications, n)
	while #ActiveNotifications > (Axivex.MaxNotifications or 5) do
		ActiveNotifications[1]:Close()
	end

	task.delay(0.03, function()
		fit()
		Tween(canvas, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 }, 0.5)
	end)
	return n
end

function Axivex:Toast(opts, toastType)
	if type(opts) ~= "table" then
		opts = { Text = tostring(opts), Type = toastType }
	end
	EnsureNotifyGui()
	NotifyOrder = NotifyOrder + 1
	local duration = opts.Duration or 2.5
	local typeKey = (opts.Type and TypeKeys[opts.Type]) or "Accent"
	local content = opts.Content or opts.Desc
	local height = content and 52 or 40

	local holder = Create("Frame", {
		Name = "Toast",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = NotifyOrder,
		Parent = ToastHolder,
	})
	local canvas = Create("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, -14),
		Size = UDim2.fromOffset(0, height + 2),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = holder,
	})
	Pad(canvas, 1, 1, 1, 1)
	local scale = Create("UIScale", { Scale = 0.92, Parent = canvas })
	local body = Create("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(0, height),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = canvas,
	})
	Bind(body, { BackgroundColor3 = "Background" })
	Corner(body, 10)
	Stroke(body)
	Pad(body, 0, 0, 0, 18)

	local accent = Create("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.fromOffset(3, height - 18),
		Parent = body,
	})
	Round(accent)
	local accentGradient = Create("UIGradient", { Rotation = 90, Parent = accent })
	Bind(accentGradient, { Color = TypeGradient(typeKey, opts.Color) })

	local textX = 24
	local iconImage = ResolveIcon(opts.Icon)
	if iconImage then
		local icon = Create("ImageLabel", {
			Name = "Icon",
			BackgroundTransparency = 1,
			Image = iconImage,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 24, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			Parent = body,
		})
		Bind(icon, {
			ImageColor3 = function(t)
				return opts.Color or t[typeKey]
			end,
		})
		textX = 48
	end

	local textArea = Create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(textX, 0),
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = body,
	})
	List(textArea, 1, nil, nil, Enum.VerticalAlignment.Center)
	Label({
		Text = opts.Text or opts.Title or "",
		Size = UDim2.fromOffset(0, 17),
		AutomaticSize = Enum.AutomaticSize.X,
		Font = Fonts.SemiBold,
		TextSize = 13,
		LayoutOrder = 1,
		Parent = textArea,
	})
	if content then
		Label({
			Text = content,
			Size = UDim2.fromOffset(0, 15),
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 12,
			Color = "SubText",
			LayoutOrder = 2,
			Parent = textArea,
		})
	end

	local timer = Create("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.35,
		Position = UDim2.new(0, 24, 1, -5),
		Size = UDim2.fromOffset(0, 2),
		Parent = body,
	})
	Round(timer)
	local timerGradient = Create("UIGradient", { Parent = timer })
	Bind(timerGradient, { Color = TypeGradient(typeKey, opts.Color) })
	task.defer(function()
		local width = math.max(body.AbsoluteSize.X - 24 - 18, 0)
		timer.Size = UDim2.fromOffset(width, 2)
		Tween(timer, { Size = UDim2.fromOffset(0, 2) }, duration, Enum.EasingStyle.Linear)
	end)

	Tween(holder, { Size = UDim2.new(1, 0, 0, height + 8) }, 0.35)
	Tween(canvas, { Position = UDim2.new(0.5, 0, 0, 0), GroupTransparency = 0 }, 0.45)
	Tween(scale, { Scale = 1 }, 0.45, Enum.EasingStyle.Back)

	local toast = { Closed = false }
	function toast:Close()
		if self.Closed then
			return
		end
		self.Closed = true
		Tween(canvas, { Position = UDim2.new(0.5, 0, 0, -14), GroupTransparency = 1 }, 0.3)
		Tween(scale, { Scale = 0.92 }, 0.3)
		task.delay(0.15, function()
			Tween(holder, { Size = UDim2.new(1, 0, 0, 0) }, 0.3)
		end)
		task.delay(0.5, function()
			holder:Destroy()
		end)
	end
	task.delay(duration, function()
		toast:Close()
	end)
	return toast
end

local Window = {}
Window.__index = Window

local Tab = {}
local TabMeta = {
	__index = function(_, key)
		return Tab[key] or Container[key]
	end,
}

local Page = {}
local PageMeta = {
	__index = function(_, key)
		return Page[key] or Container[key]
	end,
}

local TAB_LIST_TOP = 4

local function SafeName(name)
	return (tostring(name):gsub("[^%w%-_ ]", ""))
end

local function Badge(parent, title, icon, size, position, anchor)
	local image = ResolveIcon(icon)
	if image then
		local logo = Create("ImageLabel", {
			Name = "Logo",
			BackgroundTransparency = 1,
			Image = image,
			AnchorPoint = anchor or Vector2.zero,
			Position = position,
			Size = UDim2.fromOffset(size, size),
			Parent = parent,
		})
		Bind(logo, { ImageColor3 = "Accent" })
		return logo
	end
	local logo = Create("Frame", {
		Name = "Logo",
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		AnchorPoint = anchor or Vector2.zero,
		Position = position,
		Size = UDim2.fromOffset(size, size),
		Parent = parent,
	})
	Corner(logo, math.floor(size * 0.27))
	AccentGradient(logo, 45)
	Label({
		Text = tostring(title):sub(1, 1):upper(),
		XAlign = Enum.TextXAlignment.Center,
		Font = Fonts.Bold,
		TextSize = math.floor(size * 0.5),
		Color = "OnAccent",
		Parent = logo,
	})
	return logo
end

local SHADOW_TRANSPARENCY = 0.7

local SHADOW_LAYERS = 6

local function WindowShadow(parent)
	local holder = Create("Frame", {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 0,
		Parent = parent,
	})
	local edgeOpacity = (1 - SHADOW_TRANSPARENCY) * 0.35
	local layerTransparency = (1 - edgeOpacity) ^ (1 / SHADOW_LAYERS)
	local layers = {}
	for i = 1, SHADOW_LAYERS do
		local spread = i * 3
		local layer = Create("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 2),
			Size = UDim2.new(1, spread * 2, 1, spread * 2),
			Parent = holder,
		})
		Corner(layer, 12 + spread)
		Bind(layer, { BackgroundColor3 = "Shadow" })
		layers[i] = layer
	end
	return {
		Fade = function(_, visible, duration)
			for _, layer in ipairs(layers) do
				Tween(layer, { BackgroundTransparency = visible and layerTransparency or 1 }, duration)
			end
		end,
	}
end

local function CreateLoader(window, opts)
	local loader = { Progress = 0, Finished = false }
	local steps = opts.Steps or { "Preparing interface", "Loading elements", "Applying theme", "Almost ready" }

	local root = Create("Frame", {
		Name = "Loader",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(opts.Width or 300, 100),
		Parent = window.Gui,
	})
	local scale = Create("UIScale", { Scale = 0.94, Parent = root })
	local shadow = WindowShadow(root)
	local canvas = Create("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = root,
	})
	Pad(canvas, 1, 1, 1, 1)
	local card = Create("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = canvas,
	})
	Corner(card, 12)
	Stroke(card)
	Bind(card, { BackgroundColor3 = "Background" })

	Badge(card, window.Title, opts.Icon or window.Icon, 34, UDim2.fromOffset(18, 18))
	Label({
		Text = opts.Title or window.Title,
		Position = UDim2.fromOffset(64, 18),
		Size = UDim2.new(1, -82, 0, 20),
		Font = Fonts.Bold,
		TextSize = 17,
		Truncate = Enum.TextTruncate.AtEnd,
		Parent = card,
	})
	local status = Label({
		Text = opts.Subtitle or steps[1] or "Preparing interface",
		Position = UDim2.fromOffset(64, 39),
		Size = UDim2.new(1, -82, 0, 15),
		TextSize = 12,
		Truncate = Enum.TextTruncate.AtEnd,
		Color = "SubText",
		Parent = card,
	})
	local bar = Create("Frame", {
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(18, 74),
		Size = UDim2.new(1, -36, 0, 5),
		Parent = card,
	})
	Round(bar)
	Bind(bar, { BackgroundColor3 = "Field" })
	local fill = Create("Frame", {
		BorderSizePixel = 0,
		ClipsDescendants = true,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.fromScale(0, 1),
		Parent = bar,
	})
	Round(fill)
	AccentGradient(fill)
	Shimmer(fill)

	function loader:Set(progress, text)
		self.Progress = math.clamp(tonumber(progress) or 0, 0, 1)
		Tween(fill, { Size = UDim2.fromScale(self.Progress, 1) }, 0.45)
		if text then
			status.Text = text
		end
	end

	function loader:Finish()
		if self.Finished then
			return
		end
		self.Finished = true
		self:Set(1)
		task.delay(0.5, function()
			Tween(canvas, { GroupTransparency = 1 }, 0.3)
			Tween(scale, { Scale = 0.96 }, 0.3)
			shadow:Fade(false, 0.3)
			task.delay(0.2, function()
				window._loading = false
				window:SetVisible(true)
			end)
			task.delay(0.4, function()
				root:Destroy()
			end)
		end)
	end

	window._loading = true
	Tween(canvas, { GroupTransparency = 0 }, 0.35)
	Tween(scale, { Scale = 1 }, 0.45)
	shadow:Fade(true, 0.35)

	if not opts.Manual then
		local duration = opts.Duration or 1.6
		task.spawn(function()
			task.wait(0.3)
			for i, text in ipairs(steps) do
				loader:Set(i / (#steps + 1), text)
				task.wait(duration / #steps)
			end
			loader:Finish()
		end)
	end
	return loader
end

local function IconBar(parent, size, rotation, colorFn)
	local bar = Create("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = size,
		Rotation = rotation or 0,
		Parent = parent,
	})
	Round(bar)
	Bind(bar, { BackgroundColor3 = colorFn })
	return bar
end

function Axivex:CreateWindow(opts)
	opts = opts or {}
	if opts.Theme then
		self:SetTheme(opts.Theme)
	end

	local size = opts.Size or UDim2.fromOffset(640, 440)
	local window = setmetatable({
		Title = opts.Title or "Axivex",
		Subtitle = opts.Subtitle or ("v" .. Axivex.Version),
		Icon = opts.Icon,
		Tabs = {},
		Visible = false,
		ToggleKey = opts.ToggleKey or Enum.KeyCode.RightShift,
		AutoSave = opts.AutoSave,
		MinSize = opts.MinSize or Vector2.new(520, 340),
		_switch = 0,
	}, Window)
	window._configDir = Axivex.Folder .. "/" .. SafeName(opts.ConfigFolder or window.Title) .. "/configs"

	local gui = Create("ScreenGui", {
		Name = "Axivex",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = false,
		DisplayOrder = 100,
	})
	ParentGui(gui)

	local root = Create("Frame", {
		Name = "Root",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = size,
		Visible = false,
		Parent = gui,
	})
	local rootScale = Create("UIScale", { Scale = 0.94, Parent = root })
	local shadow = WindowShadow(root)

	local outline = Create("Frame", {
		Name = "Outline",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = root,
	})
	Corner(outline, 12)
	local outlineStroke = Stroke(outline)
	outlineStroke.Transparency = 1

	local main = Create("CanvasGroup", {
		Name = "Main",
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = root,
	})
	Corner(main, 12)
	Bind(main, { BackgroundColor3 = "Background" })

	local sidebar = Create("Frame", {
		Name = "Sidebar",
		BorderSizePixel = 0,
		Size = UDim2.new(0, 190, 1, 0),
		Parent = main,
	})
	Bind(sidebar, { BackgroundColor3 = "Sidebar" })
	local sideLine = Create("Frame", {
		BorderSizePixel = 0,
		Position = UDim2.new(0, 190, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Parent = main,
	})
	Bind(sideLine, { BackgroundColor3 = "Stroke" })

	local brand = Create("Frame", {
		Name = "Brand",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 66),
		Parent = sidebar,
	})
	Badge(brand, window.Title, opts.Icon, 30, UDim2.new(0, 16, 0.5, 0), Vector2.new(0, 0.5))
	window._titleLabel = Label({
		Text = window.Title,
		Position = UDim2.fromOffset(56, 15),
		Size = UDim2.new(1, -64, 0, 18),
		Font = Fonts.Bold,
		TextSize = 15,
		Truncate = Enum.TextTruncate.AtEnd,
		Parent = brand,
	})
	window._subtitleLabel = Label({
		Text = window.Subtitle,
		Position = UDim2.fromOffset(56, 34),
		Size = UDim2.new(1, -64, 0, 15),
		TextSize = 12,
		Truncate = Enum.TextTruncate.AtEnd,
		Color = "SubText",
		Parent = brand,
	})

	local showHint = opts.ShowKeyHint ~= false
	local hintHeight = showHint and 46 or 0
	local tabScroll = Create("ScrollingFrame", {
		Name = "Tabs",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 68),
		Size = UDim2.new(1, 0, 1, -(68 + hintHeight)),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = sidebar,
	})
	local indicator = Create("Frame", {
		Name = "Indicator",
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(3, 18),
		Visible = false,
		Parent = tabScroll,
	})
	Round(indicator)
	Bind(indicator, { BackgroundColor3 = "Accent" })
	local tabList = Create("Frame", {
		Name = "List",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, TAB_LIST_TOP),
		Size = UDim2.new(1, -24, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = tabScroll,
	})
	List(tabList, 4)
	Pad(tabList, 0, 4, 0, 0)

	if showHint then
		local hint = Create("Frame", {
			Name = "KeyHint",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, hintHeight),
			Parent = sidebar,
		})
		Pad(hint, 0, 0, 16, 16)
		List(hint, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
		local keycap = Create("Frame", {
			Name = "Key",
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(0, 22),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = 1,
			Parent = hint,
		})
		Corner(keycap, 5)
		Stroke(keycap)
		Bind(keycap, { BackgroundColor3 = "Element" })
		Pad(keycap, 0, 0, 7, 7)
		window._keyLabel = Label({
			Text = KeyName(window.ToggleKey),
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = Fonts.Medium,
			TextSize = 11,
			Color = "SubText",
			Parent = keycap,
		})
		Label({
			Text = "to hide",
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 12,
			Color = "Muted",
			LayoutOrder = 2,
			Parent = hint,
		})
	end

	local content = Create("Frame", {
		Name = "Content",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(191, 0),
		Size = UDim2.new(1, -191, 1, 0),
		Parent = main,
	})
	local header = Create("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 70),
		Parent = content,
	})
	local pageTitle = Label({
		Text = "",
		Position = UDim2.fromOffset(24, 16),
		Size = UDim2.new(1, -120, 0, 24),
		Font = Fonts.Bold,
		TextSize = 20,
		Truncate = Enum.TextTruncate.AtEnd,
		Parent = header,
	})
	local pageDesc = Label({
		Text = "",
		Position = UDim2.fromOffset(24, 41),
		Size = UDim2.new(1, -120, 0, 16),
		TextSize = 12,
		Truncate = Enum.TextTruncate.AtEnd,
		Color = "SubText",
		Parent = header,
	})

	local function headerButton(xOffset, kind)
		local hover = false
		local button = Create("TextButton", {
			Name = kind,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, xOffset, 0, 18),
			Size = UDim2.fromOffset(28, 28),
			Parent = header,
		})
		Corner(button, 7)
		Bind(button, {
			BackgroundColor3 = "Element",
			BackgroundTransparency = function()
				return hover and 0 or 1
			end,
		})
		local barColor = function(t)
			if hover then
				return kind == "Close" and t.Error or t.Text
			end
			return t.SubText
		end
		local bars
		if kind == "Close" then
			bars = {
				IconBar(button, UDim2.fromOffset(13, 2), 45, barColor),
				IconBar(button, UDim2.fromOffset(13, 2), -45, barColor),
			}
		else
			bars = { IconBar(button, UDim2.fromOffset(11, 2), 0, barColor) }
		end
		button.MouseEnter:Connect(function()
			hover = true
			Restyle(button, 0.15)
			for _, bar in ipairs(bars) do
				Restyle(bar, 0.15)
			end
		end)
		button.MouseLeave:Connect(function()
			hover = false
			Restyle(button, 0.15)
			for _, bar in ipairs(bars) do
				Restyle(bar, 0.15)
			end
		end)
		return button
	end
	local closeButton = headerButton(-16, "Close")
	local minimizeButton = headerButton(-48, "Minimize")

	local pages = Create("Frame", {
		Name = "Pages",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(0, 70),
		Size = UDim2.new(1, 0, 1, -70),
		Parent = content,
	})
	local fader = Create("Frame", {
		Name = "Fader",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = pages.Position,
		Size = pages.Size,
		Visible = false,
		ZIndex = 5,
		Parent = content,
	})
	Bind(fader, { BackgroundColor3 = "Background" })

	local grip = Create("TextButton", {
		Name = "Resize",
		Text = "",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1),
		Size = UDim2.fromOffset(18, 18),
		ZIndex = 5,
		Visible = opts.Resizable ~= false,
		Parent = root,
	})
	for i, length in ipairs({ 5, 10 }) do
		local mark = Create("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(14 - (i - 1) * 3, 14 - (i - 1) * 3),
			Size = UDim2.fromOffset(length, 2),
			Rotation = -45,
			BackgroundTransparency = 0.4,
			Parent = grip,
		})
		Round(mark)
		Bind(mark, { BackgroundColor3 = "Muted" })
	end

	window.Gui, window.Root, window.Main = gui, root, main
	window._scale, window._shadow, window._outline = rootScale, shadow, outlineStroke
	window._tabList, window._indicator, window._pages, window._fader = tabList, indicator, pages, fader
	window._pageTitle, window._pageDesc = pageTitle, pageDesc

	MakeDraggable(header, root)
	MakeDraggable(brand, root)

	local resizing, resizeStart, startSize, startPos = false, nil, nil, nil
	grip.InputBegan:Connect(function(input)
		if IsClick(input) then
			resizing = true
			resizeStart = input.Position
			startSize = Vector2.new(root.Size.X.Offset, root.Size.Y.Offset)
			startPos = root.Position
		end
	end)
	Connect(UserInputService.InputChanged, function(input)
		if resizing and IsMove(input) then
			local delta = input.Position - resizeStart
			local w = math.max(window.MinSize.X, startSize.X + delta.X)
			local h = math.max(window.MinSize.Y, startSize.Y + delta.Y)
			root.Size = UDim2.fromOffset(w, h)
			root.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + (w - startSize.X) / 2,
				startPos.Y.Scale,
				startPos.Y.Offset + (h - startSize.Y) / 2
			)
		end
	end)
	Connect(UserInputService.InputEnded, function(input)
		if IsClick(input) then
			resizing = false
		end
	end)

	if UserInputService.TouchEnabled or opts.MobileButton then
		local open = Create("TextButton", {
			Name = "OpenButton",
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(20, 80),
			Size = UDim2.fromOffset(46, 46),
			Visible = false,
			Parent = gui,
		})
		Corner(open, 12)
		Stroke(open)
		Bind(open, { BackgroundColor3 = "Background" })
		Badge(open, window.Title, opts.Icon, 26, UDim2.fromScale(0.5, 0.5), Vector2.new(0.5, 0.5))
		local openScale = Create("UIScale", { Scale = 0, Parent = open })
		local wasDragged = MakeDraggable(open, open)
		open.MouseButton1Click:Connect(function()
			if not wasDragged() then
				window:SetVisible(true)
			end
		end)
		window._openButton, window._openScale = open, openScale
	end

	minimizeButton.MouseButton1Click:Connect(function()
		window:SetVisible(false)
		if not window._openButton then
			Axivex:Toast({ Text = "Press " .. KeyName(window.ToggleKey) .. " to reopen" })
		end
	end)
	closeButton.MouseButton1Click:Connect(function()
		window:Popup({
			Title = "Close " .. window.Title .. "?",
			Content = "This unloads the interface. Your saved configs are kept.",
			Buttons = {
				{ Text = "Cancel" },
				{
					Text = "Close",
					Primary = true,
					Callback = function()
						Axivex:Unload()
					end,
				},
			},
		})
	end)
	Connect(UserInputService.InputBegan, function(input, processed)
		if processed or UserInputService:GetFocusedTextBox() then
			return
		end
		if window._loading or Axivex._activeBind or os.clock() - (Axivex._lastBind or 0) < 0.15 then
			return
		end
		if window.ToggleKey and input.KeyCode == window.ToggleKey then
			window:Toggle()
		end
	end)

	table.insert(Axivex.Windows, window)
	if opts.Loading == false then
		window:SetVisible(true)
	else
		window.Loader = CreateLoader(window, type(opts.Loading) == "table" and opts.Loading or {})
	end
	return window
end

function Window:SetVisible(visible)
	if self.Visible == visible then
		return
	end
	self.Visible = visible
	local root = self.Root
	if visible then
		root.Visible = true
		Tween(self.Main, { GroupTransparency = 0 }, 0.35)
		Tween(self._scale, { Scale = 1 }, 0.45, Enum.EasingStyle.Quint)
		self._shadow:Fade(true, 0.35)
		Tween(self._outline, { Transparency = 0 }, 0.35)
		if self._openButton then
			Tween(self._openScale, { Scale = 0 }, 0.2)
			task.delay(0.2, function()
				if self.Visible then
					self._openButton.Visible = false
				end
			end)
		end
	else
		Tween(self.Main, { GroupTransparency = 1 }, 0.25)
		Tween(self._scale, { Scale = 0.94 }, 0.25)
		self._shadow:Fade(false, 0.25)
		Tween(self._outline, { Transparency = 1 }, 0.25)
		task.delay(0.25, function()
			if not self.Visible then
				root.Visible = false
			end
		end)
		if self._openButton then
			self._openButton.Visible = true
			Tween(self._openScale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
		end
	end
end

function Window:Toggle()
	self:SetVisible(not self.Visible)
end

function Window:SetTitle(text)
	self.Title = text
	self._titleLabel.Text = text
end

function Window:SetSubtitle(text)
	self.Subtitle = text
	self._subtitleLabel.Text = text
end

function Window:SetToggleKey(key)
	self.ToggleKey = ParseKey(key)
	if self._keyLabel then
		self._keyLabel.Text = KeyName(self.ToggleKey)
	end
end

function Window:Destroy()
	for i, w in ipairs(Axivex.Windows) do
		if w == self then
			table.remove(Axivex.Windows, i)
			break
		end
	end
	self.Gui:Destroy()
end

function Window:Notify(opts, ...)
	return Axivex:Notify(opts, ...)
end

function Window:Toast(opts, ...)
	return Axivex:Toast(opts, ...)
end

function Window:Tab(opts)
	if type(opts) ~= "table" then
		opts = { Name = tostring(opts) }
	end
	local tab = setmetatable({
		Type = "Tab",
		Name = opts.Name or opts.Title or "Tab",
		Desc = opts.Description or opts.Desc or "",
		Window = self,
		_order = 0,
		_hover = false,
	}, TabMeta)
	local index = #self.Tabs + 1
	tab.Index = index

	local isSelected = function()
		return self.Selected == tab
	end

	local button = Create("TextButton", {
		Name = tab.Name,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		LayoutOrder = index,
		Parent = self._tabList,
	})
	Corner(button, 8)
	Bind(button, {
		BackgroundColor3 = "Element",
		BackgroundTransparency = function()
			if isSelected() then
				return 0
			elseif tab._hover then
				return 0.6
			end
			return 1
		end,
	})
	local buttonStroke = Stroke(button)
	Bind(buttonStroke, {
		Transparency = function()
			return isSelected() and 0 or 1
		end,
	})
	local textColor = function(t)
		return (isSelected() or tab._hover) and t.Text or t.SubText
	end
	local styled = { button, buttonStroke }
	local textX = 14
	local iconImage = ResolveIcon(opts.Icon)
	if iconImage then
		local icon = Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = iconImage,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 12, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			Parent = button,
		})
		Bind(icon, { ImageColor3 = textColor })
		table.insert(styled, icon)
		textX = 38
	end
	local label = Label({
		Text = tab.Name,
		Position = UDim2.fromOffset(textX, 0),
		Size = UDim2.new(1, -(textX + 8), 1, 0),
		Font = Fonts.Medium,
		TextSize = 13,
		Truncate = Enum.TextTruncate.AtEnd,
		Color = textColor,
		Parent = button,
	})
	table.insert(styled, label)
	tab._button, tab._styled = button, styled

	button.MouseEnter:Connect(function()
		tab._hover = true
		for _, obj in ipairs(styled) do
			Restyle(obj, 0.15)
		end
	end)
	button.MouseLeave:Connect(function()
		tab._hover = false
		for _, obj in ipairs(styled) do
			Restyle(obj, 0.15)
		end
	end)
	button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	local page = Create("ScrollingFrame", {
		Name = tab.Name,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Visible = false,
		Parent = self._pages,
	})
	Bind(page, { ScrollBarImageColor3 = "Stroke" })
	Pad(page, 2, 20, 24, 20)
	List(page, 10)
	tab.Scroll, tab.Frame = page, page

	table.insert(self.Tabs, tab)
	if not self.Selected then
		self:SelectTab(tab, true)
	end
	return tab
end
Window.AddTab = Window.Tab
Window.CreateTab = Window.Tab

function Window:SelectTab(tab, instant)
	if type(tab) == "number" or type(tab) == "string" then
		for _, t in ipairs(self.Tabs) do
			if t.Index == tab or t.Name == tab then
				tab = t
				break
			end
		end
	end
	if type(tab) ~= "table" or self.Selected == tab then
		return
	end
	local previous = self.Selected
	self.Selected = tab

	for _, t in ipairs(self.Tabs) do
		for _, obj in ipairs(t._styled) do
			Restyle(obj, 0.25)
		end
	end

	local indicatorY = TAB_LIST_TOP + (tab.Index - 1) * 40 + 9
	if self._indicator.Visible then
		Tween(self._indicator, { Position = UDim2.fromOffset(0, indicatorY) }, 0.4)
		Tween(self._indicator, { Size = UDim2.fromOffset(3, 26) }, 0.15)
		task.delay(0.15, function()
			Tween(self._indicator, { Size = UDim2.fromOffset(3, 18) }, 0.3)
		end)
	else
		self._indicator.Position = UDim2.fromOffset(0, indicatorY)
		self._indicator.Visible = true
	end

	self._switch = self._switch + 1
	local switch = self._switch
	local function show()
		for _, t in ipairs(self.Tabs) do
			t.Scroll.Visible = t == tab
		end
		self._pageTitle.Text = tab.Name
		self._pageDesc.Text = tab.Desc
		self._pageTitle.TextTransparency = 1
		self._pageDesc.TextTransparency = 1
		Tween(self._pageTitle, { TextTransparency = 0 }, 0.35)
		Tween(self._pageDesc, { TextTransparency = 0 }, 0.45)
		tab.Scroll.Position = UDim2.fromOffset(0, 14)
		Tween(tab.Scroll, { Position = UDim2.fromOffset(0, 0) }, 0.45)
	end

	if instant or not previous then
		show()
		return
	end
	local fader = self._fader
	fader.Visible = true
	Tween(fader, { BackgroundTransparency = 0 }, 0.12)
	task.delay(0.12, function()
		if switch ~= self._switch then
			return
		end
		show()
		Tween(fader, { BackgroundTransparency = 1 }, 0.3)
		task.delay(0.3, function()
			if switch == self._switch then
				fader.Visible = false
			end
		end)
	end)
end

function Tab:Select()
	self.Window:SelectTab(self)
end

function Tab:SetName(name)
	self.Name = name
	for _, obj in ipairs(self._styled) do
		if obj:IsA("TextLabel") then
			obj.Text = name
		end
	end
	if self.Window.Selected == self then
		self.Window._pageTitle.Text = name
	end
end

function Tab:SetDescription(text)
	self.Desc = text
	if self.Window.Selected == self then
		self.Window._pageDesc.Text = text
	end
end

function Tab:Page(opts)
	if type(opts) ~= "table" then
		opts = { Name = tostring(opts) }
	end
	if not self._pageBar then
		local bar = Create("Frame", {
			Name = "PageBar",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 32),
			LayoutOrder = NextOrder(self),
			Parent = self.Frame,
		})
		List(bar, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
		self._pageBar = bar
		self.Pages = {}
	end

	local page = setmetatable({
		Type = "Page",
		Name = opts.Name or "Page",
		Window = self.Window,
		Tab = self,
		Index = #self.Pages + 1,
		_order = 0,
		_hover = false,
	}, PageMeta)

	local isSelected = function()
		return self.SelectedPage == page
	end
	local button = Create("TextButton", {
		Name = page.Name,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(0, 30),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = page.Index,
		Parent = self._pageBar,
	})
	Corner(button, 8)
	Pad(button, 0, 0, 12, 12)
	List(button, 7, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
	Bind(button, {
		BackgroundColor3 = "Element",
		BackgroundTransparency = function()
			if isSelected() then
				return 0
			elseif page._hover then
				return 0.6
			end
			return 1
		end,
	})
	local stroke = Stroke(button)
	Bind(stroke, {
		Transparency = function()
			return isSelected() and 0 or 1
		end,
	})
	local textColor = function(t)
		return (isSelected() or page._hover) and t.Text or t.SubText
	end
	local styled = { button, stroke }
	local iconImage = ResolveIcon(opts.Icon)
	if iconImage then
		local icon = Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = iconImage,
			Size = UDim2.fromOffset(15, 15),
			LayoutOrder = 1,
			Parent = button,
		})
		Bind(icon, { ImageColor3 = textColor })
		table.insert(styled, icon)
	end
	table.insert(styled, Label({
		Text = page.Name,
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		Font = Fonts.Medium,
		TextSize = 13,
		Color = textColor,
		LayoutOrder = 2,
		Parent = button,
	}))
	page._styled = styled

	button.MouseEnter:Connect(function()
		page._hover = true
		for _, obj in ipairs(styled) do
			Restyle(obj, 0.15)
		end
	end)
	button.MouseLeave:Connect(function()
		page._hover = false
		for _, obj in ipairs(styled) do
			Restyle(obj, 0.15)
		end
	end)
	button.MouseButton1Click:Connect(function()
		self:SelectPage(page)
	end)

	local frame = Create("Frame", {
		Name = page.Name,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = false,
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	List(frame, 10)
	page._padding = Pad(frame, 0, 0, 0, 0)
	page.Frame = frame

	table.insert(self.Pages, page)
	if not self.SelectedPage then
		self:SelectPage(page, true)
	end
	return page
end
Tab.AddPage = Tab.Page

function Tab:SelectPage(page, instant)
	if type(page) == "number" or type(page) == "string" then
		for _, p in ipairs(self.Pages or {}) do
			if p.Index == page or p.Name == page then
				page = p
				break
			end
		end
	end
	if type(page) ~= "table" or self.SelectedPage == page then
		return
	end
	self.SelectedPage = page
	for _, p in ipairs(self.Pages) do
		p.Frame.Visible = p == page
		for _, obj in ipairs(p._styled) do
			Restyle(obj, 0.2)
		end
	end
	if not instant then
		page._padding.PaddingTop = UDim.new(0, 14)
		Tween(page._padding, { PaddingTop = UDim.new(0, 0) }, 0.4)
	end
end

function Page:Select()
	self.Tab:SelectPage(self)
end

function Window:Popup(opts)
	opts = opts or {}
	local popup = { Closed = false }
	local overlay = Create("TextButton", {
		Name = "Popup",
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 50,
		Parent = self.Main,
	})
	local dialog = Create("TextButton", {
		Name = "Dialog",
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(opts.Width or 340, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = overlay,
	})
	Corner(dialog, 12)
	Stroke(dialog)
	Bind(dialog, { BackgroundColor3 = "Sidebar" })
	Pad(dialog, 18, 18, 20, 20)
	List(dialog, 10)
	local scale = Create("UIScale", { Scale = 0.92, Parent = dialog })

	Label({
		Text = opts.Title or "Are you sure?",
		Size = UDim2.new(1, 0, 0, 20),
		Font = Fonts.Bold,
		TextSize = 16,
		LayoutOrder = 1,
		Parent = dialog,
	})
	if opts.Content or opts.Text then
		Label({
			Text = opts.Content or opts.Text,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Wrapped = true,
			RichText = true,
			TextSize = 13,
			Color = "SubText",
			LayoutOrder = 2,
			Parent = dialog,
		})
	end

	local inputBox
	if opts.Input then
		local inputOpts = type(opts.Input) == "table" and opts.Input or {}
		local _, box = Field(dialog, UDim2.new(1, 0, 0, 32), nil, {
			Placeholder = inputOpts.Placeholder or "Type here...",
			Text = inputOpts.Default or "",
			LayoutOrder = 3,
		})
		inputBox = box
	end

	local row = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = 4,
		Parent = dialog,
	})
	List(row, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
	local buttons = opts.Buttons or { { Text = "Okay", Primary = true } }

	for i, data in ipairs(buttons) do
		local hover = false
		local primary = data.Primary
		local button = Create("TextButton", {
			Text = data.Text or data.Title or "Button",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			FontFace = Fonts.SemiBold,
			TextSize = 13,
			LayoutOrder = i,
			Parent = row,
		})
		Corner(button, 8)
		Pad(button, 0, 0, 16, 16)
		Stroke(button, primary and "Accent" or "Stroke")
		Bind(button, {
			BackgroundColor3 = function(t)
				local base = primary and t.Accent or t.Field
				if hover then
					return primary and base:Lerp(Color3.new(1, 1, 1), 0.15) or t.ElementHover
				end
				return base
			end,
			TextColor3 = primary and "OnAccent" or "Text",
		})
		button.MouseEnter:Connect(function()
			hover = true
			Restyle(button, 0.15)
		end)
		button.MouseLeave:Connect(function()
			hover = false
			Restyle(button, 0.15)
		end)
		button.MouseButton1Click:Connect(function()
			if popup.Closed then
				return
			end
			local keepOpen = false
			if data.Callback then
				local ok, result = pcall(data.Callback, inputBox and inputBox.Text)
				if not ok then
					Log("Popup callback error: " .. tostring(result))
				end
				keepOpen = ok and result == false
			end
			if not keepOpen then
				popup:Close()
			end
		end)
	end

	function popup:Close()
		if self.Closed then
			return
		end
		self.Closed = true
		FadeTree(dialog, false, 0.2)
		Tween(scale, { Scale = 0.95 }, 0.2)
		Tween(overlay, { BackgroundTransparency = 1 }, 0.25)
		task.delay(0.25, function()
			overlay:Destroy()
		end)
		Spawn(opts.OnClose)
	end

	overlay.MouseButton1Click:Connect(function()
		if opts.Dismissable ~= false then
			popup:Close()
		end
	end)

	Tween(overlay, { BackgroundTransparency = 0.45 }, 0.25)
	FadeTree(dialog, true, 0.3)
	Tween(scale, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
	if inputBox then
		task.delay(0.1, function()
			inputBox:CaptureFocus()
		end)
	end
	return popup
end
Window.Dialog = Window.Popup

function Axivex:Popup(opts)
	local window = self.Windows[#self.Windows]
	if window then
		return window:Popup(opts)
	end
end

function Window:_path(name)
	return self._configDir .. "/" .. SafeName(name) .. ".json"
end

function Window:SaveConfig(name)
	name = Trim(name)
	if name == "" then
		return false, "Invalid config name"
	end
	FS.EnsureFolder(self._configDir)
	local flags = {}
	for flag, el in pairs(Axivex.Options) do
		if el.Type ~= "Button" and el.Type ~= "Progress" then
			flags[flag] = Encode(el:Get())
		end
	end
	local ok, json = pcall(HttpService.JSONEncode, HttpService, { Version = 1, Flags = flags })
	if not ok then
		return false, json
	end
	return FS.Write(self:_path(name), json)
end

function Window:LoadConfig(name)
	local raw = FS.Read(self:_path(Trim(name)))
	if not raw then
		return false, "Config not found"
	end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
	if not ok or type(data) ~= "table" then
		return false, "Config is corrupted"
	end
	for flag, value in pairs(data.Flags or {}) do
		local el = Axivex.Options[flag]
		if el and el.Set then
			local decoded = Decode(value)
			task.spawn(function()
				local success, err = pcall(el.Set, el, decoded)
				if not success then
					Log("Failed to load flag '" .. tostring(flag) .. "': " .. tostring(err))
				end
			end)
		end
	end
	return true
end

function Window:DeleteConfig(name)
	return FS.Delete(self:_path(Trim(name)))
end

function Window:ListConfigs()
	local out = {}
	for _, file in ipairs(FS.List(self._configDir)) do
		local name = tostring(file):match("([^/\\]+)%.json$")
		if name then
			table.insert(out, name)
		end
	end
	table.sort(out)
	return out
end

function Window:SetAutoload(name)
	FS.EnsureFolder(self._configDir)
	if name then
		return FS.Write(self._configDir .. "/autoload.txt", Trim(name))
	end
	return FS.Delete(self._configDir .. "/autoload.txt")
end

function Window:GetAutoload()
	local name = FS.Read(self._configDir .. "/autoload.txt")
	if name and Trim(name) ~= "" then
		return Trim(name)
	end
	return nil
end

function Window:LoadAutoload()
	local name = self:GetAutoload()
	if not name and self.AutoSave then
		name = type(self.AutoSave) == "string" and self.AutoSave or "autosave"
	end
	if name then
		return self:LoadConfig(name)
	end
	return false, "No autoload config"
end

function Window:_changed()
	if not self.AutoSave then
		return
	end
	self._saveToken = (self._saveToken or 0) + 1
	local token = self._saveToken
	task.delay(1, function()
		if token == self._saveToken then
			self:SaveConfig(type(self.AutoSave) == "string" and self.AutoSave or "autosave")
		end
	end)
end

function Window:SettingsTab(opts)
	opts = opts or {}
	local window = self
	local tab = self:Tab({
		Name = opts.Name or "Settings",
		Icon = opts.Icon,
		Description = opts.Description or "Configs, theme and interface",
	})

	local configs = tab:Section("Configuration")
	local nameInput = configs:Input({
		Title = "Config name",
		Placeholder = "my-config",
		Finished = false,
	})
	local list = configs:Dropdown({
		Title = "Saved configs",
		Options = window:ListConfigs(),
		AllowNull = true,
	})

	local function selectedName()
		local typed = Trim(nameInput.Value)
		if typed ~= "" then
			return typed
		end
		return list.Value
	end

	configs:Button({
		Title = "Save config",
		Desc = "Saves every flagged element",
		Primary = true,
		Callback = function()
			local name = selectedName()
			if not name then
				return Axivex:Toast({ Text = "Enter a config name first", Type = "Error" })
			end
			local ok = window:SaveConfig(name)
			list:Refresh(window:ListConfigs())
			list:Set(name, true)
			Axivex:Toast({ Text = ok and ("Saved " .. name) or "Couldn't save config", Type = ok and "Success" or "Error" })
		end,
	})
	configs:Button({
		Title = "Load config",
		Callback = function()
			local name = selectedName()
			if not name then
				return Axivex:Toast({ Text = "Pick a config to load", Type = "Error" })
			end
			local ok, err = window:LoadConfig(name)
			Axivex:Toast({ Text = ok and ("Loaded " .. name) or err, Type = ok and "Success" or "Error" })
		end,
	})
	configs:Button({
		Title = "Delete config",
		Callback = function()
			local name = selectedName()
			if not name then
				return Axivex:Toast({ Text = "Pick a config to delete", Type = "Error" })
			end
			window:Popup({
				Title = "Delete " .. name .. "?",
				Content = "This can't be undone.",
				Buttons = {
					{ Text = "Cancel" },
					{
						Text = "Delete",
						Primary = true,
						Callback = function()
							window:DeleteConfig(name)
							list:Refresh(window:ListConfigs())
							Axivex:Toast({ Text = "Deleted " .. name })
						end,
					},
				},
			})
		end,
	})
	local autoload
	autoload = configs:Toggle({
		Title = "Autoload",
		Desc = "Load the selected config when the script starts",
		Default = window:GetAutoload() ~= nil,
		Callback = function(state)
			if state then
				local name = selectedName()
				if not name then
					Axivex:Toast({ Text = "Pick a config to autoload", Type = "Error" })
					autoload:Set(false, true)
					return
				end
				window:SetAutoload(name)
				Axivex:Toast({ Text = "Autoloading " .. name })
			else
				window:SetAutoload(nil)
			end
		end,
	})
	configs:Button({
		Title = "Refresh list",
		Callback = function()
			list:Refresh(window:ListConfigs(), true)
		end,
	})

	local ui = tab:Section("Interface")
	local themeNames = {}
	for name in pairs(Axivex.Themes) do
		table.insert(themeNames, name)
	end
	table.sort(themeNames)
	ui:Dropdown({
		Title = "Theme",
		Options = themeNames,
		Default = Axivex.ThemeName,
		Callback = function(name)
			if name then
				Axivex:SetTheme(name)
			end
		end,
	})
	ui:ColorPicker({
		Title = "Accent color",
		Default = Axivex.Theme.Accent,
		Callback = function(color)
			Axivex:SetAccent(color)
		end,
	})
	ui:Keybind({
		Title = "Toggle key",
		Desc = "Shows or hides the window",
		Default = window.ToggleKey,
		ChangedCallback = function(key)
			window:SetToggleKey(key)
		end,
	})
	ui:Button({
		Title = "Unload",
		Desc = "Removes the interface completely",
		Callback = function()
			window:Popup({
				Title = "Unload interface?",
				Buttons = {
					{ Text = "Cancel" },
					{
						Text = "Unload",
						Primary = true,
						Callback = function()
							Axivex:Unload()
						end,
					},
				},
			})
		end,
	})
	return tab
end

function Axivex:Unload()
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	table.clear(self._connections)
	for _, window in ipairs(self.Windows) do
		pcall(function()
			window:SetVisible(false)
		end)
		local gui = window.Gui
		task.delay(0.3, function()
			gui:Destroy()
		end)
	end
	table.clear(self.Windows)
	if NotifyGui then
		local gui = NotifyGui
		NotifyGui = nil
		task.delay(0.3, function()
			gui:Destroy()
		end)
	end
	table.clear(self.Options)
	table.clear(self.Flags)
	Spawn(self.OnUnload)
end

return Axivex
