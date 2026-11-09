-- Axivex Library v2
-- Socials @blankfelony - Discord | proxylol - Github
-- Axivex (c) 2026 proxylol. All rights reserved.
-- Use only by loading from the official URL. No copying, editing or redistribution.
-- Full license: https://github.com/proxylol/Axivex/blob/main/LICENSE

local Axivex = {
	Version = "2.0.0",
	Flags = {},
	Options = {},
	Themes = {},
	Windows = {},
	Folder = "lsdresearch - Axivex Library",
	AssetURL = "https://raw.githubusercontent.com/proxylol/Axivex/refs/heads/main/assets/",
	AssetVersion = 2,
	FontFamily = "rbxasset://fonts/families/Montserrat.json",
	MaxNotifications = 5,
	Discord = nil,
	LoaderMessage = "Thanks for using this lsdresearch! Click load whenever you're ready.",
	_connections = {},
	_themeListeners = {},
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local LoadedAt = os.clock()
local V2, U2, Off, Sc = Vector2.new, UDim2.new, UDim2.fromOffset, UDim2.fromScale

local function ReadGlobal(name)
	local ok, value = pcall(function()
		local v = getgenv and getgenv()[name]
		if v ~= nil then
			return v
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

local function F(weight)
	return Font.new(Axivex.FontFamily, Enum.FontWeight[weight])
end
local Fonts = { Regular = F("Regular"), Medium = F("Medium"), SemiBold = F("SemiBold"), Bold = F("Bold") }
Axivex.Fonts = Fonts

local function C(r, g, b)
	return Color3.fromRGB(r, g, b)
end

local BaseTheme = {
	Accent = C(232, 84, 148), AccentDark = C(140, 106, 179), OnAccent = C(255, 255, 255),
	Background = C(12, 11, 15), Sidebar = C(16, 15, 20), Element = C(22, 20, 27), ElementHover = C(29, 27, 36),
	Field = C(14, 13, 18), Stroke = C(38, 35, 46), Text = C(242, 240, 247), SubText = C(160, 155, 172),
	Muted = C(104, 100, 116), Success = C(112, 222, 152), Warning = C(255, 196, 92), Error = C(255, 99, 112),
	Info = C(120, 175, 255), Shadow = C(0, 0, 0),
}

local function MakeTheme(overrides)
	local theme = table.clone(BaseTheme)
	for k, v in pairs(overrides or {}) do
		theme[k] = v
	end
	return theme
end
Axivex.MakeTheme = MakeTheme

local ThemeKeys = { "Accent", "AccentDark", "OnAccent", "Background", "Sidebar", "Element", "ElementHover", "Field", "Stroke" }
local ThemeData = {
	Axivex = {},
	Lavender = { { 167, 139, 250 }, { 124, 77, 255 }, { 22, 12, 42 }, { 13, 10, 20 }, { 17, 13, 26 }, { 23, 18, 37 }, { 31, 25, 48 }, { 15, 12, 24 }, { 42, 34, 64 }, { SubText = C(163, 155, 184), Muted = C(107, 100, 130) } },
	Ocean = { { 140, 170, 255 }, { 60, 120, 255 }, { 10, 18, 40 }, { 9, 12, 21 }, { 12, 16, 28 }, { 17, 23, 38 }, { 24, 31, 50 }, { 10, 14, 24 }, { 32, 42, 66 } },
	Rose = { { 255, 160, 190 }, { 240, 82, 128 }, { 46, 14, 26 }, { 18, 10, 14 }, { 23, 13, 18 }, { 32, 19, 26 }, { 42, 25, 34 }, { 19, 11, 15 }, { 58, 36, 47 }, { SubText = C(178, 150, 162), Muted = C(120, 94, 106) } },
	Emerald = { { 120, 236, 180 }, { 20, 184, 130 }, { 8, 34, 24 }, { 9, 15, 13 }, { 12, 19, 17 }, { 17, 27, 24 }, { 23, 36, 32 }, { 10, 16, 14 }, { 32, 50, 44 } },
	Amber = { { 255, 205, 120 }, { 255, 130, 60 }, { 46, 28, 8 }, { 16, 12, 9 }, { 21, 16, 12 }, { 30, 23, 17 }, { 40, 31, 23 }, { 17, 13, 10 }, { 56, 44, 32 }, { SubText = C(176, 162, 142), Muted = C(118, 106, 92) } },
	Mono = { { 235, 235, 240 }, { 150, 150, 160 }, { 18, 18, 22 }, { 11, 11, 12 }, { 15, 15, 17 }, { 21, 21, 24 }, { 28, 28, 32 }, { 13, 13, 15 }, { 40, 40, 46 } },
	Light = { { 132, 100, 248 }, { 92, 60, 225 }, { 255, 255, 255 }, { 246, 245, 250 }, { 238, 236, 246 }, { 255, 255, 255 }, { 243, 240, 252 }, { 240, 238, 247 }, { 222, 218, 236 }, {
		Text = C(24, 20, 36), SubText = C(100, 96, 120), Muted = C(150, 146, 168),
		Success = C(40, 170, 100), Warning = C(220, 150, 30), Error = C(225, 60, 80), Shadow = C(80, 70, 120),
	} },
}
for name, data in pairs(ThemeData) do
	local overrides = table.clone(data[10] or {})
	for i, key in ipairs(ThemeKeys) do
		if data[i] then
			overrides[key] = C(table.unpack(data[i]))
		end
	end
	Axivex.Themes[name] = MakeTheme(overrides)
end
Axivex.Theme = Axivex.Themes.Axivex
Axivex.ThemeName = "Axivex"

local function New(class, props, children)
	local obj = Instance.new(class)
	if obj:IsA("GuiObject") then
		obj.BorderSizePixel = 0
	end
	local parent = props and props.Parent
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = obj
	end
	obj.Parent = parent
	return obj
end

local function Tween(obj, goal, duration, style, direction)
	local info = typeof(duration) == "TweenInfo" and duration
		or TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
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
	if type(fn) == "function" then
		local ok, err = pcall(fn, ...)
		if not ok then
			Log("Callback error: " .. tostring(err))
		end
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
	local d = tostring(n):match("%.(%d+)$")
	return d and #d or 0
end

local function IsClick(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function IsMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function OnHover(gui, fn)
	gui.MouseEnter:Connect(function()
		fn(true)
	end)
	gui.MouseLeave:Connect(function()
		fn(false)
	end)
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
		Themed[obj] = bound
		obj.Destroying:Connect(function()
			Themed[obj] = nil
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
			goal[prop], any = value, true
		else
			obj[prop] = value
		end
	end
	if any then
		Tween(obj, goal, duration or 0.25)
	end
end

local function RestyleAll(list, duration)
	for _, obj in ipairs(list) do
		Restyle(obj, duration)
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
	for obj in pairs(Themed) do
		if obj.Parent then
			Restyle(obj, 0.35)
		end
	end
	for _, fn in ipairs(self._themeListeners) do
		Spawn(fn, self.Theme)
	end
end

function Axivex:SetAccent(color, darkColor)
	local theme = MakeTheme(self.Theme)
	local h, s, v = color:ToHSV()
	theme.Accent = color
	theme.AccentDark = darkColor or Color3.fromHSV((h + 0.04) % 1, math.min(1, s + 0.3), v * 0.85)
	local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
	theme.OnAccent = luminance > 0.6 and C(22, 12, 42) or C(255, 255, 255)
	local name = self.ThemeName
	self:SetTheme(theme)
	self.ThemeName = name
end

function Axivex:OnThemeChanged(fn)
	table.insert(self._themeListeners, fn)
end

local function Corner(parent, radius)
	return New("UICorner", { CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius or 10), Parent = parent })
end

local function Round(parent)
	return Corner(parent, UDim.new(1, 0))
end

local function Stroke(parent, key, transparency)
	local stroke = New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Transparency = transparency or 0,
		Parent = parent,
	})
	return Bind(stroke, { Color = key or "Stroke" })
end

local function Pad(parent, top, bottom, left, right)
	return New("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or top or 0),
		PaddingRight = UDim.new(0, right or left or top or 0),
		Parent = parent,
	})
end

local function List(parent, padding, horizontal, hAlign, vAlign)
	return New("UIListLayout", {
		Padding = UDim.new(0, padding or 0),
		FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
		HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left,
		VerticalAlignment = vAlign or (horizontal and Enum.VerticalAlignment.Center) or Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

local function Label(p)
	local label = New("TextLabel", {
		Name = p.Name or "Label",
		BackgroundTransparency = 1,
		Text = p.Text or "",
		FontFace = p.Font or Fonts.Regular,
		TextSize = p.TextSize or 13,
		TextXAlignment = p.XAlign or Enum.TextXAlignment.Left,
		TextYAlignment = p.YAlign or Enum.TextYAlignment.Center,
		Size = p.Size or Sc(1, 1),
		Position = p.Position or U2(),
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
	return Bind(label, { TextColor3 = p.Color or "Text" })
end

local function AutoLabel(parent, text, size, font, color, order)
	return Label({
		Text = text,
		Size = Sc(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		TextSize = size,
		Font = font,
		Color = color,
		LayoutOrder = order,
		Parent = parent,
	})
end

local function Gradient(parent, rotation, fn)
	local gradient = New("UIGradient", { Rotation = rotation or 0, Parent = parent })
	return Bind(gradient, {
		Color = fn or function(t)
			return ColorSequence.new(t.AccentDark, t.Accent)
		end,
	})
end

local function Shimmer(parent)
	local shine = New("Frame", { Name = "Shimmer", BackgroundColor3 = Color3.new(1, 1, 1), Size = Sc(1, 1), Parent = parent })
	Round(shine)
	local gradient = New("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.4, 1),
			NumberSequenceKeypoint.new(0.5, 0.6),
			NumberSequenceKeypoint.new(0.6, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Offset = V2(-1, 0),
		Parent = shine,
	})
	Tween(gradient, { Offset = V2(1, 0) }, TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false, 0.6))
	return shine
end

local function Glow(parent, key, size, position, strength)
	local holder = New("Frame", {
		Name = "Glow",
		BackgroundTransparency = 1,
		AnchorPoint = V2(0.5, 0.5),
		Position = position,
		Size = Off(size.X, size.Y),
		ZIndex = 0,
		Parent = parent,
	})
	for i = 1, 7 do
		local layer = New("Frame", {
			AnchorPoint = V2(0.5, 0.5),
			Position = Sc(0.5, 0.5),
			Size = Sc(i / 7, i / 7),
			BackgroundTransparency = 1 - (strength or 0.035),
			ZIndex = 0,
			Parent = holder,
		})
		Round(layer)
		Bind(layer, { BackgroundColor3 = key })
	end
	return holder
end

local function Ripple(button, position)
	local abs = button.AbsolutePosition
	local circle = New("Frame", {
		Name = "Ripple",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.88,
		AnchorPoint = V2(0.5, 0.5),
		Position = Off(position.X - abs.X, position.Y - abs.Y),
		Size = Off(0, 0),
		ZIndex = 5,
		Parent = button,
	})
	Round(circle)
	local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
	Tween(circle, { Size = Off(size, size), BackgroundTransparency = 1 }, 0.7)
	task.delay(0.7, circle.Destroy, circle)
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
			dragging, moved, start, startPos = true, false, input.Position, target.Position
		end
	end)
	Connect(UserInputService.InputChanged, function(input)
		if dragging and IsMove(input) then
			local delta = input.Position - start
			moved = moved or delta.Magnitude > 4
			Tween(target, { Position = U2(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) }, 0.12)
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

local function ParentGui(gui)
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)
	local ok, hui = pcall(function()
		return gethui and gethui()
	end)
	if ok and hui then
		gui.Parent = hui
		return
	end
	if not pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end) then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
end

local IconCache, IconQueue = {}, {}
Axivex.IconsAvailable = type(getcustomasset) == "function" and type(writefile) == "function" and type(isfile) == "function"

local function MakeFolders(path)
	if type(makefolder) ~= "function" then
		return
	end
	local current = ""
	for part in path:gmatch("[^/]+") do
		current = current == "" and part or (current .. "/" .. part)
		local ok, exists = pcall(isfolder, current)
		if not (ok and exists) then
			pcall(makefolder, current)
		end
	end
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
			local data = game:HttpGet(url)
			if path:lower():match("%.png$") and data:sub(2, 4) ~= "PNG" then
				error("not a PNG (" .. #data .. " bytes)")
			end
			MakeFolders(path:match("^(.*)/[^/]+$") or "")
			writefile(path, data)
		end
		return getcustomasset(path)
	end)
	if not ok then
		Log("Couldn't load custom asset '" .. tostring(path) .. "': " .. tostring(asset))
		return nil
	end
	return asset
end

local function IsIconName(icon)
	return type(icon) == "string" and icon:match("^[%w%-_]+$") ~= nil
end

local function LoadIcon(name, done, fail)
	local cached = IconCache[name]
	if cached then
		return done(cached)
	elseif cached == false or not Axivex.IconsAvailable then
		return fail and fail()
	end
	local queue = IconQueue[name]
	if queue then
		table.insert(queue, { done, fail })
		return
	end
	queue = { { done, fail } }
	IconQueue[name] = queue
	task.spawn(function()
		local asset = Axivex:CustomAsset(Axivex.Folder .. "/assets/v" .. Axivex.AssetVersion .. "/" .. name .. ".png", Axivex.AssetURL .. name .. ".png")
		IconCache[name] = asset or false
		IconQueue[name] = nil
		for _, waiter in ipairs(queue) do
			SafeCall(asset and waiter[1] or waiter[2], asset)
		end
	end)
end

function Axivex:PreloadIcons(names)
	for _, name in ipairs(names) do
		LoadIcon(name, function() end)
	end
end

local function ResolveIcon(icon)
	if icon == nil or icon == 0 or icon == "" then
		return nil
	elseif type(icon) == "number" then
		return not Axivex.Secure and icon > 0 and ("rbxassetid://" .. icon) or nil
	elseif type(icon) ~= "string" then
		return nil
	elseif icon:match("^rbxasset://.+") then
		return icon
	elseif not Axivex.Secure and (icon:match("^rbxassetid://%d+$") or icon:match("^rbxthumb://.+")) then
		return icon
	end
	return nil
end

local function Icon(parent, icon, size, key, props)
	local direct = ResolveIcon(icon)
	if not direct and not (IsIconName(icon) and Axivex.IconsAvailable) then
		return nil
	end
	local image = New("ImageLabel", { Name = "Icon", BackgroundTransparency = 1, Size = Off(size, size), Image = direct or "", Parent = parent })
	for k, v in pairs(props or {}) do
		image[k] = v
	end
	Bind(image, { ImageColor3 = key or "SubText" })
	if not direct then
		LoadIcon(icon, function(asset)
			image.Image = asset
		end)
	end
	return image
end

local GlyphText = { ["chevron-right"] = "›", ["chevron-down"] = "›", x = "×", minus = "–", check = "✓", play = "▶", copy = "⧉" }
local function Glyph(parent, name, size, key, props)
	local holder = New("Frame", { Name = "Glyph", BackgroundTransparency = 1, Size = Off(size, size), Parent = parent })
	for k, v in pairs(props or {}) do
		holder[k] = v
	end
	local function fallback()
		if holder.Parent then
			local text = Label({ Text = GlyphText[name] or "•", XAlign = Enum.TextXAlignment.Center, Font = Fonts.Bold, TextSize = size + 3, Color = key, Parent = holder })
			text.Rotation = name == "chevron-down" and 90 or 0
		end
	end
	if not Axivex.IconsAvailable then
		fallback()
		return holder
	end
	local image = New("ImageLabel", { BackgroundTransparency = 1, Size = Sc(1, 1), Parent = holder })
	Bind(image, { ImageColor3 = key or "SubText" })
	LoadIcon(name, function(asset)
		image.Image = asset
	end, function()
		image:Destroy()
		fallback()
	end)
	return holder
end

local KeyNames = {
	LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl", LeftAlt = "LAlt",
	RightAlt = "RAlt", Return = "Enter", MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3",
	Backquote = "`", CapsLock = "Caps", PageUp = "PgUp", PageDown = "PgDn",
}

local function KeyName(key)
	return key and (KeyNames[key.Name] or key.Name) or "None"
end

local function ParseKey(value)
	if typeof(value) == "EnumItem" then
		return value
	elseif type(value) ~= "string" or value == "" or value == "None" then
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
	elseif key.EnumType == Enum.KeyCode then
		return input.KeyCode == key
	end
	return input.UserInputType == key
end

local FS = { Enabled = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function", Memory = {} }
Axivex.FileSystem = FS

function FS.EnsureFolder(path)
	if FS.Enabled then
		MakeFolders(path)
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
	if not FS.Enabled then
		return FS.Memory[path]
	end
	local ok, exists = pcall(isfile, path)
	if ok and exists then
		local ok2, data = pcall(readfile, path)
		return ok2 and data or nil
	end
end

function FS.Delete(path)
	if not FS.Enabled then
		FS.Memory[path] = nil
		return true
	end
	return type(delfile) == "function" and pcall(delfile, path) or false
end

function FS.List(folder)
	if FS.Enabled then
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
	if type(value) ~= "table" or not value.__t then
		return value
	end
	local ok, result = pcall(function()
		if value.__t == "Color3" then
			return Color3.fromHex(value.v)
		elseif value.__t == "Enum" then
			return Enum[value.e][value.n]
		end
	end)
	return ok and result or nil
end

local function Field(parent, size, position, p)
	p = p or {}
	local focused = false
	local frame = New("Frame", {
		Size = size,
		Position = position or U2(),
		AnchorPoint = p.AnchorPoint or Vector2.zero,
		ClipsDescendants = true,
		LayoutOrder = p.LayoutOrder or 0,
		Parent = parent,
	})
	Bind(frame, { BackgroundColor3 = "Field" })
	Corner(frame, 7)
	local stroke = Stroke(frame)
	Bind(stroke, {
		Color = function(t)
			return focused and t.Accent or t.Stroke
		end,
	})
	local box = New("TextBox", {
		BackgroundTransparency = 1,
		Position = Off(10, 0),
		Size = U2(1, -20, 1, 0),
		Text = p.Text or "",
		PlaceholderText = p.Placeholder or "",
		ClearTextOnFocus = p.ClearOnFocus or false,
		FontFace = p.Font or Fonts.Medium,
		TextSize = p.TextSize or 12,
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

local FadeProps = {
	Frame = { "BackgroundTransparency" },
	TextLabel = { "BackgroundTransparency", "TextTransparency" },
	TextButton = { "BackgroundTransparency", "TextTransparency" },
	TextBox = { "BackgroundTransparency", "TextTransparency" },
	ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
	UIStroke = { "Transparency" },
}

local function FadeTree(root, visible, duration)
	local items = root:GetDescendants()
	table.insert(items, root)
	for _, inst in ipairs(items) do
		local props = FadeProps[inst.ClassName]
		if props then
			local goal = {}
			for _, prop in ipairs(props) do
				local saved = inst:GetAttribute("ax_" .. prop)
				if saved == nil then
					saved = inst[prop]
					inst:SetAttribute("ax_" .. prop, saved)
				end
				if visible then
					inst[prop] = 1
				end
				goal[prop] = visible and saved or 1
			end
			Tween(inst, goal, duration or 0.25)
		end
	end
end

local Element = {}
Element.__index = Element

function Element:_headerHeight()
	return self._heights[(self.Desc ~= nil and self.Desc ~= "") and 2 or 1]
end

function Element:_relayout(animate)
	local h = self:_headerHeight()
	self.Header.Size = U2(1, 0, 0, h)
	self.Body.Position = Off(0, h)
	self.Body.Size = U2(1, 0, 1, -h)
	local size = U2(1, 0, 0, h + self._fixed + self._extra)
	if animate then
		Tween(self.Card, { Size = size }, 0.4)
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
	local overlay = New("TextButton", {
		Name = "Lock",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = Sc(1, 1),
		ZIndex = 10,
		Parent = self.Card,
	})
	Bind(overlay, { BackgroundColor3 = "Background" })
	Corner(overlay, 10)
	local row = New("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = V2(1, 0),
		Position = U2(1, -14, 0, 0),
		Size = U2(0, 0, 0, self._heights and self:_headerHeight() or 42),
		AutomaticSize = Enum.AutomaticSize.X,
		ZIndex = 11,
		Parent = overlay,
	})
	List(row, 6, true)
	Glyph(row, "lock", 12, "SubText", { ZIndex = 11, LayoutOrder = 1 })
	local text = AutoLabel(row, reason or "Locked", 11, Fonts.SemiBold, "SubText", 2)
	text.ZIndex = 11
	FadeTree(row, true, 0.25)
	Tween(overlay, { BackgroundTransparency = 0.3 }, 0.25)
	self._lock, self.Locked = overlay, true
end

function Element:Unlock()
	local overlay = self._lock
	if not overlay then
		return
	end
	self._lock, self.Locked = nil, false
	FadeTree(overlay, false, 0.25)
	task.delay(0.25, overlay.Destroy, overlay)
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
	local pill = New("Frame", {
		Name = "Tag",
		BackgroundTransparency = 0.86,
		Size = Off(0, large and 24 or 14),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = order or 0,
		Parent = parent,
	})
	Corner(pill, large and 7 or 4)
	Bind(pill, { BackgroundColor3 = color })
	Bind(Stroke(pill, nil, 0.6), { Color = color })
	Pad(pill, 0, 0, large and 9 or 5, large and 9 or 5)
	List(pill, large and 5 or 4, true)
	Icon(pill, data.Icon, large and 13 or 10, color, { LayoutOrder = 1 })
	AutoLabel(pill, large and tostring(data.Text) or tostring(data.Text):upper(), large and 12 or 9, large and Fonts.Medium or Fonts.Bold, color, 2)
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
		_heights = cfg.Height or { 42, 54 },
		_fixed = cfg.Fixed or 0,
		_extra = 0,
		_hover = false,
	}, Element)

	local card = New("Frame", {
		Name = cfg.Type,
		ClipsDescendants = true,
		BackgroundTransparency = primary and 0 or 0.15,
		Size = U2(1, 0, 0, 42),
		LayoutOrder = NextOrder(container),
		Parent = container.Frame,
	})
	Corner(card, 10)
	local stroke = Stroke(card)
	Bind(stroke, {
		Color = function(t)
			if primary then
				return t.Accent
			end
			return el._hover and t.Stroke:Lerp(t.Accent, 0.35) or t.Stroke
		end,
	})
	Bind(card, {
		BackgroundColor3 = function(t)
			if primary then
				return Color3.new(1, 1, 1)
			end
			return el._hover and t.ElementHover or t.Element
		end,
	})
	if primary then
		Gradient(card, 0, function(t)
			local lift = el._hover and 0.12 or 0
			return ColorSequence.new(t.AccentDark:Lerp(Color3.new(1, 1, 1), lift), t.Accent:Lerp(Color3.new(1, 1, 1), lift))
		end)
	end
	local gradient = card:FindFirstChildOfClass("UIGradient")

	local header = New("TextButton", { Name = "Header", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = U2(1, 0, 0, 42), Parent = card })
	local body = New("Frame", { Name = "Body", BackgroundTransparency = 1, Size = U2(1, 0, 1, -42), Position = Off(0, 42), Parent = card })

	local textX = 14
	if Icon(header, opts.Icon, 17, primary and "OnAccent" or "Accent", { AnchorPoint = V2(0, 0.5), Position = U2(0, 14, 0.5, 0) }) then
		textX = 42
	end

	local holder = New("Frame", {
		Name = "Text",
		BackgroundTransparency = 1,
		Position = Off(textX, 0),
		Size = U2(1, -(textX + (cfg.RightWidth or 14)), 1, 0),
		Parent = header,
	})
	List(holder, 3, false, nil, Enum.VerticalAlignment.Center)
	local titleRow = New("Frame", { Name = "TitleRow", BackgroundTransparency = 1, ClipsDescendants = true, Size = U2(1, 0, 0, 17), LayoutOrder = 1, Parent = holder })
	List(titleRow, 6, true)
	el._titleLabel = AutoLabel(titleRow, el.Title, 13, primary and Fonts.SemiBold or Fonts.Medium, primary and "OnAccent" or "Text", 1)
	for i, tag in ipairs(opts.Tags or (opts.Tag and { opts.Tag }) or {}) do
		TagPill(titleRow, tag, false, i + 1)
	end
	el._descLabel = Label({
		Name = "Desc",
		Text = el.Desc or "",
		Size = U2(1, 0, 0, 14),
		TextSize = 11,
		Truncate = Enum.TextTruncate.AtEnd,
		Color = primary and "OnAccent" or "SubText",
		Visible = el.Desc ~= nil and el.Desc ~= "",
		LayoutOrder = 2,
		Parent = holder,
	})
	if primary then
		el._descLabel.TextTransparency = 0.3
	end

	OnHover(card, function(state)
		el._hover = state
		Restyle(card, 0.2)
		Restyle(stroke, 0.2)
		if gradient then
			Restyle(gradient)
		end
	end)

	el.Card, el.Header, el.Body, el.Stroke = card, header, body, stroke
	el:_relayout(false)
	card.Visible = opts.Visible ~= false
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
	return setmetatable({ Type = kind, Card = card, Window = container.Window, _listeners = {} }, Element)
end

local function Opts(opts, callback)
	if type(opts) == "string" then
		return { Title = opts, Callback = callback }
	end
	return opts or {}
end

local function Panel(container, name, height)
	local card = New("Frame", {
		Name = name,
		BackgroundTransparency = 0.15,
		Size = U2(1, 0, 0, height or 0),
		AutomaticSize = height and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
		LayoutOrder = NextOrder(container),
		Parent = container.Frame,
	})
	Corner(card, 10)
	Stroke(card)
	Bind(card, { BackgroundColor3 = "Element" })
	return card
end

local function Separator(parent, y)
	return Bind(New("Frame", { Position = Off(14, y or 0), Size = U2(1, -28, 0, 1), Parent = parent }), { BackgroundColor3 = "Stroke" })
end

local function ValuePill(parent, height, minWidth, class)
	local pill = New(class or "Frame", {
		AnchorPoint = V2(1, 0.5),
		Position = U2(1, -14, 0.5, 0),
		Size = Off(0, height),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = parent,
	})
	if class == "TextButton" then
		pill.Text, pill.AutoButtonColor = "", false
	end
	Corner(pill, 7)
	Bind(pill, { BackgroundColor3 = "Field" })
	New("UISizeConstraint", { MinSize = V2(minWidth, height), Parent = pill })
	Pad(pill, 0, 0, 9, 9)
	List(pill, 0, true, Enum.HorizontalAlignment.Center)
	return pill, Stroke(pill)
end

local Container = {}
local ContainerMeta = { __index = Container }

function Container:Section(opts)
	if type(opts) ~= "table" then
		opts = { Title = opts }
	end
	local frame = New("Frame", {
		Name = "Section",
		BackgroundTransparency = 1,
		Size = U2(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = NextOrder(self),
		Parent = self.Frame,
	})
	List(frame, 8)
	local section = setmetatable({ Type = "Section", Frame = frame, Window = self.Window, Title = opts.Title, _order = 0 }, ContainerMeta)
	if opts.Title then
		local row = New("Frame", { Name = "SectionHeader", BackgroundTransparency = 1, Size = U2(1, 0, 0, 24), Parent = frame })
		Pad(row, 4, 0, 2, 0)
		List(row, 7, true)
		Icon(row, opts.Icon, 13, "Accent", { LayoutOrder = 1 })
		section._header = AutoLabel(row, tostring(opts.Title):upper(), 10, Fonts.Bold, "Muted", 2)
		local line = New("Frame", { Size = U2(1, 0, 0, 1), LayoutOrder = 3, Parent = row })
		New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = line })
		Bind(line, { BackgroundColor3 = "Stroke" })
		New("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = line })
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
	local scale = New("UIScale", { Parent = el.Card })
	local arrow = Glyph(el.Header, "chevron-right", 15, primary and "OnAccent" or "Muted", { AnchorPoint = V2(1, 0.5), Position = U2(1, -14, 0.5, 0) })

	function el:Fire()
		if self.Locked then
			return
		end
		Spawn(self.Callback)
		for _, fn in ipairs(self._listeners) do
			Spawn(fn)
		end
	end

	OnHover(el.Card, function(state)
		Tween(arrow, { Position = U2(1, state and -11 or -14, 0.5, 0) }, 0.25)
	end)
	el.Header.InputBegan:Connect(function(input)
		if IsClick(input) then
			Ripple(el.Card, input.Position)
			Tween(scale, { Scale = 0.985 }, 0.12)
		end
	end)
	el.Header.InputEnded:Connect(function(input)
		if IsClick(input) then
			Tween(scale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
		end
	end)
	el.Header.MouseButton1Click:Connect(function()
		el:Fire()
	end)
	return Register(el, opts)
end

function Container:Toggle(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "Toggle", RightWidth = 64 })
	el.Value = opts.Default == true or opts.Value == true

	local track = New("Frame", { Name = "Track", AnchorPoint = V2(1, 0.5), Position = U2(1, -14, 0.5, 0), Size = Off(38, 22), Parent = el.Header })
	Round(track)
	Bind(track, {
		BackgroundColor3 = function(t)
			return el.Value and t.Accent or t.Field
		end,
		BackgroundTransparency = function()
			return el.Value and 0.82 or 0
		end,
	})
	local trackStroke = Stroke(track)
	Bind(trackStroke, {
		Color = function(t)
			return el.Value and t.Accent or t.Stroke
		end,
		Transparency = function()
			return el.Value and 0.45 or 0
		end,
	})
	local knob = New("Frame", { Name = "Knob", AnchorPoint = V2(0, 0.5), Size = Off(16, 16), Parent = track })
	Round(knob)
	local knobGradient = Gradient(knob, 45)
	knobGradient.Enabled = el.Value
	Bind(knob, {
		BackgroundColor3 = function(t)
			return el.Value and Color3.new(1, 1, 1) or t.Muted
		end,
		Position = function()
			return el.Value and U2(1, -19, 0.5, 0) or U2(0, 3, 0.5, 0)
		end,
	})

	local token = 0
	function el:Set(value, silent)
		value = value == true
		local changed = value ~= self.Value
		self.Value = value
		token = token + 1
		local mine = token
		if value then
			knobGradient.Enabled = true
		else
			task.delay(0.3, function()
				if mine == token then
					knobGradient.Enabled = false
				end
			end)
		end
		RestyleAll({ track, trackStroke }, 0.25)
		Restyle(knob, 0.35)
		if changed then
			Tween(knob, { Size = Off(21, 16) }, 0.12)
			task.delay(0.12, Tween, knob, { Size = Off(16, 16) }, 0.25)
		end
		if not silent then
			self:_fire(value)
		end
	end

	el.Header.MouseButton1Click:Connect(function()
		if not el.Locked then
			el:Set(not el.Value)
		end
	end)
	return Register(el, opts)
end

function Container:Slider(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "Slider", Height = { 38, 52 }, Fixed = 20, RightWidth = 90 })
	el.Min, el.Max = opts.Min or 0, opts.Max or 100
	el.Increment = opts.Increment or opts.Rounding or 1
	el.Suffix = opts.Suffix or ""
	local decimals = Decimals(el.Increment)

	local function format(v)
		return opts.Format and opts.Format(v) or (string.format("%." .. decimals .. "f", v) .. el.Suffix)
	end

	local valueFrame, valueStroke = ValuePill(el.Header, 22, 44)
	local valueBox = New("TextBox", {
		Name = "Value",
		BackgroundTransparency = 1,
		Size = Sc(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = Fonts.SemiBold,
		TextSize = 11,
		ClearTextOnFocus = false,
		Text = "",
		Parent = valueFrame,
	})
	Bind(valueBox, { TextColor3 = "Text" })
	Bind(valueStroke, {
		Color = function(t)
			return valueBox:IsFocused() and t.Accent or t.Stroke
		end,
	})

	local bar = New("Frame", { Name = "Bar", Position = Off(14, 6), Size = U2(1, -28, 0, 4), Parent = el.Body })
	Round(bar)
	Bind(bar, { BackgroundColor3 = "Field" })
	local fill = New("Frame", { Name = "Fill", BackgroundColor3 = Color3.new(1, 1, 1), Size = Sc(0, 1), Parent = bar })
	Round(fill)
	Gradient(fill)

	local halo = New("Frame", { Name = "Halo", AnchorPoint = V2(0.5, 0.5), Position = Sc(0, 0.5), Size = Off(10, 10), BackgroundTransparency = 1, ZIndex = 2, Parent = bar })
	Round(halo)
	Bind(halo, { BackgroundColor3 = "Accent" })
	local knob = New("Frame", { Name = "Knob", AnchorPoint = V2(0.5, 0.5), Position = Sc(0, 0.5), Size = Off(12, 12), ZIndex = 3, Parent = bar })
	Round(knob)
	Bind(knob, { BackgroundColor3 = "Accent" })
	Stroke(knob, "Element").Thickness = 2
	local hit = New("TextButton", { Name = "Hit", Text = "", BackgroundTransparency = 1, AnchorPoint = V2(0, 0.5), Position = Sc(0, 0.5), Size = U2(1, 0, 0, 22), ZIndex = 4, Parent = bar })

	local hovering = false
	local function haloState(active)
		if active == "drag" then
			Tween(halo, { Size = Off(24, 24), BackgroundTransparency = 0.8 }, 0.25)
		elseif active then
			Tween(halo, { Size = Off(20, 20), BackgroundTransparency = 0.88 }, 0.25)
		else
			Tween(halo, { Size = Off(10, 10), BackgroundTransparency = 1 }, 0.3)
		end
	end
	OnHover(hit, function(state)
		hovering = state
		haloState(state)
	end)

	local dragging = false
	function el:Set(value, silent)
		value = tonumber(value) or self.Min
		local range = self.Max - self.Min
		value = math.floor((value - self.Min) / self.Increment + 0.5) * self.Increment + self.Min
		value = math.clamp(tonumber(string.format("%." .. decimals .. "f", value)), self.Min, self.Max)
		local changed = value ~= self.Value
		self.Value = value
		local alpha = range ~= 0 and (value - self.Min) / range or 0
		local speed = dragging and 0.08 or 0.35
		Tween(fill, { Size = Sc(alpha, 1) }, speed)
		Tween(knob, { Position = Sc(alpha, 0.5) }, speed)
		Tween(halo, { Position = Sc(alpha, 0.5) }, speed)
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
		if not el.Locked then
			el:Set(el.Min + (el.Max - el.Min) * x)
		end
	end, function()
		dragging = true
		haloState("drag")
		Tween(knob, { Size = Off(14, 14) }, 0.2)
	end, function()
		dragging = false
		haloState(hovering)
		Tween(knob, { Size = Off(12, 12) }, 0.3)
	end)

	valueBox.Focused:Connect(function()
		Restyle(valueStroke, 0.2)
	end)
	valueBox.FocusLost:Connect(function()
		Restyle(valueStroke, 0.2)
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
	local selected, rows = {}, {}

	local valueLabel = Label({
		Name = "Value",
		Text = "None",
		RichText = true,
		AnchorPoint = V2(1, 0.5),
		Position = U2(1, -36, 0.5, 0),
		Size = Off(150, 16),
		XAlign = Enum.TextXAlignment.Right,
		Truncate = Enum.TextTruncate.AtEnd,
		Font = Fonts.Medium,
		TextSize = 12,
		Color = "SubText",
		Parent = el.Header,
	})
	local chevron = Glyph(el.Header, "chevron-down", 14, "Muted", { AnchorPoint = V2(1, 0.5), Position = U2(1, -14, 0.5, 0) })

	local panel = New("Frame", { Name = "Panel", BackgroundTransparency = 0.2, Position = Off(10, 0), Size = U2(1, -20, 0, 0), ClipsDescendants = true, Parent = el.Body })
	Corner(panel, 9)
	Bind(panel, { BackgroundColor3 = "Field" })
	Stroke(panel, nil, 0.3)
	Pad(panel, 4, 4, 4, 4)

	local searchable = opts.Search
	if searchable == nil then
		searchable = #initialOptions > 8
	end
	local searchBox
	local listY = 0
	if searchable then
		local _, box = Field(panel, U2(1, 0, 0, 28), U2(), { Placeholder = "Search..." })
		Glyph(box.Parent, "search", 12, "Muted", { AnchorPoint = V2(1, 0.5), Position = U2(1, -9, 0.5, 0) })
		searchBox = box
		listY = 34
	end

	local list = New("ScrollingFrame", {
		Name = "List",
		BackgroundTransparency = 1,
		Position = Off(0, listY),
		Size = U2(1, 0, 0, 0),
		CanvasSize = U2(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = panel,
	})
	Bind(list, { ScrollBarImageColor3 = "Stroke" })
	List(list, 2)

	local function listHeight()
		local count = 0
		for _, row in ipairs(rows) do
			count = count + (row.Button.Visible and 1 or 0)
		end
		return math.max(math.min(count, el.MaxVisible) * 32 - 2, 0)
	end

	local function layoutList()
		local h = listHeight()
		list.Size = U2(1, 0, 0, h)
		panel.Size = U2(1, -20, 0, listY + h + 8)
		return listY + h + 8 + 10
	end

	local function updateSize()
		local extra = layoutList()
		if el.Opened then
			el._extra = extra
			el:_relayout(true)
		end
	end

	local function display()
		local values = {}
		for _, option in ipairs(el.Options) do
			if selected[option] then
				table.insert(values, option)
			end
		end
		if el.Multi then
			el.Value = values
			local shown = {}
			for i = 1, math.min(#values, 2) do
				shown[i] = tostring(values[i])
			end
			local text = table.concat(shown, ", ")
			valueLabel.Text = #values == 0 and "None" or (#values > 2 and (text .. Rich.Color("  +" .. (#values - 2), "Accent")) or text)
		else
			el.Value = values[1]
			valueLabel.Text = el.Value ~= nil and tostring(el.Value) or "None"
		end
		for _, row in ipairs(rows) do
			local on = selected[row.Option] == true
			RestyleAll({ row.Button, row.Text, row.Box, row.BoxStroke }, 0.2)

			Tween(row.Bar, { Size = on and Off(3, 14) or Off(3, 0) }, on and 0.3 or 0.25, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quint)
			Tween(row.Text, { Position = Off(on and 14 or 10, 0) }, 0.25)
		end
	end

	local function makeRow(option)
		local row = { Option = option, Hover = false }
		local on = function()
			return selected[option] == true
		end
		local button = New("TextButton", { Name = "Option", Text = "", AutoButtonColor = false, Size = U2(1, 0, 0, 30), Parent = list })
		Corner(button, 7)
		Bind(button, {
			BackgroundColor3 = "Text",
			BackgroundTransparency = function()
				return on() and 0.95 or (row.Hover and 0.97 or 1)
			end,
		})
		local bar = New("Frame", { Name = "Bar", AnchorPoint = V2(0, 0.5), Position = U2(0, 4, 0.5, 0), Size = Off(3, 0), BackgroundColor3 = Color3.new(1, 1, 1), Parent = button })
		Round(bar)
		Gradient(bar, 90)
		local text = Label({
			Text = tostring(option),
			Position = Off(10, 0),
			Size = U2(1, -44, 1, 0),
			Font = Fonts.Medium,
			TextSize = 12,
			Truncate = Enum.TextTruncate.AtEnd,
			Color = function(t)
				return on() and t.Text or (row.Hover and t.SubText or t.Muted)
			end,
			Parent = button,
		})

		local box = New("Frame", { Name = "Box", AnchorPoint = V2(1, 0.5), Position = U2(1, -8, 0.5, 0), Size = Off(16, 16), BackgroundTransparency = el.Multi and 0 or 1, Parent = button })
		Corner(box, 5)
		local boxStroke
		if el.Multi then
			Gradient(box)
			Bind(box, {
				BackgroundColor3 = function(t)
					return on() and Color3.new(1, 1, 1) or t.Field
				end,
			})
			boxStroke = Stroke(box)
			Bind(boxStroke, {
				Transparency = function()
					return on() and 1 or 0
				end,
			})
		end
		OnHover(button, function(state)
			row.Hover = state
			RestyleAll({ button, text }, 0.15)
		end)
		button.MouseButton1Click:Connect(function()
			el:_choose(option)
		end)
		row.Button, row.Text, row.Bar, row.Box, row.BoxStroke = button, text, bar, el.Multi and box or nil, boxStroke
		table.insert(rows, row)
	end

	function el:_choose(option)
		if self.Multi then
			selected[option] = not selected[option] or nil
		else
			if selected[option] then
				if not self.AllowNull then
					return self:SetOpen(false)
				end
				selected[option] = nil
			else
				table.clear(selected)
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
		local extra = layoutList()
		self._extra = state and extra or 0
		self:_relayout(true)
		Tween(chevron, { Rotation = state and 180 or 0 }, 0.35)
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
		table.clear(selected)
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
		local keep = {}
		for _, option in ipairs(self.Options) do
			if selected[option] and (self.Multi or next(keep) == nil) then
				keep[option] = true
			end
		end
		table.clear(selected)
		for k in pairs(keep) do
			selected[k] = true
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
			table.clear(selected)
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
		local index = table.find(self.Options, option)
		if index then
			table.remove(self.Options, index)
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
	local _, box = Field(el.Header, Off(width, 28), U2(1, -14, 0.5, 0), {
		AnchorPoint = V2(1, 0.5),
		Placeholder = opts.Placeholder or "Type here...",
		Text = tostring(opts.Default or opts.Value or ""),
		ClearOnFocus = opts.ClearOnFocus,
	})
	el.Value, el.TextBox = box.Text, box
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
	el.State, el.Binding = false, false
	el._onChange = opts.ChangedCallback or function() end

	local pill, pillStroke = ValuePill(el.Header, 24, 46, "TextButton")
	Bind(pillStroke, {
		Color = function(t)
			return el.Binding and t.Accent or t.Stroke
		end,
	})
	local keyLabel = AutoLabel(pill, KeyName(el.Value), 11, Fonts.SemiBold, function(t)
		return el.Binding and t.Accent or t.SubText
	end)
	keyLabel.Size = Sc(0, 1)

	local function refresh()
		keyLabel.Text = el.Binding and "..." or KeyName(el.Value)
		RestyleAll({ pillStroke, keyLabel }, 0.2)
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
			local kind = input.UserInputType
			if kind == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Escape then
					el:_cancelBinding()
				elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
					el:Set(nil)
				else
					el:Set(input.KeyCode)
				end
			elseif kind == Enum.UserInputType.MouseButton2 or kind == Enum.UserInputType.MouseButton3 then
				el:Set(kind)
			end
			return
		end
		if el.Locked or UserInputService:GetFocusedTextBox() or not KeyMatches(input, el.Value) then
			return
		end
		if el.Mode == "Toggle" then
			el.State = not el.State
			Spawn(el.Callback, el.State)
		else
			el.State = el.Mode == "Hold"
			Spawn(el.Callback, true)
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

function Container:ColorPicker(opts, callback)
	opts = Opts(opts, callback)
	local el = NewElement(self, opts, { Type = "ColorPicker", RightWidth = 70 })
	local color = opts.Default or opts.Value or Color3.new(1, 1, 1)
	local h, s, v = color:ToHSV()
	el.Value, el.Opened = color, false

	local swatch = New("Frame", { Name = "Swatch", AnchorPoint = V2(1, 0.5), Position = U2(1, -14, 0.5, 0), Size = Off(36, 20), BackgroundColor3 = color, Parent = el.Header })
	Corner(swatch, 6)
	Stroke(swatch)
	Separator(el.Body)

	local sv = New("Frame", { Name = "SaturationValue", Position = Off(14, 12), Size = U2(1, -62, 0, 120), Parent = el.Body })
	Corner(sv, 7)
	for i, data in ipairs({ { Color3.new(1, 1, 1), NumberSequence.new(0, 1), 0 }, { Color3.new(0, 0, 0), NumberSequence.new(1, 0), 90 } }) do
		local layer = New("Frame", { Name = i == 1 and "White" or "Black", BackgroundColor3 = data[1], Size = Sc(1, 1), Parent = sv })
		Corner(layer, 7)
		New("UIGradient", { Transparency = data[2], Rotation = data[3], Parent = layer })
	end
	local svCursor = New("Frame", { AnchorPoint = V2(0.5, 0.5), Size = Off(12, 12), ZIndex = 3, Parent = sv })
	Round(svCursor)
	New("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2, Parent = svCursor })
	local svHit = New("TextButton", { Text = "", BackgroundTransparency = 1, Size = Sc(1, 1), ZIndex = 4, Parent = sv })

	local hue = New("Frame", { Name = "Hue", BackgroundColor3 = Color3.new(1, 1, 1), AnchorPoint = V2(1, 0), Position = U2(1, -14, 0, 12), Size = Off(18, 120), Parent = el.Body })
	Corner(hue, 7)
	local points = {}
	for i = 0, 6 do
		points[i + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i / 6) % 1, 1, 1))
	end
	New("UIGradient", { Color = ColorSequence.new(points), Rotation = 90, Parent = hue })
	local hueCursor = New("Frame", { BackgroundColor3 = Color3.new(1, 1, 1), AnchorPoint = V2(0.5, 0.5), Size = U2(1, 4, 0, 4), ZIndex = 2, Parent = hue })
	Round(hueCursor)
	New("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.6, Parent = hueCursor })
	local hueHit = New("TextButton", { Text = "", BackgroundTransparency = 1, Size = Sc(1, 1), ZIndex = 3, Parent = hue })

	local center = { Font = Fonts.SemiBold, XAlign = Enum.TextXAlignment.Center }
	local _, hexBox = Field(el.Body, Off(96, 26), Off(14, 142), center)
	local _, rgbBox = Field(el.Body, U2(1, -124, 0, 26), Off(118, 142), center)

	local function render()
		local c = Color3.fromHSV(h, s, v)
		el.Value = c
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svCursor.Position = Sc(s, 1 - v)
		svCursor.BackgroundColor3 = c
		hueCursor.Position = Sc(0.5, h)
		Tween(swatch, { BackgroundColor3 = c }, 0.15)
		if not hexBox:IsFocused() then
			hexBox.Text = "#" .. c:ToHex():upper()
		end
		if not rgbBox:IsFocused() then
			rgbBox.Text = string.format("%d, %d, %d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
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

local function ProgressBar(parent, position, size, colorFn)
	local bar = New("Frame", { Name = "Bar", ClipsDescendants = true, Position = position, Size = size, Parent = parent })
	Round(bar)
	Bind(bar, { BackgroundColor3 = "Field" })
	local fill = New("Frame", { Name = "Fill", BackgroundColor3 = Color3.new(1, 1, 1), ClipsDescendants = true, Size = Sc(0, 1), Parent = bar })
	Round(fill)
	Gradient(fill, 0, colorFn)
	return fill, bar
end

function Container:Progress(opts)
	opts = Opts(opts)
	local el = NewElement(self, opts, { Type = "Progress", Height = { 38, 52 }, Fixed = 20, RightWidth = 100 })
	el.Max, el.Value = opts.Max or 100, 0
	local display = opts.Display or "Percent"
	local completed = false

	local valueLabel = Label({
		Name = "Value",
		AnchorPoint = V2(1, 0.5),
		Position = U2(1, -14, 0.5, 0),
		Size = Off(90, 16),
		XAlign = Enum.TextXAlignment.Right,
		Font = Fonts.SemiBold,
		TextSize = 12,
		Color = opts.Color or "Accent",
		Parent = el.Header,
	})
	local fill = ProgressBar(el.Body, Off(14, 4), U2(1, -28, 0, 6), opts.Color and function()
		return ColorSequence.new(opts.Color:Lerp(Color3.new(0, 0, 0), 0.3), opts.Color)
	end)
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
		return string.format("%d%%", math.floor((el.Max > 0 and el.Value / el.Max * 100 or 0) + 0.5))
	end

	function el:Set(value)
		value = math.clamp(tonumber(value) or 0, 0, self.Max)
		self.Value = value
		local alpha = self.Max > 0 and value / self.Max or 0
		Tween(fill, { Size = Sc(alpha, 1) }, 0.5)
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
	local count = math.max(math.min(opts.Columns or #items, #items), 1)
	local card = Panel(self, "Stats")
	Pad(card, 12, 12, 12, 12)
	List(card, 8)
	local el = Wrap(card, "Stats", self)
	el.Tiles = {}

	if opts.Title then
		el._titleLabel = Label({ Text = opts.Title, Size = U2(1, 0, 0, 16), Font = Fonts.SemiBold, TextSize = 13, Parent = card })
	end

	local rows = {}
	local function format(tile, value)
		return tile.Format and tile.Format(value) or ((tile.Prefix or "") .. tostring(value) .. (tile.Suffix or ""))
	end

	for i, item in ipairs(items) do
		local rowIndex = math.floor((i - 1) / count) + 1
		if not rows[rowIndex] then
			rows[rowIndex] = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 56), LayoutOrder = rowIndex, Parent = card })
			List(rows[rowIndex], 8, true, nil, Enum.VerticalAlignment.Top)
		end
		local tile = New("Frame", { Size = U2(1 / count, -math.ceil(8 * (count - 1) / count), 1, 0), LayoutOrder = i, Parent = rows[rowIndex] })
		Corner(tile, 8)
		Bind(tile, { BackgroundColor3 = "Field" })
		Stroke(tile, nil, 0.4)
		Pad(tile, 10, 10, 12, 12)
		Label({ Text = tostring(item.Title or item.Name or ""):upper(), Size = U2(1, 0, 0, 11), Font = Fonts.Bold, TextSize = 9, Color = "Muted", Truncate = Enum.TextTruncate.AtEnd, Parent = tile })
		local data = {
			Label = Label({ Position = Off(0, 15), Size = U2(1, 0, 0, 22), Font = Fonts.Bold, TextSize = 18, Truncate = Enum.TextTruncate.AtEnd, Color = item.Color or "Text", Parent = tile }),
			Raw = item.Value,
			Prefix = item.Prefix,
			Suffix = item.Suffix,
			Format = item.Format,
		}
		data.Label.Text = format(data, item.Value or "-")
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
			tile.Anim.Value:Destroy()
			tile.Anim = nil
		end
		if not (old and new and old ~= new and not tile.Format) then
			tile.Label.Text = format(tile, value)
			return
		end
		local places = math.max(Decimals(old), Decimals(new))
		local number = New("NumberValue", { Value = old })
		number.Changed:Connect(function(x)
			tile.Label.Text = format(tile, string.format("%." .. places .. "f", x))
		end)
		local tween = Tween(number, { Value = new }, 0.6)
		tile.Anim = { Tween = tween, Value = number }
		tween.Completed:Connect(function(state)
			if state == Enum.PlaybackState.Completed and tile.Anim and tile.Anim.Tween == tween then
				number:Destroy()
				tile.Anim = nil
				tile.Label.Text = format(tile, value)
			end
		end)
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
		Size = U2(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		RichText = true,
		TextSize = opts.TextSize or 12,
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
	local card = Panel(self, "Paragraph")
	Pad(card, 12, 12, 14, 14)
	List(card, 4)
	local el = Wrap(card, "Paragraph", self)
	el._titleLabel = Label({ Text = opts.Title or "", Size = U2(1, 0, 0, 17), Font = Fonts.SemiBold, TextSize = 13, Visible = opts.Title ~= nil, LayoutOrder = 1, Parent = card })
	local content = Label({
		Text = opts.Content or opts.Text or "",
		Size = U2(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		RichText = true,
		TextSize = 12,
		Color = "SubText",
		LayoutOrder = 2,
		Parent = card,
	})
	function el:SetContent(text)
		content.Text = tostring(text)
	end
	el.Set = el.SetContent
	function el:SetTitle(text)
		self._titleLabel.Text = text or ""
		self._titleLabel.Visible = text ~= nil
	end
	return el
end

function Container:Divider(text)
	if type(text) == "table" then
		text = text.Text or text.Title
	end
	local frame = New("Frame", { Name = "Divider", BackgroundTransparency = 1, Size = U2(1, 0, 0, text and 20 or 9), LayoutOrder = NextOrder(self), Parent = self.Frame })
	local function line(side)
		local l = New("Frame", { AnchorPoint = V2(side, 0.5), Position = Sc(side, 0.5), Size = U2(1, 0, 0, 1), Parent = frame })
		New("UIGradient", { Transparency = NumberSequence.new(side == 0 and 1 or 0, side == 0 and 0 or 1), Parent = text and l or nil })
		return Bind(l, { BackgroundColor3 = "Stroke" })
	end
	local left = line(0)
	if text then
		local right = line(1)
		local label = Label({
			Text = tostring(text):upper(),
			AnchorPoint = V2(0.5, 0.5),
			Position = Sc(0.5, 0.5),
			Size = Sc(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = Fonts.Bold,
			TextSize = 9,
			Color = "Muted",
			Parent = frame,
		})
		local function fit()
			local gap = label.AbsoluteSize.X / 2 + 10
			left.Size = U2(0.5, -gap, 0, 1)
			right.Size = U2(0.5, -gap, 0, 1)
		end
		label:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
		fit()
	end
	return Wrap(frame, "Divider", self)
end

function Container:Space(height)
	return Wrap(New("Frame", { Name = "Space", BackgroundTransparency = 1, Size = U2(1, 0, 0, height or 8), LayoutOrder = NextOrder(self), Parent = self.Frame }), "Space", self)
end

function Container:Tags(opts)
	opts = opts or {}
	local frame = New("Frame", { Name = "Tags", BackgroundTransparency = 1, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = NextOrder(self), Parent = self.Frame })
	List(frame, 6, true).Wraps = true
	local el = Wrap(frame, "Tags", self)
	el.Items = {}
	local order = 0

	function el:Add(tag, instant)
		order = order + 1
		local pill = TagPill(frame, tag, true, order)
		table.insert(self.Items, { Text = type(tag) == "table" and tag.Text or tostring(tag), Pill = pill })
		if not instant then
			Tween(New("UIScale", { Scale = 0.6, Parent = pill }), { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
		end
		return pill
	end

	function el:Remove(text)
		for i, item in ipairs(self.Items) do
			if item.Text == text then
				table.remove(self.Items, i)
				Tween(New("UIScale", { Parent = item.Pill }), { Scale = 0 }, 0.2)
				task.delay(0.2, item.Pill.Destroy, item.Pill)
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

	for _, tag in ipairs(opts.Tags or opts) do
		el:Add(tag, true)
	end
	return el
end

local LogKinds = { Log = "SubText", Info = "Accent", Success = "Success", Warn = "Warning", Warning = "Warning", Error = "Error", Debug = "Muted" }

local function SmallButton(parent, text, icon, xOffset)
	local hover = false
	local button = New("TextButton", { Text = "", AutoButtonColor = false, AnchorPoint = V2(1, 0.5), Position = U2(1, xOffset, 0.5, 0), Size = Off(0, 24), AutomaticSize = Enum.AutomaticSize.X, Parent = parent })
	Corner(button, 7)
	Pad(button, 0, 0, 9, 10)
	List(button, 5, true)
	Stroke(button)
	local color = function(t)
		return hover and t.Text or t.SubText
	end
	local glyph = Glyph(button, icon, 12, color, { LayoutOrder = 1 })
	local label = AutoLabel(button, text, 11, Fonts.SemiBold, color, 2)
	Bind(button, {
		BackgroundColor3 = function(t)
			return hover and t.ElementHover or t.Field
		end,
	})
	OnHover(button, function(state)
		hover = state
		RestyleAll({ button, label, glyph:FindFirstChildWhichIsA("GuiObject") }, 0.15)
	end)
	return button
end

local function Copy(text, message)
	if type(setclipboard) ~= "function" then
		Axivex:Toast({ Text = "Clipboard isn't available here", Type = "Error" })
		return false
	end
	pcall(setclipboard, text)
	Axivex:Toast({ Text = message or "Copied to clipboard", Type = "Success" })
	return true
end

function Container:Console(opts)
	opts = opts or {}
	local height = opts.Height or 200
	local card = Panel(self, "Console", 52 + height)
	local el = Wrap(card, "Console", self)
	el.Lines, el.MaxLines, el.Prefix, el.Timestamps = {}, opts.MaxLines or 200, opts.Prefix, opts.Timestamps ~= false

	local header = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 42), Parent = card })
	local titleRow = New("Frame", { BackgroundTransparency = 1, Position = Off(14, 0), Size = U2(1, -180, 1, 0), Parent = header })
	List(titleRow, 8, true)
	Glyph(titleRow, "terminal", 14, "Accent", { LayoutOrder = 1 })
	el._titleLabel = AutoLabel(titleRow, opts.Title or "Console", 13, Fonts.SemiBold, "Text", 2)
	local clearButton = SmallButton(header, "Clear", "trash-2", -12)
	local copyButton = SmallButton(header, "Copy", "copy", -84)

	local scroller = New("ScrollingFrame", {
		Name = "Output",
		Position = Off(10, 42),
		Size = U2(1, -20, 0, height),
		CanvasSize = U2(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = card,
	})
	Corner(scroller, 8)
	Stroke(scroller, nil, 0.3)
	Bind(scroller, { BackgroundColor3 = "Field", ScrollBarImageColor3 = "Stroke" })
	Pad(scroller, 8, 8, 8, 8)
	List(scroller, 4)
	local empty = Label({ Text = opts.Placeholder or "Nothing logged yet.", Size = U2(1, 0, 0, height - 16), XAlign = Enum.TextXAlignment.Center, TextSize = 12, Color = "Muted", Parent = scroller })

	local order = 0
	function el:Log(text, kind)
		kind = kind or "Log"
		local theme = Axivex.Theme
		local parts = {}
		if self.Timestamps then
			table.insert(parts, Rich.Color(os.date("%H:%M:%S"), theme.Muted))
		end
		table.insert(parts, Rich.Color(self.Prefix or ("[" .. kind:lower() .. "]"), theme[LogKinds[kind] or "SubText"]))
		table.insert(parts, Rich.Color(tostring(text), theme.Text))
		local line = table.concat(parts, " ")
		local plain = Rich.Strip(line)

		empty.Visible = false
		local atBottom = scroller.CanvasPosition.Y >= scroller.AbsoluteCanvasSize.Y - scroller.AbsoluteWindowSize.Y - 24
		order = order + 1
		local hover = false
		local chip = New("TextButton", { Name = "Line", Text = "", AutoButtonColor = false, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = order, Parent = scroller })
		Corner(chip, 6)
		Bind(chip, {
			BackgroundColor3 = function(t)
				return hover and t.ElementHover or t.Element
			end,
		})
		local chipStroke = Stroke(chip, nil, 1)
		OnHover(chip, function(state)
			hover = state
			Restyle(chip, 0.15)
		end)
		chip.MouseButton1Click:Connect(function()
			if Copy(plain) then
				chipStroke.Color = Axivex.Theme.Accent
				task.delay(0.8, Restyle, chipStroke, 0.4)
			end
		end)
		Pad(chip, 5, 5, 9, 9)
		local label = Label({ Text = line, RichText = true, Wrapped = true, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextSize = 11, Font = Fonts.Medium, Parent = chip })
		label.TextTransparency = 1
		Tween(chip, { BackgroundTransparency = 0 }, 0.3)
		Tween(chipStroke, { Transparency = 0 }, 0.3)
		Tween(label, { TextTransparency = 0 }, 0.3)

		table.insert(self.Lines, { Text = plain, Frame = chip })
		while #self.Lines > self.MaxLines do
			table.remove(self.Lines, 1).Frame:Destroy()
		end
		if atBottom then
			task.delay(0.05, function()
				Tween(scroller, { CanvasPosition = V2(0, math.max(0, scroller.AbsoluteCanvasSize.Y - scroller.AbsoluteWindowSize.Y)) }, 0.3)
			end)
		end
		return chip
	end

	for _, kind in ipairs({ "Info", "Success", "Warn", "Error", "Debug" }) do
		el[kind] = function(self, text)
			return self:Log(text, kind)
		end
	end

	function el:Print(...)
		local args = table.pack(...)
		for i = 1, args.n do
			args[i] = tostring(args[i])
		end
		return self:Log(table.concat(args, " ", 1, args.n), "Log")
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
		Copy(el:GetText(), "Console copied")
	end)
	return el
end

function Container:Changelog(entries)
	entries = entries.Entries or entries
	local el = Wrap(nil, "Changelog", self)
	el.Cards = {}
	for _, entry in ipairs(entries) do
		local card = Panel(self, "Entry")
		Pad(card, 12, 12, 14, 14)
		List(card, 6)
		local header = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 18), LayoutOrder = 1, Parent = card })
		local left = New("Frame", { BackgroundTransparency = 1, Size = U2(1, entry.Date and -90 or 0, 1, 0), Parent = header })
		List(left, 8, true)
		AutoLabel(left, tostring(entry.Title or ""), 13, Fonts.Bold, "Text", 1)
		if entry.Tag then
			TagPill(left, entry.Tag, false, 2)
		end
		if entry.Date then
			Label({ Text = tostring(entry.Date), AnchorPoint = V2(1, 0), Position = Sc(1, 0), Size = U2(0, 90, 1, 0), XAlign = Enum.TextXAlignment.Right, TextSize = 11, Color = "Muted", Parent = header })
		end
		for i, change in ipairs(entry.Changes or { entry.Content }) do
			local row = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1 + i, Parent = card })
			local bullet = entry.Changes ~= nil
			if bullet then
				Bind(Round(New("Frame", { Position = Off(2, 6), Size = Off(5, 5), Parent = row })).Parent, { BackgroundColor3 = "Accent" })
			end
			Label({
				Text = tostring(change),
				Position = Off(bullet and 15 or 0, 0),
				Size = U2(1, bullet and -15 or 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Wrapped = true,
				RichText = true,
				TextSize = 12,
				YAlign = Enum.TextYAlignment.Top,
				Color = "SubText",
				Parent = row,
			})
		end
		table.insert(el.Cards, card)
	end
	el.Card = el.Cards[1]
	function el:SetVisible(visible)
		for _, card in ipairs(self.Cards) do
			card.Visible = visible
		end
	end
	function el:Destroy()
		for _, card in ipairs(self.Cards) do
			card:Destroy()
		end
	end
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
local TypeIcons = { Info = "sparkles", Success = "circle-check", Warning = "triangle-alert", Error = "circle-x" }

local function EnsureNotifyGui()
	if NotifyGui and NotifyGui.Parent then
		return
	end
	NotifyGui = New("ScreenGui", { Name = "AxivexNotifications", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000 })
	ParentGui(NotifyGui)
	NotifyHolder = New("Frame", { Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = V2(1, 1), Position = U2(1, -18, 1, -10), Size = U2(0, 300, 1, -28), Parent = NotifyGui })
	List(NotifyHolder, 0, false, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
	ToastHolder = New("Frame", { Name = "Toasts", BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0), Position = U2(0.5, 0, 0, 14), Size = U2(0, 600, 1, -28), Parent = NotifyGui })
	for _, holder in ipairs({ NotifyHolder, ToastHolder }) do
		New("UIScale", { Name = "AxivexScale", Scale = Axivex.UIScale or 1, Parent = holder })
	end
	List(ToastHolder, 0, false, Enum.HorizontalAlignment.Center)
end

local function TypeColor(typeKey, custom)
	return function(t)
		return custom or t[typeKey]
	end
end

local function TypeGradient(typeKey, custom)
	return function(t)
		if custom then
			return ColorSequence.new(custom:Lerp(Color3.new(0, 0, 0), 0.3), custom)
		elseif typeKey == "Accent" then
			return ColorSequence.new(t.AccentDark, t.Accent)
		end
		return ColorSequence.new(t[typeKey]:Lerp(Color3.new(0, 0, 0), 0.3), t[typeKey])
	end
end

local function Slot(parent, order)
	local holder = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 0), LayoutOrder = order, Parent = parent })
	local canvas = New("CanvasGroup", { BackgroundTransparency = 1, GroupTransparency = 1, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = holder })
	Pad(canvas, 2, 2, 2, 2)
	return holder, canvas
end

function Axivex:Notify(opts, content, duration)
	if type(opts) ~= "table" then
		opts = { Title = tostring(opts), Content = content, Duration = duration }
	end
	EnsureNotifyGui()
	local typeKey = TypeKeys[opts.Type or "Info"] or "Accent"
	local color = TypeColor(typeKey, opts.Color)
	local n = { Closed = false }
	NotifyOrder = NotifyOrder + 1

	local holder, canvas = Slot(NotifyHolder, NotifyOrder)
	canvas.Position = Off(40, 0)
	local body = New("Frame", { Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = canvas })
	Bind(body, { BackgroundColor3 = "Background" })
	Corner(body, 12)
	Bind(Stroke(body, nil, 0.75), { Color = color })
	Pad(body, 12, 13, 14, 14)
	List(body, 6)

	local closable = opts.Closable ~= false and opts.Dismissable ~= false
	local closeWidth = closable and 22 or 0

	local top = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 13), LayoutOrder = 1, Visible = opts.Label ~= nil or opts.Status ~= nil, Parent = body })
	local dot = New("Frame", { AnchorPoint = V2(0, 0.5), Position = Sc(0, 0.5), Size = Off(6, 6), Parent = top })
	Round(dot)
	Bind(dot, { BackgroundColor3 = color })
	Tween(dot, { BackgroundTransparency = 0.6 }, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true))
	local labelText = Label({ Text = tostring(opts.Label or ""):upper(), Position = Off(13, 0), Size = U2(1, -110, 1, 0), Font = Fonts.Bold, TextSize = 9, Truncate = Enum.TextTruncate.AtEnd, Color = "SubText", Parent = top })
	local statusText = Label({ Text = tostring(opts.Status or ""):upper(), AnchorPoint = V2(1, 0), Position = U2(1, -closeWidth, 0, 0), Size = U2(0, 96, 1, 0), XAlign = Enum.TextXAlignment.Right, Font = Fonts.Bold, TextSize = 9, Color = color, Parent = top })

	local titleRow = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 18), LayoutOrder = 2, Parent = body })
	local iconWidth = Icon(titleRow, opts.Icon, 16, color, { AnchorPoint = V2(0, 0.5), Position = Sc(0, 0.5) }) and 22 or 0
	local titleText = Label({ Text = opts.Title or "Notification", Position = Off(iconWidth, 0), Font = Fonts.SemiBold, TextSize = 14, Truncate = Enum.TextTruncate.AtEnd, Parent = titleRow })
	local counter = Label({ Text = "", AnchorPoint = V2(1, 0), Size = U2(0, 64, 1, 0), XAlign = Enum.TextXAlignment.Right, Font = Fonts.SemiBold, TextSize = 11, Color = color, Parent = titleRow })
	local function layoutTitleRow()
		local reserve = (closable and not top.Visible) and closeWidth or 0
		counter.Position = U2(1, -reserve, 0, 0)
		titleText.Size = U2(1, -(reserve + 64 + iconWidth), 1, 0)
	end
	layoutTitleRow()

	if closable then
		local hover = false
		local close = New("TextButton", { Name = "Close", Text = "", AutoButtonColor = false, AnchorPoint = V2(1, 0), Position = U2(1, -9, 0, 8), Size = Off(20, 20), ZIndex = 2, Parent = canvas })
		Corner(close, 6)
		Bind(close, {
			BackgroundColor3 = "Element",
			BackgroundTransparency = function()
				return hover and 0 or 1
			end,
		})
		local glyph = Glyph(close, "x", 12, function(t)
			return hover and t.Text or t.Muted
		end, { AnchorPoint = V2(0.5, 0.5), Position = Sc(0.5, 0.5) })
		OnHover(close, function(state)
			hover = state
			RestyleAll({ close, glyph:FindFirstChildWhichIsA("GuiObject") }, 0.15)
		end)
		close.MouseButton1Click:Connect(function()
			n:Close()
		end)
	end

	local contentText = Label({
		Text = opts.Content or opts.Text or "",
		Size = U2(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		RichText = true,
		TextSize = 12,
		Color = "SubText",
		Visible = (opts.Content or opts.Text) ~= nil,
		LayoutOrder = 3,
		Parent = body,
	})
	local barWrap = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 12), LayoutOrder = 4, Visible = false, Parent = body })
	local fill = ProgressBar(barWrap, Off(0, 4), U2(1, 0, 0, 5), TypeGradient(typeKey, opts.Color))
	Shimmer(fill)
	local footer = Label({ Text = opts.Footer or "", Size = U2(1, 0, 0, 14), TextSize = 10, Color = "Muted", Truncate = Enum.TextTruncate.AtEnd, Visible = opts.Footer ~= nil, LayoutOrder = 5, Parent = body })
	local timerWrap = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 3), LayoutOrder = 6, Visible = false, Parent = body })
	local timerFill = ProgressBar(timerWrap, U2(), Sc(1, 1), TypeGradient(typeKey, opts.Color))

	canvas:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if not n.Closed then
			Tween(holder, { Size = U2(1, 0, 0, canvas.AbsoluteSize.Y + 8) }, 0.35)
		end
	end)

	function n:Close()
		if self.Closed then
			return
		end
		self.Closed = true
		local index = table.find(ActiveNotifications, self)
		if index then
			table.remove(ActiveNotifications, index)
		end
		Tween(canvas, { Position = Off(40, 0), GroupTransparency = 1 }, 0.3)
		task.delay(0.15, Tween, holder, { Size = U2(1, 0, 0, 0) }, 0.35)
		task.delay(0.55, holder.Destroy, holder)
		Spawn(opts.OnClose)
	end

	function n:SetProgress(value, max)
		max = max or self.Max or 100
		self.Max, self.Value = max, value
		barWrap.Visible, timerWrap.Visible = true, false
		Tween(fill, { Size = Sc(max > 0 and math.clamp(value / max, 0, 1) or 0, 1) }, 0.5)
		counter.Text = string.format("%s/%s", tostring(value), tostring(max))
	end

	local timerToken = 0
	function n:SetDuration(seconds)
		timerToken = timerToken + 1
		local token = timerToken
		if not seconds or seconds <= 0 then
			timerWrap.Visible = false
			return
		end
		if not barWrap.Visible then
			timerWrap.Visible = true
			timerFill.Size = Sc(1, 1)
			Tween(timerFill, { Size = Sc(0, 1) }, seconds, Enum.EasingStyle.Linear)
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
			footer.Text, footer.Visible = update.Footer, true
		end
		if update.Progress then
			self:SetProgress(update.Progress[1] or update.Progress.Value, update.Progress[2] or update.Progress.Max)
		end
		if update.Duration ~= nil then
			self:SetDuration(update.Duration)
		end
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
		Tween(holder, { Size = U2(1, 0, 0, canvas.AbsoluteSize.Y + 8) }, 0.35)
		Tween(canvas, { Position = Off(0, 0), GroupTransparency = 0 }, 0.5)
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
	local typeKey = TypeKeys[opts.Type or "Info"] or "Accent"
	local color = TypeColor(typeKey, opts.Color)
	local content = opts.Content or opts.Desc
	local height = content and 50 or 38

	local holder, canvas = Slot(ToastHolder, NotifyOrder)
	canvas.AnchorPoint = V2(0.5, 0)
	canvas.Position = U2(0.5, 0, 0, -14)
	canvas.Size = Off(0, height + 4)
	canvas.AutomaticSize = Enum.AutomaticSize.X
	local scale = New("UIScale", { Scale = 0.9, Parent = canvas })
	local body = New("Frame", { Size = Off(0, height), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 0.05, Parent = canvas })
	Bind(body, { BackgroundColor3 = "Sidebar" })
	Corner(body, 11)
	Bind(Stroke(body, nil, 0.7), { Color = color })
	Pad(body, 0, 0, 13, 17)
	List(body, 10, true)

	local icon = Icon(body, opts.Icon or TypeIcons[opts.Type or "Info"] or "sparkles", 15, color, { LayoutOrder = 1 })
	if not icon then
		local dot = New("Frame", { Size = Off(7, 7), LayoutOrder = 1, Parent = body })
		Round(dot)
		Bind(dot, { BackgroundColor3 = color })
	end
	Bind(New("Frame", { Size = Off(1, 16), LayoutOrder = 2, Parent = body }), { BackgroundColor3 = "Stroke" })
	local textArea = New("Frame", { BackgroundTransparency = 1, Size = Sc(0, 1), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 3, Parent = body })
	List(textArea, 1, false, nil, Enum.VerticalAlignment.Center)
	Label({ Text = opts.Text or opts.Title or "", Size = Off(0, 16), AutomaticSize = Enum.AutomaticSize.X, Font = Fonts.SemiBold, TextSize = 12, LayoutOrder = 1, Parent = textArea })
	if content then
		Label({ Text = content, Size = Off(0, 14), AutomaticSize = Enum.AutomaticSize.X, TextSize = 11, Color = "SubText", LayoutOrder = 2, Parent = textArea })
	end

	local timer = New("Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.4, AnchorPoint = V2(0, 1), Position = U2(0, 12, 1, -1), Size = Off(0, 2), Parent = canvas })
	Round(timer)
	Gradient(timer, 0, TypeGradient(typeKey, opts.Color))
	task.defer(function()
		timer.Size = Off(math.max(body.AbsoluteSize.X - 24, 0), 2)
		Tween(timer, { Size = Off(0, 2) }, duration, Enum.EasingStyle.Linear)
	end)

	Tween(holder, { Size = U2(1, 0, 0, height + 10) }, 0.35)
	Tween(canvas, { Position = U2(0.5, 0, 0, 0), GroupTransparency = 0 }, 0.45)
	Tween(scale, { Scale = 1 }, 0.5, Enum.EasingStyle.Back)

	local toast = { Closed = false }
	function toast:Close()
		if self.Closed then
			return
		end
		self.Closed = true
		Tween(canvas, { Position = U2(0.5, 0, 0, -14), GroupTransparency = 1 }, 0.3)
		Tween(scale, { Scale = 0.9 }, 0.3)
		task.delay(0.15, Tween, holder, { Size = U2(1, 0, 0, 0) }, 0.3)
		task.delay(0.5, holder.Destroy, holder)
	end
	task.delay(duration, toast.Close, toast)
	return toast
end

local Window = {}
Window.__index = Window

local Tab, Page = {}, {}
local TabMeta = {
	__index = function(_, key)
		return Tab[key] or Container[key]
	end,
}
local PageMeta = {
	__index = function(_, key)
		return Page[key] or Container[key]
	end,
}

local TAB_HEIGHT, TAB_GAP, TAB_LABEL = 34, 3, 24

local function SafeName(name)
	return (tostring(name):gsub("[^%w%-_ ]", ""))
end

local Live = { FPS = 0 }
local function StartCounter()
	if Live.Running then
		return
	end
	Live.Running = true
	local frames, last = 0, os.clock()
	Connect(RunService.RenderStepped, function()
		frames = frames + 1
		local now = os.clock()
		if now - last >= 1 then
			Live.FPS = math.floor(frames / (now - last) + 0.5)
			frames, last = 0, now
		end
	end)
end

local function Ping()
	return math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)
end

local StatusItems = {
	FPS = { Icon = "monitor", Unit = "FPS", Width = 50, Get = function() return Live.FPS end },
	Ping = { Icon = "wifi", Unit = "ms", Width = 40, Get = Ping },
	Player = { Icon = "user", Get = function() return LocalPlayer.Name end },
	Time = { Icon = "clock", Get = function() return os.date("%H:%M") end },
	Players = { Icon = "users", Get = function() return #Players:GetPlayers() .. "/" .. Players.MaxPlayers end },
}

local Brand = ColorSequence.new({
	ColorSequenceKeypoint.new(0, C(91, 190, 91)),
	ColorSequenceKeypoint.new(0.32, C(52, 146, 213)),
	ColorSequenceKeypoint.new(0.5, C(140, 106, 179)),
	ColorSequenceKeypoint.new(0.68, C(232, 71, 140)),
	ColorSequenceKeypoint.new(0.86, C(245, 122, 80)),
	ColorSequenceKeypoint.new(1, C(254, 161, 32)),
})
Axivex.BrandGradient = Brand

local function Badge(parent, title, icon, size, position, anchor)
	local props = { Name = "Logo", AnchorPoint = anchor or Vector2.zero, Position = position }
	local logo = Icon(parent, icon, size, "Accent", props) or Icon(parent, icon == nil and "logo" or nil, size, Color3.new(1, 1, 1), props)
	if logo then
		return logo
	end
	logo = New("Frame", { Name = "Logo", BackgroundColor3 = Color3.new(1, 1, 1), AnchorPoint = anchor or Vector2.zero, Position = position, Size = Off(size, size), Parent = parent })
	Corner(logo, math.floor(size * 0.25))
	New("UIGradient", { Color = Brand, Rotation = 45, Parent = logo })
	Label({ Text = tostring(title):sub(1, 1):upper(), XAlign = Enum.TextXAlignment.Center, Font = Fonts.Bold, TextSize = math.floor(size * 0.5), Color = Color3.new(1, 1, 1), Parent = logo })
	return logo
end

local function LoadAvatar(userId, onLoaded)
	task.spawn(function()
		local image
		if Axivex.Secure then
			local path = Axivex.Folder .. "/cache/avatar-" .. tostring(userId) .. ".png"
			local ok, cached = pcall(isfile, path)
			if ok and cached then
				image = Axivex:CustomAsset(path)
			else
				local okUrl, url = pcall(function()
					local body = game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(userId) .. "&size=150x150&format=Png&isCircular=false")
					return HttpService:JSONDecode(body).data[1].imageUrl
				end)
				if okUrl and type(url) == "string" then
					image = Axivex:CustomAsset(path, url)
				end
			end
		else
			local ok, result = pcall(Players.GetUserThumbnailAsync, Players, userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			image = ok and result or nil
		end
		if image then
			onLoaded(image)
		end
	end)
end

local function Avatar(parent, size, props, noPhoto)
	local name = LocalPlayer and LocalPlayer.DisplayName or "?"
	local avatar = New("ImageLabel", { Name = "Avatar", BackgroundColor3 = Color3.new(1, 1, 1), Size = Off(size, size), Parent = parent })
	for k, v in pairs(props or {}) do
		avatar[k] = v
	end
	Round(avatar)
	local gradient = Gradient(avatar, 45)
	local initial = Label({ Text = name:sub(1, 1):upper(), XAlign = Enum.TextXAlignment.Center, Font = Fonts.Bold, TextSize = math.floor(size * 0.45), Color = "OnAccent", Parent = avatar })
	if LocalPlayer and not noPhoto then
		LoadAvatar(LocalPlayer.UserId, function(image)
			if avatar.Parent then
				avatar.Image = image
				initial.Visible = false
				gradient.Enabled = false
				Bind(avatar, { BackgroundColor3 = "Field" })
			end
		end)
	end
	return avatar
end

local function IconButton(parent, glyph, order, hoverKey)
	local hover = false
	local button = New("TextButton", { Name = glyph, Text = "", AutoButtonColor = false, Size = Off(28, 28), LayoutOrder = order, Parent = parent })
	Corner(button, 8)
	Bind(button, {
		BackgroundColor3 = "Element",
		BackgroundTransparency = function()
			return hover and 0 or 1
		end,
	})
	local icon = Glyph(button, glyph, 15, function(t)
		return hover and t[hoverKey or "Text"] or t.SubText
	end, { AnchorPoint = V2(0.5, 0.5), Position = Sc(0.5, 0.5) })
	OnHover(button, function(state)
		hover = state
		RestyleAll({ button, icon:FindFirstChildWhichIsA("GuiObject") }, 0.15)
	end)
	return button
end

local function CreateLoader(window, opts)
	local loader = { Progress = 0, Finished = false }
	local invite = opts.Discord or Axivex.Discord
	window._loading = true

	local root = New("Frame", { Name = "Loader", BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = Sc(0.5, 0.5), Size = Off(opts.Width or 390, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = window.Gui })
	window._loaderScale = New("UIScale", { Scale = window.Scale, Parent = root })
	List(root, 10)
	local glow = Glow(window.Gui, "AccentDark", V2(640, 420), Sc(0.5, 0.5), 0)
	local cards = {}

	local function card(order, class)
		local canvas = New("CanvasGroup", { BackgroundTransparency = 1, GroupTransparency = 1, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order, Parent = root })
		Pad(canvas, 2, 2, 2, 2)
		local scale = New("UIScale", { Scale = 0.94, Parent = canvas })
		local body = New(class or "Frame", { Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = canvas })
		if class == "TextButton" then
			body.Text, body.AutoButtonColor = "", false
		end
		Corner(body, 14)
		Bind(body, { BackgroundColor3 = "Background" })
		table.insert(cards, { Canvas = canvas, Scale = scale })
		return body
	end

	local main = card(1)
	Stroke(main, "Accent", 0.8)
	Pad(main, 18, 18, 18, 18)
	List(main, 14)
	local head = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 38), LayoutOrder = 1, Parent = main })
	Badge(head, window.Title, opts.Icon or window.Icon, 38, U2(0, 0, 0.5, 0), V2(0, 0.5))
	Label({ Text = opts.Title or window.Title, Position = Off(50, 1), Size = U2(1, -90, 0, 20), Font = Fonts.Bold, TextSize = 16, Truncate = Enum.TextTruncate.AtEnd, Parent = head })
	Label({ Text = window.Subtitle, Position = Off(50, 21), Size = U2(1, -90, 0, 15), TextSize = 11, Truncate = Enum.TextTruncate.AtEnd, Color = "SubText", Parent = head })
	local close = IconButton(head, "x", 0, "Error")
	close.AnchorPoint, close.Position = V2(1, 0.5), U2(1, 0, 0.5, 0)
	Label({ Text = opts.PromptText or Axivex.LoaderMessage, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Wrapped = true, RichText = true, TextSize = 12, Color = "SubText", LayoutOrder = 2, Parent = main })

	local status, fill
	if opts.Manual then
		local wrap = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 30), LayoutOrder = 3, Parent = main })
		status = Label({ Text = opts.Status or "Loading...", Size = U2(1, 0, 0, 14), Font = Fonts.Medium, TextSize = 11, Color = "SubText", Parent = wrap })
		fill = ProgressBar(wrap, Off(0, 22), U2(1, 0, 0, 6))
		Shimmer(fill)
	else
		local hover = false
		local row = New("TextButton", { Name = "Load", Text = "", AutoButtonColor = false, Size = U2(1, 0, 0, 46), LayoutOrder = 3, Parent = main })
		Corner(row, 10)
		Bind(row, {
			BackgroundColor3 = "Accent",
			BackgroundTransparency = function()
				return hover and 0.88 or 0.94
			end,
		})
		local rowStroke = Stroke(row, "Accent")
		Bind(rowStroke, {
			Transparency = function()
				return hover and 0.35 or 0.75
			end,
		})
		Pad(row, 0, 0, 10, 14)
		List(row, 10, true)
		local box = New("Frame", { Size = Off(26, 26), BackgroundTransparency = 0.84, LayoutOrder = 1, Parent = row })
		Corner(box, 7)
		Bind(box, { BackgroundColor3 = "Accent" })
		Glyph(box, "log-in", 14, "Accent", { AnchorPoint = V2(0.5, 0.5), Position = Sc(0.5, 0.5) })
		AutoLabel(row, opts.LoadText or "Load", 13, Fonts.SemiBold, "Text", 2)
		AutoLabel(row, opts.LoadTag or "Click to Load", 11, Fonts.Medium, "Accent", 3)
		local spacer = New("Frame", { BackgroundTransparency = 1, Size = Off(0, 1), LayoutOrder = 4, Parent = row })
		New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = spacer })
		local arrow = Glyph(row, "chevron-right", 15, "Accent", { LayoutOrder = 5 })
		OnHover(row, function(state)
			hover = state
			RestyleAll({ row, rowStroke }, 0.2)
			Tween(arrow, { Rotation = 0, Size = state and Off(17, 17) or Off(15, 15) }, 0.2)
		end)
		row.MouseButton1Click:Connect(function()
			loader:Finish()
		end)
	end

	if invite then
		local hover = false
		local blurple = Color3.fromRGB(88, 101, 242)
		local discord = card(2, "TextButton")
		local stroke = New("UIStroke", { Color = blurple, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Transparency = 0.6, Parent = discord })
		Pad(discord, 13, 13, 14, 16)
		List(discord, 12, true)
		local box = New("Frame", { Size = Off(38, 38), BackgroundColor3 = blurple, BackgroundTransparency = 0.84, LayoutOrder = 1, Parent = discord })
		Corner(box, 10)
		Glyph(box, "discord", 18, blurple, { AnchorPoint = V2(0.5, 0.5), Position = Sc(0.5, 0.5) })
		local text = New("Frame", { BackgroundTransparency = 1, Size = U2(1, -80, 0, 34), LayoutOrder = 2, Parent = discord })
		List(text, 3, false, nil, Enum.VerticalAlignment.Center)
		local top = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 16), Parent = text })
		List(top, 6, true)
		AutoLabel(top, "Join our Discord", 13, Fonts.SemiBold, "Text", 1)
		AutoLabel(top, "·", 13, Fonts.Bold, "Muted", 2)
		AutoLabel(top, opts.DiscordTag or "Click to Copy", 11, Fonts.Medium, blurple, 3)
		Label({ Text = opts.DiscordText or "Updates, support and feature requests", Size = U2(1, 0, 0, 14), TextSize = 11, Color = "SubText", Truncate = Enum.TextTruncate.AtEnd, LayoutOrder = 2, Parent = text })
		Glyph(discord, "chevron-right", 15, "Muted", { LayoutOrder = 3 })
		OnHover(discord, function(state)
			hover = state
			Tween(stroke, { Transparency = hover and 0.15 or 0.6 }, 0.2)
		end)
		discord.MouseButton1Click:Connect(function()
			if type(setclipboard) == "function" then
				pcall(setclipboard, invite)
				Axivex:Toast({ Text = "Discord invite copied", Type = "Info", Color = blurple, Icon = "discord" })
			else
				Axivex:Toast({ Text = "Clipboard isn't available here", Type = "Error" })
			end
		end)
	end

	close.MouseButton1Click:Connect(function()
		Axivex:Unload()
	end)

	function loader:Set(progress, text)
		self.Progress = math.clamp(tonumber(progress) or 0, 0, 1)
		if fill then
			Tween(fill, { Size = Sc(self.Progress, 1) }, 0.45)
		end
		if text and status then
			status.Text = text
		end
	end

	function loader:Finish()
		if self.Finished then
			return
		end
		self.Finished = true
		self:Set(1)
		task.delay(fill and 0.5 or 0, function()
			for i, c in ipairs(cards) do
				task.delay((i - 1) * 0.05, function()
					Tween(c.Canvas, { GroupTransparency = 1 }, 0.3)
					Tween(c.Scale, { Scale = 0.95 }, 0.3)
				end)
			end
			FadeTree(glow, false, 0.4)
			task.delay(0.22, function()
				window._loading = false
				window:SetVisible(true)
			end)
			task.delay(0.5, function()
				root:Destroy()
				glow:Destroy()
			end)
		end)
	end

	for _, layer in ipairs(glow:GetChildren()) do
		Tween(layer, { BackgroundTransparency = 0.985 }, 0.6)
	end
	for i, c in ipairs(cards) do
		task.delay(0.05 + (i - 1) * 0.08, function()
			Tween(c.Canvas, { GroupTransparency = 0 }, 0.45)
			Tween(c.Scale, { Scale = 1 }, 0.55, Enum.EasingStyle.Back)
		end)
	end
	return loader
end

function Axivex:CreateWindow(opts)
	opts = opts or {}
	if opts.Theme then
		self:SetTheme(opts.Theme)
	end
	StartCounter()
	self:PreloadIcons({ "chevron-right", "chevron-down", "x", "minus", "check", "log-in", "discord", "monitor", "wifi", "user", "clock", "sparkles", "circle-check", "triangle-alert", "circle-x", "lock", "search", "copy", "trash-2" })

	local window = setmetatable({
		Title = opts.Title or "Axivex",
		Subtitle = opts.Subtitle or ("v" .. Axivex.Version),
		Icon = opts.Icon,
		Tabs = {},
		Visible = false,
		ToggleKey = ParseKey(opts.ToggleKey) or Enum.KeyCode.RightShift,
		AutoSave = opts.AutoSave,
		MinSize = opts.MinSize or V2(560, 360),
		_switch = 0,
	}, Window)
	window._configDir = Axivex.Folder .. "/" .. SafeName(opts.ConfigFolder or window.Title) .. "/configs"

	local gui = New("ScreenGui", { Name = "Axivex", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100 })
	ParentGui(gui)
	local size = opts.Size or Off(680, 460)
	local function fitScale()
		if opts.Scale then
			return opts.Scale
		end
		local camera = workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or V2(1280, 720)
		local fit = math.min((viewport.X - 24) / math.max(size.X.Offset, 1), (viewport.Y - 24) / math.max(size.Y.Offset, 1))
		return math.clamp(math.min(0.95, fit), 0.45, 0.95)
	end
	window.Scale = fitScale()
	Axivex.UIScale = window.Scale
	local root = New("Frame", { Name = "Root", BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = Sc(0.5, 0.5), Size = size, Visible = false, Parent = gui })
	local rootScale = New("UIScale", { Scale = window.Scale * 0.94, Parent = root })
	if not opts.Scale and workspace.CurrentCamera then
		Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
			local scale = fitScale()
			if math.abs(scale - window.Scale) > 0.01 then
				window:SetScale(scale)
			end
		end)
	end
	local outline = New("Frame", { Name = "Outline", BackgroundTransparency = 1, Size = Sc(1, 1), ZIndex = 3, Parent = root })
	Corner(outline, 14)
	local outlineStroke = Stroke(outline, "Accent", 1)

	local main = New("CanvasGroup", { Name = "Main", GroupTransparency = 1, Size = Sc(1, 1), Parent = root })
	Corner(main, 14)
	Bind(main, { BackgroundColor3 = "Background" })
	Glow(main, "AccentDark", V2(460, 280), Off(70, 10), 0.03)
	Glow(main, "Accent", V2(380, 260), U2(1, -30, 1, 10), 0.012)

	local topbar = New("Frame", { Name = "Topbar", BackgroundTransparency = 0.45, Size = U2(1, 0, 0, 52), Parent = main })
	Bind(topbar, { BackgroundColor3 = "Sidebar" })
	Badge(topbar, window.Title, opts.Icon, 28, U2(0, 14, 0.5, 0), V2(0, 0.5))
	local right = New("Frame", { BackgroundTransparency = 1, AnchorPoint = V2(1, 0.5), Position = U2(1, -12, 0.5, 0), Size = Off(0, 30), AutomaticSize = Enum.AutomaticSize.X, Parent = topbar })
	List(right, 4, true)
	window._titleLabel = Label({ Text = window.Title, Position = Off(52, 9), Size = U2(1, -64, 0, 18), Font = Fonts.Bold, TextSize = 14, Truncate = Enum.TextTruncate.AtEnd, Parent = topbar })
	window._subtitleLabel = Label({ Text = window.Subtitle, Position = Off(52, 27), Size = U2(1, -64, 0, 15), TextSize = 11, Truncate = Enum.TextTruncate.AtEnd, Color = "SubText", Parent = topbar })
	right:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local width = U2(1, -(64 + right.AbsoluteSize.X / rootScale.Scale + 10), 0, 18)
		window._titleLabel.Size, window._subtitleLabel.Size = width, U2(width.X.Scale, width.X.Offset, 0, 15)
	end)

	local statusList = opts.Status
	if statusList == nil then
		statusList = { "FPS", "Ping", "Time" }
	end
	if statusList and #statusList > 0 then
		local pill = New("Frame", { Name = "Status", BackgroundTransparency = 0.1, Size = Off(0, 30), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1, Parent = right })
		Corner(pill, 9)
		Bind(pill, { BackgroundColor3 = "Field" })
		Stroke(pill)
		Pad(pill, 0, 0, 12, 12)
		List(pill, 12, true)
		New("Frame", { BackgroundTransparency = 1, Size = Off(4, 1), LayoutOrder = 1, Parent = right })
		local items = {}
		for i, item in ipairs(statusList) do
			item = type(item) == "table" and item or StatusItems[item]
			if item then
				if #items > 0 then
					Bind(New("Frame", { Size = Off(1, 12), LayoutOrder = i * 2 - 1, Parent = pill }), { BackgroundColor3 = "Stroke" })
				end
				local chip = New("Frame", { BackgroundTransparency = 1, Size = Sc(0, 1), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = i * 2, Parent = pill })
				List(chip, 7, true)
				Icon(chip, item.Icon, 14, "Accent", { LayoutOrder = 1 })
				local label = AutoLabel(chip, "", 12, Fonts.SemiBold, "Text", 2)
				label.RichText = true
				if item.Width then
					New("UISizeConstraint", { MinSize = V2(item.Width, 0), Parent = label })
				end
				table.insert(items, { Item = item, Label = label })
			end
		end
		local function refresh()
			for _, entry in ipairs(items) do
				local ok, value = pcall(entry.Item.Get, Live)
				local unit = entry.Item.Unit
				entry.Label.Text = (ok and tostring(value) or "-") .. (unit and (" " .. Rich.Color(unit, "SubText")) or "")
			end
		end
		refresh()
		task.spawn(function()
			while gui.Parent do
				task.wait(1)
				refresh()
			end
		end)
	end
	local minimizeButton = IconButton(right, "minus", 2)
	local closeButton = IconButton(right, "x", 3, "Error")
	Bind(New("Frame", { Position = Off(0, 52), Size = U2(1, 0, 0, 1), Parent = main }), { BackgroundColor3 = "Stroke" })
	local brandLine = New("Frame", { Name = "BrandLine", BackgroundColor3 = Color3.new(1, 1, 1), Position = Off(0, 52), Size = U2(1, 0, 0, 1), Parent = main })
	New("UIGradient", {
		Color = Brand,
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.25, 0.45), NumberSequenceKeypoint.new(0.75, 0.45), NumberSequenceKeypoint.new(1, 1) }),
		Parent = brandLine,
	})

	local showHint = opts.ShowKeyHint ~= false
	local sidebar = New("Frame", { Name = "Sidebar", BackgroundTransparency = 0.65, Position = Off(0, 53), Size = U2(0, 176, 1, -53), Parent = main })
	Bind(sidebar, { BackgroundColor3 = "Sidebar" })
	Bind(New("Frame", { Position = Off(176, 53), Size = U2(0, 1, 1, -53), Parent = main }), { BackgroundColor3 = "Stroke" })
	local tabScroll = New("ScrollingFrame", {
		Name = "Tabs",
		BackgroundTransparency = 1,
		Position = Off(0, 10),
		Size = U2(1, 0, 1, -84),
		CanvasSize = U2(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = sidebar,
	})
	local highlight = New("Frame", { Name = "Highlight", BackgroundTransparency = 0.88, Position = Off(12, TAB_LABEL), Size = U2(1, -24, 0, TAB_HEIGHT), Visible = false, Parent = tabScroll })
	Corner(highlight, 9)
	Bind(highlight, { BackgroundColor3 = "Accent" })
	Stroke(highlight, "Accent", 0.72)
	local dot = New("Frame", { AnchorPoint = V2(1, 0.5), Position = U2(1, -11, 0.5, 0), Size = Off(6, 6), Parent = highlight })
	Round(dot)
	Bind(dot, { BackgroundColor3 = "Accent" })
	Stroke(dot, "Accent", 0.5).Thickness = 2
	local tabList = New("Frame", { Name = "List", BackgroundTransparency = 1, Position = Off(12, 0), Size = U2(1, -24, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = tabScroll })
	List(tabList, TAB_GAP)
	Pad(tabList, 0, 6, 0, 0)
	local navLabel = Label({ Text = "NAVIGATION", Size = U2(1, 0, 0, TAB_LABEL - TAB_GAP), Font = Fonts.Bold, TextSize = 9, Color = "Muted", LayoutOrder = 0, Parent = tabList })
	Pad(navLabel, 0, 4, 6, 0)

	local userCard = New("Frame", { Name = "User", BackgroundTransparency = 0.2, AnchorPoint = V2(0, 1), Position = U2(0, 12, 1, -12), Size = U2(1, -24, 0, 50), Parent = sidebar })
	Corner(userCard, 10)
	Bind(userCard, { BackgroundColor3 = "Element" })
	Stroke(userCard)
	Avatar(userCard, 30, { AnchorPoint = V2(0, 0.5), Position = U2(0, 10, 0.5, 0) })
	Label({ Text = LocalPlayer and LocalPlayer.DisplayName or "Player", Position = Off(50, showHint and 9 or 0), Size = U2(1, -58, 0, showHint and 15 or 50), Font = Fonts.SemiBold, TextSize = 12, Truncate = Enum.TextTruncate.AtEnd, Parent = userCard })
	if showHint then
		local hint = New("Frame", { BackgroundTransparency = 1, Position = Off(50, 27), Size = U2(1, -58, 0, 15), Parent = userCard })
		List(hint, 5, true)
		local keycap = New("Frame", { Size = Off(0, 15), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1, Parent = hint })
		Corner(keycap, 4)
		Stroke(keycap)
		Bind(keycap, { BackgroundColor3 = "Field" })
		Pad(keycap, 0, 0, 5, 5)
		window._keyLabel = AutoLabel(keycap, KeyName(window.ToggleKey), 9, Fonts.SemiBold, "SubText")
		AutoLabel(hint, "to hide", 10, Fonts.Regular, "Muted", 2)
	end

	local content = New("Frame", { Name = "Content", BackgroundTransparency = 1, Position = Off(177, 53), Size = U2(1, -177, 1, -53), Parent = main })
	local pageTitle = Label({ Text = "", Position = Off(21, 14), Size = U2(1, -42, 0, 24), Font = Fonts.Bold, TextSize = 19, Truncate = Enum.TextTruncate.AtEnd, Parent = content })
	local pageDesc = Label({ Text = "", Position = Off(21, 39), Size = U2(1, -42, 0, 15), TextSize = 11, Truncate = Enum.TextTruncate.AtEnd, Color = "SubText", Parent = content })
	local pages = New("Frame", { Name = "Pages", BackgroundTransparency = 1, ClipsDescendants = true, Position = Off(0, 64), Size = U2(1, 0, 1, -64), Parent = content })
	local fader = New("Frame", { Name = "Fader", BackgroundTransparency = 1, Position = pages.Position, Size = pages.Size, Visible = false, ZIndex = 5, Parent = content })
	Bind(fader, { BackgroundColor3 = "Background" })
	local bottomFade = New("Frame", { Name = "BottomFade", AnchorPoint = V2(0, 1), Position = Sc(0, 1), Size = U2(1, 0, 0, 30), ZIndex = 4, Parent = content })
	Bind(bottomFade, { BackgroundColor3 = "Background" })
	New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = bottomFade })

	local grip = New("TextButton", { Name = "Resize", Text = "", BackgroundTransparency = 1, AnchorPoint = V2(1, 1), Position = Sc(1, 1), Size = Off(18, 18), ZIndex = 5, Visible = opts.Resizable ~= false, Parent = root })
	for i, length in ipairs({ 5, 10 }) do
		local mark = New("Frame", { AnchorPoint = V2(0.5, 0.5), Position = Off(13 - (i - 1) * 3, 13 - (i - 1) * 3), Size = Off(length, 2), Rotation = -45, BackgroundTransparency = 0.4, ZIndex = 5, Parent = grip })
		Round(mark)
		Bind(mark, { BackgroundColor3 = "Muted" })
	end

	window.Gui, window.Root, window.Main = gui, root, main
	window._scale, window._outline = rootScale, outlineStroke
	window._tabList, window._highlight, window._pages, window._fader = tabList, highlight, pages, fader
	window._pageTitle, window._pageDesc = pageTitle, pageDesc

	MakeDraggable(topbar, root)

	local resizing, resizeStart, startSize, startPos = false, nil, nil, nil
	grip.InputBegan:Connect(function(input)
		if IsClick(input) then
			resizing, resizeStart = true, input.Position
			startSize, startPos = root.AbsoluteSize / rootScale.Scale, root.Position
		end
	end)
	Connect(UserInputService.InputChanged, function(input)
		if resizing and IsMove(input) then
			local delta = input.Position - resizeStart
			local w = math.max(window.MinSize.X, startSize.X + delta.X)
			local h = math.max(window.MinSize.Y, startSize.Y + delta.Y)
			root.Size = Off(w, h)
			root.Position = U2(startPos.X.Scale, startPos.X.Offset + (w - startSize.X) / 2, startPos.Y.Scale, startPos.Y.Offset + (h - startSize.Y) / 2)
		end
	end)
	Connect(UserInputService.InputEnded, function(input)
		if IsClick(input) then
			resizing = false
		end
	end)

	if UserInputService.TouchEnabled or opts.MobileButton then
		local open = New("TextButton", { Name = "OpenButton", Text = "", AutoButtonColor = false, Position = Off(20, 80), Size = Off(46, 46), Visible = false, Parent = gui })
		Corner(open, 12)
		Stroke(open, "Accent", 0.7)
		Bind(open, { BackgroundColor3 = "Background" })
		Badge(open, window.Title, opts.Icon, 26, Sc(0.5, 0.5), V2(0.5, 0.5))
		local openScale = New("UIScale", { Scale = 0, Parent = open })
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
			Axivex:Toast({ Text = "Press " .. KeyName(window.ToggleKey) .. " to reopen", Icon = "keyboard" })
		end
	end)
	closeButton.MouseButton1Click:Connect(function()
		window:Popup({
			Title = "Close " .. window.Title .. "?",
			Content = "This unloads the interface. Your saved configs are kept.",
			Buttons = { { Text = "Cancel" }, { Text = "Close", Primary = true, Callback = function()
				Axivex:Unload()
			end } },
		})
	end)
	Connect(UserInputService.InputBegan, function(input, processed)
		if processed or UserInputService:GetFocusedTextBox() or window._loading then
			return
		end
		if Axivex._activeBind or os.clock() - (Axivex._lastBind or 0) < 0.15 then
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
		Tween(self._scale, { Scale = self.Scale }, 0.5, Enum.EasingStyle.Back)
		Tween(self._outline, { Transparency = 0.8 }, 0.35)
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
		Tween(self._scale, { Scale = self.Scale * 0.94 }, 0.25)
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
	for _, panel in ipairs(self._panels or {}) do
		panel:_fade()
	end
end

function Window:SidePanel(opts)
	opts = opts or {}
	local window = self
	local right = opts.Side ~= "Left"
	local panel = { Visible = opts.Visible ~= false }
	local frame = New("Frame", {
		Name = "SidePanel",
		BackgroundTransparency = 1,
		AnchorPoint = V2(right and 0 or 1, 0),
		Position = right and U2(1, 10, 0, 0) or U2(0, -10, 0, 0),
		Size = U2(0, opts.Width or 220, opts.Height and 0 or 1, opts.Height or 0),
		Visible = panel.Visible,
		Parent = window.Root,
	})
	local outline = New("Frame", { BackgroundTransparency = 1, Size = Sc(1, 1), ZIndex = 2, Parent = frame })
	Corner(outline, 14)
	local outlineStroke = Stroke(outline, "Accent", 0.8)
	local body = New("CanvasGroup", { Name = "Body", Size = Sc(1, 1), Parent = frame })
	Corner(body, 14)
	Bind(body, { BackgroundColor3 = "Background" })
	local title = Label({ Text = opts.Title or "", Position = Off(14, 0), Size = U2(1, -28, 0, 42), Font = Fonts.Bold, TextSize = 13, Truncate = Enum.TextTruncate.AtEnd, Parent = body })
	Bind(New("Frame", { Position = Off(0, 42), Size = U2(1, 0, 0, 1), Parent = body }), { BackgroundColor3 = "Stroke" })
	local content = New("Frame", { Name = "Content", BackgroundTransparency = 1, ClipsDescendants = true, Position = Off(0, 43), Size = U2(1, 0, 1, -43), Parent = body })
	panel.Frame, panel.Content = frame, content

	function panel:_fade()
		local shown = window.Visible and self.Visible
		if shown then
			frame.Visible = true
		end
		Tween(body, { GroupTransparency = shown and 0 or 1 }, 0.3)
		Tween(outlineStroke, { Transparency = shown and 0.8 or 1 }, 0.3)
		if not shown then
			task.delay(0.3, function()
				if not (window.Visible and self.Visible) then
					frame.Visible = false
				end
			end)
		end
	end

	function panel:SetVisible(visible)
		self.Visible = visible
		self:_fade()
	end

	function panel:SetTitle(text)
		title.Text = text
	end

	function panel:Destroy()
		local index = table.find(window._panels or {}, self)
		if index then
			table.remove(window._panels, index)
		end
		frame:Destroy()
	end

	local shown = window.Visible and panel.Visible
	body.GroupTransparency = shown and 0 or 1
	outlineStroke.Transparency = shown and 0.8 or 1
	window._panels = window._panels or {}
	table.insert(window._panels, panel)
	return panel
end

function Window:SetScale(scale)
	self.Scale = scale
	Axivex.UIScale = scale
	if self.Visible then
		Tween(self._scale, { Scale = scale }, 0.3)
	else
		self._scale.Scale = scale * 0.94
	end
	if self._loaderScale and self._loaderScale.Parent then
		self._loaderScale.Scale = scale
	end
	for _, holder in ipairs({ NotifyHolder, ToastHolder }) do
		local uiScale = holder and holder:FindFirstChild("AxivexScale")
		if uiScale then
			uiScale.Scale = scale
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
	local index = table.find(Axivex.Windows, self)
	if index then
		table.remove(Axivex.Windows, index)
	end
	self.Gui:Destroy()
end

function Window:Notify(...)
	return Axivex:Notify(...)
end

function Window:Toast(...)
	return Axivex:Toast(...)
end

local function NavButton(parent, opts, isSelected, size, order)
	local item = { _hover = false }
	local button = New("TextButton", { Name = opts.Name, Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = size, LayoutOrder = order, Parent = parent })
	Corner(button, 8)
	local color = function(t)
		if isSelected() then
			return t.Text
		end
		return item._hover and t.SubText or t.Muted
	end
	Bind(button, {
		BackgroundColor3 = "Text",
		BackgroundTransparency = function()
			return (item._hover and not isSelected()) and 0.96 or 1
		end,
	})
	local styled = { button }
	local icon = Icon(button, opts.Icon, opts.IconSize or 16, function(t)
		return isSelected() and t.Accent or color(t)
	end, { LayoutOrder = 1 })
	if icon then
		table.insert(styled, icon)
	end
	item.Label = AutoLabel(button, opts.Name, opts.TextSize or 12, Fonts.Medium, color, 2)
	table.insert(styled, item.Label)
	item.Button, item.Styled = button, styled
	OnHover(button, function(state)
		item._hover = state
		RestyleAll(styled, 0.15)
	end)
	return item
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
		Index = #self.Tabs + 1,
		_order = 0,
	}, TabMeta)
	local nav = NavButton(self._tabList, { Name = tab.Name, Icon = opts.Icon }, function()
		return self.Selected == tab
	end, U2(1, 0, 0, TAB_HEIGHT), tab.Index)
	Pad(nav.Button, 0, 0, 11, 24)
	List(nav.Button, 10, true)
	nav.Label.TextTruncate = Enum.TextTruncate.AtEnd
	nav.Label.AutomaticSize = Enum.AutomaticSize.None
	nav.Label.Size = U2(1, #nav.Styled == 3 and -26 or 0, 1, 0)
	tab._button, tab._styled, tab._label = nav.Button, nav.Styled, nav.Label
	nav.Button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	local page = New("ScrollingFrame", {
		Name = tab.Name,
		BackgroundTransparency = 1,
		Size = Sc(1, 1),
		CanvasSize = U2(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Visible = false,
		Parent = self._pages,
	})
	Bind(page, { ScrollBarImageColor3 = "Stroke" })
	Pad(page, 2, 30, 21, 21)
	List(page, 8)
	tab.Scroll, tab.Frame = page, page

	table.insert(self.Tabs, tab)
	if not self.Selected then
		self:SelectTab(tab, true)
	end
	return tab
end
Window.AddTab = Window.Tab
Window.CreateTab = Window.Tab

local function FindIn(list, key)
	if type(key) == "table" then
		return key
	end
	for _, item in ipairs(list or {}) do
		if item.Index == key or item.Name == key then
			return item
		end
	end
end

function Window:SelectTab(tab, instant)
	tab = FindIn(self.Tabs, tab)
	if not tab or self.Selected == tab then
		return
	end
	local previous = self.Selected
	self.Selected = tab
	for _, t in ipairs(self.Tabs) do
		RestyleAll(t._styled, 0.25)
	end

	local highlight = self._highlight
	local y = TAB_LABEL + (tab.Index - 1) * (TAB_HEIGHT + TAB_GAP)
	if highlight.Visible then
		Tween(highlight, { Position = Off(12, y) }, 0.45)
		Tween(highlight, { Size = U2(1, -30, 0, TAB_HEIGHT - 4) }, 0.15)
		task.delay(0.15, Tween, highlight, { Size = U2(1, -24, 0, TAB_HEIGHT) }, 0.35, Enum.EasingStyle.Back)
	else
		highlight.Position, highlight.Visible = Off(12, y), true
	end

	self._switch = self._switch + 1
	local switch = self._switch
	local function show()
		for _, t in ipairs(self.Tabs) do
			t.Scroll.Visible = t == tab
		end
		self._pageTitle.Text, self._pageDesc.Text = tab.Name, tab.Desc
		self._pageTitle.TextTransparency, self._pageDesc.TextTransparency = 1, 1
		self._pageTitle.Position = Off(29, 14)
		Tween(self._pageTitle, { TextTransparency = 0, Position = Off(21, 14) }, 0.4)
		Tween(self._pageDesc, { TextTransparency = 0 }, 0.5)
		tab.Scroll.Position = Off(0, 14)
		Tween(tab.Scroll, { Position = Off(0, 0) }, 0.45)
		if tab._syncPages then
			task.defer(tab._syncPages, true)
		end
	end
	if instant or not previous then
		return show()
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
	self._label.Text = name
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
	local tab = self
	if not self._pageBar then
		local bar = New("Frame", { Name = "PageBar", BackgroundTransparency = 0.1, Size = Off(0, 34), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = NextOrder(self), Parent = self.Frame })
		Corner(bar, 10)
		Bind(bar, { BackgroundColor3 = "Field" })
		Stroke(bar)
		Pad(bar, 3, 3, 3, 3)
		local slide = New("Frame", { Name = "Highlight", Size = Off(0, 28), Visible = false, Parent = bar })
		Corner(slide, 7)
		Bind(slide, { BackgroundColor3 = "Element" })
		Stroke(slide, "Accent", 0.75)
		local row = New("Frame", { Name = "Row", BackgroundTransparency = 1, Size = Sc(0, 1), AutomaticSize = Enum.AutomaticSize.X, Parent = bar })
		List(row, 2, true)
		self._pageBar, self._pageRow, self._pageSlide, self.Pages = bar, row, slide, {}
		function self._syncPages(instant)
			local page = tab.SelectedPage
			if not page then
				return
			end
			local button = page._button
			local scale = bar.AbsoluteSize.Y / 34
			if scale <= 0 then
				return
			end
			local goal = {
				Position = Off((button.AbsolutePosition.X - bar.AbsolutePosition.X) / scale - 3, 0),
				Size = Off(button.AbsoluteSize.X / scale, 28),
			}
			if instant or not slide.Visible then
				slide.Position, slide.Size, slide.Visible = goal.Position, goal.Size, true
			else
				Tween(slide, goal, 0.4)
			end
		end
		row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			self._syncPages(true)
		end)
	end

	local page = setmetatable({ Type = "Page", Name = opts.Name or "Page", Window = self.Window, Tab = self, Index = #self.Pages + 1, _order = 0 }, PageMeta)
	local nav = NavButton(self._pageRow, { Name = page.Name, Icon = opts.Icon, IconSize = 14 }, function()
		return self.SelectedPage == page
	end, Sc(0, 1), page.Index)
	nav.Button.AutomaticSize = Enum.AutomaticSize.X
	Corner(nav.Button, 7)
	Pad(nav.Button, 0, 0, 13, 13)
	List(nav.Button, 6, true)
	page._button, page._styled = nav.Button, nav.Styled
	nav.Button.MouseButton1Click:Connect(function()
		self:SelectPage(page)
	end)

	local frame = New("Frame", { Name = page.Name, BackgroundTransparency = 1, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false, LayoutOrder = NextOrder(self), Parent = self.Frame })
	List(frame, 8)
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
	page = FindIn(self.Pages, page)
	if not page or self.SelectedPage == page then
		return
	end
	self.SelectedPage = page
	for _, p in ipairs(self.Pages) do
		p.Frame.Visible = p == page
		RestyleAll(p._styled, 0.2)
	end
	self._syncPages(instant)
	if not instant then
		page._padding.PaddingTop = UDim.new(0, 14)
		Tween(page._padding, { PaddingTop = UDim.new(0, 0) }, 0.4)
	end
end

function Page:Select()
	self.Tab:SelectPage(self)
end

local function DialogButton(parent, data, order)
	local hover = false
	local primary = data.Primary
	local button = New("TextButton", {
		Text = data.Text or data.Title or "Button",
		AutoButtonColor = false,
		Size = U2(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = Fonts.SemiBold,
		TextSize = 12,
		LayoutOrder = order,
		Parent = parent,
	})
	Corner(button, 9)
	Pad(button, 0, 0, 16, 16)
	Stroke(button, primary and "Accent" or "Stroke")
	Bind(button, {
		BackgroundColor3 = function(t)
			if primary then
				return hover and t.Accent:Lerp(Color3.new(1, 1, 1), 0.15) or t.Accent
			end
			return hover and t.ElementHover or t.Field
		end,
		TextColor3 = primary and "OnAccent" or "Text",
	})
	OnHover(button, function(state)
		hover = state
		Restyle(button, 0.15)
	end)
	return button
end

function Window:Popup(opts)
	opts = opts or {}
	local popup = { Closed = false }
	local overlay = New("TextButton", { Name = "Popup", Text = "", AutoButtonColor = false, BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Size = Sc(1, 1), ZIndex = 50, Parent = self.Main })
	local dialog = New("TextButton", { Name = "Dialog", Text = "", AutoButtonColor = false, AnchorPoint = V2(0.5, 0.5), Position = Sc(0.5, 0.5), Size = Off(opts.Width or 340, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = overlay })
	Corner(dialog, 14)
	Stroke(dialog, "Accent", 0.75)
	Bind(dialog, { BackgroundColor3 = "Background" })
	Pad(dialog, 18, 18, 20, 20)
	List(dialog, 10)
	local scale = New("UIScale", { Scale = 0.92, Parent = dialog })

	Label({ Text = opts.Title or "Are you sure?", Size = U2(1, 0, 0, 20), Font = Fonts.Bold, TextSize = 15, LayoutOrder = 1, Parent = dialog })
	if opts.Content or opts.Text then
		Label({ Text = opts.Content or opts.Text, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Wrapped = true, RichText = true, TextSize = 12, Color = "SubText", LayoutOrder = 2, Parent = dialog })
	end
	local inputBox
	if opts.Input then
		local inputOpts = type(opts.Input) == "table" and opts.Input or {}
		local _, box = Field(dialog, U2(1, 0, 0, 32), nil, { Placeholder = inputOpts.Placeholder or "Type here...", Text = inputOpts.Default or "", LayoutOrder = 3 })
		inputBox = box
	end
	local row = New("Frame", { BackgroundTransparency = 1, Size = U2(1, 0, 0, 34), LayoutOrder = 4, Parent = dialog })
	List(row, 8, true, Enum.HorizontalAlignment.Right)

	for i, data in ipairs(opts.Buttons or { { Text = "Okay", Primary = true } }) do
		DialogButton(row, data, i).MouseButton1Click:Connect(function()
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
		task.delay(0.25, overlay.Destroy, overlay)
		Spawn(opts.OnClose)
	end

	overlay.MouseButton1Click:Connect(function()
		if opts.Dismissable ~= false then
			popup:Close()
		end
	end)
	Tween(overlay, { BackgroundTransparency = 0.4 }, 0.25)
	FadeTree(dialog, true, 0.3)
	Tween(scale, { Scale = 1 }, 0.45, Enum.EasingStyle.Back)
	if inputBox then
		task.delay(0.1, inputBox.CaptureFocus, inputBox)
	end
	return popup
end
Window.Dialog = Window.Popup

function Axivex:Popup(opts)
	local window = self.Windows[#self.Windows]
	return window and window:Popup(opts)
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
			task.spawn(function()
				local success, err = pcall(el.Set, el, Decode(value))
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
	local name = Trim(FS.Read(self._configDir .. "/autoload.txt"))
	return name ~= "" and name or nil
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

local function FormatUptime(seconds)
	seconds = math.floor(seconds)
	local hours, minutes = math.floor(seconds / 3600), math.floor(seconds % 3600 / 60)
	if hours > 0 then
		return string.format("%dh %02dm", hours, minutes)
	elseif minutes > 0 then
		return string.format("%dm %02ds", minutes, seconds % 60)
	end
	return seconds .. "s"
end

local HomeStats = {
	FPS = { Get = function() return Live.FPS end },
	Ping = { Suffix = " ms", Get = Ping },
	Executor = { Static = true, Get = function() return tostring(identifyexecutor() or "Unknown") end },
	Game = { Static = true, Slow = true, Get = function()
		local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
		return ok and type(info) == "table" and info.Name or game.Name
	end },
	Time = { Get = function(state) return os.date(state.TimeFormat) end },
	Players = { Get = StatusItems.Players.Get },
	Uptime = { Get = function() return FormatUptime(os.clock() - LoadedAt) end },
}

local function DefaultGreeting()
	local hour = tonumber(os.date("%H")) or 12
	return hour < 12 and "Good morning." or hour < 18 and "Good afternoon." or "Good evening."
end

local function WelcomeCard(container, opts)
	local name = LocalPlayer and LocalPlayer.DisplayName or "there"
	local card = Panel(container, "Welcome", 62)
	Glow(card, "Accent", V2(260, 120), U2(1, -40, 0.5, 0), 0.02)
	card.ClipsDescendants = true
	local avatar = Avatar(card, 38, { AnchorPoint = V2(0, 0.5), Position = U2(0, 12, 0.5, 0) }, opts.Avatar == false)
	local welcome = Label({ Name = "Title", Text = (opts.Welcome or "Hello, ") .. name, Position = Off(62, 13), Size = U2(1, -74, 0, 18), Font = Fonts.SemiBold, TextSize = 14, Truncate = Enum.TextTruncate.AtEnd, Parent = card })
	local greeting = Label({ Name = "Greeting", Text = opts.Greeting or DefaultGreeting(), Position = Off(62, 32), Size = U2(1, -74, 0, 16), TextSize = 11, Truncate = Enum.TextTruncate.AtEnd, Color = "SubText", Parent = card })
	return {
		Card = card,
		Avatar = avatar,
		SetTitle = function(_, text)
			welcome.Text = text
		end,
		SetGreeting = function(_, text)
			greeting.Text = text
		end,
	}
end

function Window:HomeTab(opts)
	opts = opts or {}
	local tab = self:Tab({ Name = opts.Name or "Home", Icon = opts.Icon or "house", Description = opts.Description or opts.Desc or "Overview" })
	local main = tab
	if opts.Pages then
		main = tab:Page({ Name = opts.DetailsName or "Details", Icon = opts.DetailsIcon })
		tab.Details = main
	end
	if opts.Welcome ~= false then
		tab.Welcome = WelcomeCard(main, opts)
	end

	local entries = {}
	for _, stat in ipairs(opts.Stats or { "FPS", "Ping", "Executor", "Game", "Time", "Players", "Uptime" }) do
		local stock = type(stat) == "table" and stat or HomeStats[stat]
		if stock then
			table.insert(entries, {
				Title = type(stat) == "table" and (stat.Title or stat.Name or "Stat") or stat,
				Get = stock.Get,
				Prefix = stock.Prefix,
				Suffix = stock.Suffix,
				Static = stock.Static,
				Slow = stock.Slow,
			})
		end
	end

	if #entries > 0 then
		local state = { TimeFormat = opts.TimeFormat or "%H:%M" }
		local function read(entry)
			if type(entry.Get) ~= "function" then
				return "-"
			end
			local ok, value = pcall(entry.Get, state)
			return ok and value ~= nil and value or "Unknown"
		end
		local items = {}
		for i, entry in ipairs(entries) do
			items[i] = { Title = entry.Title, Value = entry.Slow and "..." or read(entry), Prefix = entry.Prefix, Suffix = entry.Suffix }
		end
		local section = main:Section({ Title = opts.SectionName or opts.Title or "System info", Icon = opts.SectionIcon or "activity" })
		local stats = section:Stats({ Items = items, Columns = opts.Columns or 2 })
		tab.Stats = stats
		for i, entry in ipairs(entries) do
			if entry.Slow then
				task.spawn(function()
					stats:Set(i, read(entry))
				end)
			end
		end
		task.spawn(function()
			while tab.Scroll.Parent do
				task.wait(1)
				for i, entry in ipairs(entries) do
					if not entry.Static then
						stats:Set(i, read(entry))
					end
				end
			end
		end)
	end

	for _, pageOpts in ipairs(opts.Pages or {}) do
		local page = tab:Page({ Name = pageOpts.Name or "Page", Icon = pageOpts.Icon })
		if pageOpts.Entries then
			page:Changelog(pageOpts.Entries)
		end
		if pageOpts.Content then
			page:Paragraph({ Title = pageOpts.Title, Content = pageOpts.Content })
		end
		if type(pageOpts.Build) == "function" then
			SafeCall(pageOpts.Build, page, page.Frame)
		end
	end
	return tab
end

function Window:SettingsTab(opts)
	opts = opts or {}
	local window = self
	local tab = self:Tab({ Name = opts.Name or "Settings", Icon = opts.Icon or "settings", Description = opts.Description or "Configs, theme and interface" })
	local toast = function(text, kind)
		Axivex:Toast({ Text = text, Type = kind })
	end

	local configs = tab:Section({ Title = "Configuration", Icon = "folder" })
	local nameInput = configs:Input({ Title = "Config name", Placeholder = "my-config", Finished = false })
	local list = configs:Dropdown({ Title = "Saved configs", Options = window:ListConfigs(), AllowNull = true })
	local function selectedName()
		local typed = Trim(nameInput.Value)
		return typed ~= "" and typed or list.Value
	end
	local function withName(verb, fn)
		return function()
			local name = selectedName()
			if not name then
				return toast("Pick a config to " .. verb .. " first", "Error")
			end
			fn(name)
		end
	end

	configs:Button({ Title = "Save config", Desc = "Saves every flagged element", Icon = "save", Primary = true, Callback = withName("save", function(name)
		local ok = window:SaveConfig(name)
		list:Refresh(window:ListConfigs())
		list:Set(name, true)
		toast(ok and ("Saved " .. name) or "Couldn't save config", ok and "Success" or "Error")
	end) })
	configs:Button({ Title = "Load config", Icon = "folder-open", Callback = withName("load", function(name)
		local ok, err = window:LoadConfig(name)
		toast(ok and ("Loaded " .. name) or err, ok and "Success" or "Error")
	end) })
	configs:Button({ Title = "Delete config", Icon = "trash-2", Callback = withName("delete", function(name)
		window:Popup({
			Title = "Delete " .. name .. "?",
			Content = "This can't be undone.",
			Buttons = { { Text = "Cancel" }, { Text = "Delete", Primary = true, Callback = function()
				window:DeleteConfig(name)
				list:Refresh(window:ListConfigs())
				toast("Deleted " .. name)
			end } },
		})
	end) })
	local autoload
	autoload = configs:Toggle({ Title = "Autoload", Desc = "Loads it when the script starts", Default = window:GetAutoload() ~= nil, Callback = function(state)
		if not state then
			return window:SetAutoload(nil)
		end
		local name = selectedName()
		if not name then
			toast("Pick a config to autoload", "Error")
			return autoload:Set(false, true)
		end
		window:SetAutoload(name)
		toast("Autoloading " .. name)
	end })
	configs:Button({ Title = "Refresh list", Icon = "refresh-cw", Callback = function()
		list:Refresh(window:ListConfigs(), true)
	end })

	local ui = tab:Section({ Title = "Interface", Icon = "palette" })
	local themeNames = {}
	for name in pairs(Axivex.Themes) do
		table.insert(themeNames, name)
	end
	table.sort(themeNames)
	ui:Dropdown({ Title = "Theme", Options = themeNames, Default = Axivex.ThemeName, Callback = function(name)
		if name then
			Axivex:SetTheme(name)
		end
	end })
	ui:ColorPicker({ Title = "Accent color", Default = Axivex.Theme.Accent, Callback = function(color)
		Axivex:SetAccent(color)
	end })
	ui:Keybind({ Title = "Toggle key", Desc = "Shows or hides the window", Default = window.ToggleKey, ChangedCallback = function(key)
		window:SetToggleKey(key)
	end })
	ui:Button({ Title = "Unload", Desc = "Removes the interface", Icon = "power", Callback = function()
		window:Popup({ Title = "Unload interface?", Buttons = { { Text = "Cancel" }, { Text = "Unload", Primary = true, Callback = function()
			Axivex:Unload()
		end } } })
	end })
	return tab
end

function Axivex:Unload()
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	table.clear(self._connections)
	Live.Running = false
	for _, window in ipairs(self.Windows) do
		pcall(window.SetVisible, window, false)
		task.delay(0.3, window.Gui.Destroy, window.Gui)
	end
	table.clear(self.Windows)
	if NotifyGui then
		task.delay(0.3, NotifyGui.Destroy, NotifyGui)
		NotifyGui = nil
	end
	table.clear(self.Options)
	table.clear(self.Flags)
	Spawn(self.OnUnload)
end

return Axivex
