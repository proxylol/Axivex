# Axivex API reference

- [Library](#library)
- [Window](#window)
- [Tabs and sections](#tabs-and-sections)
- [Elements: shared options and methods](#elements-shared-options-and-methods)
- [Elements](#elements): Button, Toggle, Slider, Dropdown, Input, Keybind, ColorPicker, Progress, Stats, Label, Paragraph, Divider, Space, Tags, Console
- [Notifications](#notifications)
- [Toasts](#toasts)
- [Popups](#popups)
- [Configs and saving](#configs-and-saving)
- [Themes](#themes)
- [Icons](#icons)
- [Secure mode](#secure-mode)
- [Rich text helpers](#rich-text-helpers)

Most constructors also accept a shorthand: `Tab:Button("Title", callback)`, `Tab:Toggle("Title", callback)`, and so on. Every element constructor also has `Add...` and `Create...` aliases (`AddButton`, `CreateToggle`, ...).

---

## Library

```lua
local Axivex = loadstring(game:HttpGet(URL))()
```

| Member | Description |
| --- | --- |
| `Axivex:CreateWindow(options)` | Creates a window. See [Window](#window). |
| `Axivex:Notify(options)` | Shows a notification card. See [Notifications](#notifications). |
| `Axivex:Toast(text or options)` | Shows a small pill at the top of the screen. See [Toasts](#toasts). |
| `Axivex:Popup(options)` | Opens a popup on the most recently created window. |
| `Axivex:SetTheme(name or table)` | Switches theme with tweened colors. |
| `Axivex:SetAccent(color, darkColor?)` | Replaces the accent color. The gradient's dark end is derived from it unless you pass `darkColor`. |
| `Axivex:OnThemeChanged(fn)` | Calls `fn(theme)` after every theme change. |
| `Axivex:Unload()` | Destroys every window, notification and connection, and clears the flags. |
| `Axivex.Flags` | `[flag] = current value` for every flagged element. |
| `Axivex.Options` | `[flag] = element object` for every flagged element. |
| `Axivex.Themes` | Built-in themes, by name. Add your own here. |
| `Axivex:CustomAsset(path, url?)` | Returns a `getcustomasset` id for `path`, downloading `url` to it first if the file is missing. See [Icons](#icons). |
| `Axivex.Secure` | `true` when [secure mode](#secure-mode) is on. Read-only. |
| `Axivex.Rich` | Rich text helpers. |
| `Axivex.Folder` | Root folder for configs. Default `"Axivex"`. |
| `Axivex.MaxNotifications` | Notifications shown at once before the oldest closes. Default `5`. |
| `Axivex.OnUnload` | Optional function, called by `Unload()`. |

---

## Window

```lua
local Window = Axivex:CreateWindow({
	Title = "Airflow",
	Subtitle = "Example",
	Icon = nil,                          -- see Icons; default is a gradient badge with the title's first letter
	Size = UDim2.fromOffset(640, 440),
	MinSize = Vector2.new(520, 340),     -- smallest size the resize grip allows
	Theme = "Lavender",
	ToggleKey = Enum.KeyCode.RightShift,
	ConfigFolder = "Airflow",            -- configs go to Axivex/Airflow/configs
	AutoSave = false,                    -- true or a config name: saves 1s after any flagged change
	ShowKeyHint = true,                  -- "[RShift] to hide" at the bottom of the sidebar
	Resizable = true,
	MobileButton = false,                -- floating reopen button (always on for touch devices)
	Loading = true,                      -- loading screen before the window opens; false to skip, or a table (below)
})
```

### Loading screen

By default, a small card with the logo, title, a status line and a gradient progress bar shows before the window opens. Pass a table to customize it:

```lua
Loading = {
	Title = "Axivex",                    -- defaults to the window title
	Subtitle = "Preparing interface",    -- first status line
	Steps = { "Preparing interface", "Loading elements", "Applying theme", "Almost ready" },
	Duration = 1.6,                      -- seconds spent going through the steps
	Manual = false,                      -- true: you drive it yourself (below)
}
```

With `Manual = true`, the loader waits for you:

```lua
Window.Loader:Set(0.5, "Fetching data")  -- progress 0-1, optional status text
Window.Loader:Finish()                    -- fills the bar, fades out and opens the window
```

The toggle key does nothing while the loader is showing.

| Method | Description |
| --- | --- |
| `Window:Tab(options or name)` | Adds a tab. Options: `Name`, `Description`, `Icon`. |
| `Window:SelectTab(tab or index or name)` | Switches tab. |
| `Window:SettingsTab(options?)` | Adds a ready-made tab with config save, load, delete and autoload, plus theme, accent color, toggle key and unload. Options: `Name`, `Icon`, `Description`. |
| `Window:Popup(options)` | See [Popups](#popups). Alias: `Window:Dialog`. |
| `Window:Notify(...)` / `Window:Toast(...)` | Same as the library versions. |
| `Window:SetVisible(bool)` / `Window:Toggle()` | Shows or hides the window with a fade and scale. |
| `Window:SetTitle(text)` / `Window:SetSubtitle(text)` | Updates the sidebar header. |
| `Window:SetToggleKey(key)` | `Enum.KeyCode` or a key name string. Also updates the sidebar hint. |
| `Window:Destroy()` | Removes this window only. |
| Config methods | See [Configs and saving](#configs-and-saving). |

The minimize button hides the window. The close button asks for confirmation, then calls `Axivex:Unload()`.

---

## Tabs and sections

```lua
local Tab = Window:Tab({ Name = "Elements", Description = "One of everything", Icon = 123456 })
local Section = Tab:Section("Example section")
local Combat = Tab:Section({ Title = "Combat", Icon = 123456 })  -- optional icon before the heading
```

Elements can go straight into a tab, into a section, or into a [page](#pages). A section adds a small uppercase heading and groups the elements under it.

| Tab method | Description |
| --- | --- |
| `Tab:Section(title)` | Adds a section. |
| `Tab:Page(options or name)` | Adds a page (see below). Alias: `Tab:AddPage`. |
| `Tab:SelectPage(page or index or name)` | Switches page. |
| `Tab:Select()` | Switches to this tab. |
| `Tab:SetName(text)` / `Tab:SetDescription(text)` | Renames the tab. |

### Pages

A tab can be split into pages. A row of pills at the top of the tab switches between them.

```lua
local Home = Window:Tab({ Name = "Home", Description = "Overview" })

local Details = Home:Page("Details")                      -- or Home:Page({ Name = "Details", Icon = 123456 })
local Changelog = Home:Page("Changelog")

Details:Section("System info"):Stats({ { Title = "FPS", Value = 60 } })
Changelog:Paragraph({ Title = "v1.1", Content = "..." })

Changelog:Select()   -- or Home:SelectPage("Changelog")
```

A page works like a tab: it takes sections and elements directly. The first page is selected automatically. When a tab has pages, put its elements inside the pages: anything added straight to the tab shows below the pages on every page.

| Section method | Description |
| --- | --- |
| `Section:SetTitle(text)` | Renames the section. |
| `Section:SetVisible(bool)` | Shows or hides the whole section. |

---

## Elements: shared options and methods

Card elements (Button, Toggle, Slider, Dropdown, Input, Keybind, ColorPicker, Progress) take these options:

| Option | Type | Description |
| --- | --- | --- |
| `Title` | string | Main text. |
| `Desc` | string | Smaller text under the title. |
| `Icon` | image (see [Icons](#icons)) | Icon left of the title. |
| `Tag` / `Tags` | string, `{Text, Color}`, or a list of them | Small pills next to the title. |
| `Flag` | string | Registers the element in `Axivex.Flags` and `Axivex.Options` and includes it in configs. |
| `Callback` | function | Called when the value changes. |
| `Visible` | boolean | `false` hides the element at first. |
| `Locked` / `LockReason` | boolean / string | Starts the element locked. |

They also share these methods:

| Method | Description |
| --- | --- |
| `:Set(value, silent?)` | Sets the value. `silent = true` skips the callback. |
| `:Get()` | Returns the value (also available as `.Value`). |
| `:OnChanged(fn)` | Adds another listener next to `Callback`. |
| `:SetCallback(fn)` | Replaces the callback. |
| `:SetTitle(text)` / `:SetDesc(text)` | Updates the text. The card resizes smoothly if the description is added or removed. |
| `:SetVisible(bool)` | Shows or hides the element. |
| `:Lock(reason?)` / `:Unlock()` | Dims the element, shows the reason and blocks input. |
| `:Destroy()` | Removes the element and its flag. |

---

## Elements

### Button

```lua
local button = Section:Button({
	Title = "Example button",
	Desc = "Example description",
	Primary = false,  -- true: filled accent style
	Callback = function() end,
})
button:Fire()  -- runs the callback from code
```

### Toggle

```lua
Section:Toggle({
	Title = "Example toggle",
	Flag = "MyToggle",
	Default = false,
	Callback = function(state) end,
})
```

### Slider

```lua
Section:Slider({
	Title = "Walk speed",
	Flag = "WalkSpeed",
	Min = 16, Max = 100, Default = 16,
	Increment = 1,        -- e.g. 0.1 for one decimal place
	Suffix = "",          -- appended to the displayed value, e.g. "%"
	Format = nil,         -- function(value) -> string, overrides the displayed text
	Callback = function(value) end,
})
```

Drag the bar, or click the value box and type a number. Extra methods: `:SetMin(n)`, `:SetMax(n)`.

### Dropdown

```lua
local dropdown = Section:Dropdown({
	Title = "Mode",
	Flag = "Mode",
	Options = { "Legit", "Rage" },
	Default = "Legit",       -- for Multi, a list: { "Head", "Torso" }
	Multi = false,
	AllowNull = false,       -- single mode: clicking the selected option clears it (always on for Multi)
	Search = nil,            -- nil = automatic (shown when there are more than 8 options)
	MaxVisible = 5,          -- rows visible before the list scrolls
	CloseOnSelect = true,    -- single mode only
	Callback = function(value) end,  -- value: the option, nil, or a list for Multi
})
```

| Method | Description |
| --- | --- |
| `:Refresh(options, keepSelection?)` | Replaces the option list. |
| `:Add(option)` / `:Remove(option)` | Adds or removes one option. |
| `:Open()` / `:Close()` / `:SetOpen(bool)` | Expands or collapses the list. |

### Input

```lua
Section:Input({
	Title = "Player name",
	Flag = "PlayerName",
	Placeholder = "Username...",
	Default = "",
	Numeric = false,       -- strips anything that isn't a number
	MaxLength = nil,
	Width = 160,           -- width of the text field in pixels
	ClearOnFocus = false,
	Finished = true,       -- true: callback on Enter or focus lost; false: on every keystroke
	Callback = function(text, enterPressed) end,
})
```

`.TextBox` is the underlying TextBox.

### Keybind

```lua
Section:Keybind({
	Title = "Fly",
	Flag = "FlyKey",
	Default = Enum.KeyCode.F,   -- also accepts "F", "LeftShift", Enum.UserInputType.MouseButton2, or nil
	Mode = "Toggle",            -- "Toggle" | "Hold" | "Press"
	Callback = function(state) end,      -- Toggle: on/off; Hold: true on press, false on release; Press: true
	ChangedCallback = function(key) end, -- runs when the user rebinds
})
```

Click the key pill, then press a key. **Escape** cancels, **Backspace** or **Delete** clears the bind, and the right and middle mouse buttons can be bound. Only one keybind listens at a time. Keybinds don't fire while a text box has focus. Extra: `:GetState()`, `.State`, `.Binding`.

### ColorPicker

```lua
Section:ColorPicker({
	Title = "ESP color",
	Flag = "EspColor",
	Default = Color3.fromRGB(205, 180, 255),
	Callback = function(color) end,
})
```

Click the card to expand a saturation/value square, a hue bar, and hex and RGB fields. Extra: `:SetOpen(bool)`.

### Progress

```lua
local bar = Section:Progress({
	Title = "Transporter",
	Desc = "Flying, doing every task on board.",
	Max = 160,
	Default = 51,
	Display = "Fraction",   -- "Percent" (default) | "Fraction" (51/160) | "None" | function(value, max) -> string
	Color = nil,            -- Color3; default is the accent gradient
	Shimmer = true,         -- animated shine on the fill
	OnComplete = function() end,
})
bar:Set(80)
bar:Increment(1)
bar:SetMax(200)
```

### Stats

A row of stat tiles. When a value is a number, it counts up or down to the new number.

```lua
local stats = Section:Stats({
	{ Title = "Kills", Value = 12 },
	{ Title = "Ping", Value = 48, Suffix = "ms" },
	{ Title = "Cash", Value = 1500, Prefix = "$", Color = Color3.fromRGB(112, 222, 152) },
})
-- or Section:Stats({ Title = "Session", Items = { ... } }) to give the card a heading

stats:Set("Kills", 13)   -- by title or by index
stats:Get("Kills")
```

Item options: `Title`, `Value`, `Prefix`, `Suffix`, `Color`, `Format` (function, turns off the count animation).

`Section:Stat({ Title, Value, ... })` makes a single tile. Its `:Set(value)` and `:Get()` take no key.

### Label

```lua
local label = Section:Label("Supports <b>rich text</b> and wraps.")
-- or Section:Label({ Text = "...", Color = Color3.new(1, 1, 1), TextSize = 13, Bold = false, Center = false })
label:Set("New text")
```

### Paragraph

```lua
local p = Section:Paragraph({ Title = "Changelog", Content = "Long text..." })
p:SetContent("...")
p:SetTitle("...")
```

### Divider and Space

```lua
Section:Divider()          -- thin line
Section:Divider("Or")      -- line split around a small uppercase label
Section:Space(12)          -- empty gap in pixels
```

### Tags

```lua
local tags = Section:Tags({ "Beta", { Text = "Undetected", Color = Color3.fromRGB(112, 222, 152), Icon = 123456 } })
tags:Add("New")
tags:Remove("Beta")
tags:Clear()
```

### Console

```lua
local console = Tab:Console({
	Title = "Output",
	Height = 200,
	MaxLines = 200,          -- oldest lines are removed beyond this
	Prefix = "[axivex]",     -- default: "[info]", "[warn]", ... depending on the kind
	Timestamps = true,
	Placeholder = "Nothing logged yet.",
})

console:Log("plain text")
console:Info("info")       -- accent prefix
console:Success("success") -- green prefix
console:Warn("warning")    -- yellow prefix
console:Error("error")     -- red prefix
console:Debug("debug")     -- muted prefix
console:Print("a", 1, true)
console:Log("shot landed on " .. Axivex.Rich.Color("player123", "Success") .. " for 37 damage.")
console:Clear()
console:GetText()          -- plain text of every line
```

Click any line to copy it (plain text, without the rich-text tags). The header has **Copy**, which copies the whole log, and **Clear**. Copying uses `setclipboard` when it's available. New lines fade in, and the console scrolls to the bottom unless you've scrolled up.

---

## Notifications

Cards that stack in the bottom-right corner and slide in from the right.

```lua
local note = Axivex:Notify({
	Label = "Auto challenges",  -- small uppercase text next to a pulsing dot
	Status = "Running",         -- uppercase text on the right, in the type color
	Title = "Transporter",
	Icon = nil,                 -- optional icon left of the title
	Content = "Flying, doing every task on board.",
	Progress = { 51, 160 },     -- gradient progress bar plus a "51/160" counter
	Footer = "Next - Claim reward",
	Type = "Info",              -- "Info" | "Success" | "Warning" | "Error"
	Color = nil,                -- overrides the type color
	Duration = nil,             -- seconds; default 5, or no timeout when Progress is set; false or 0 = stays open
	Closable = true,            -- shows the X button; false hides it (close from code with note:Close())
	OnClose = function() end,
})

note:SetProgress(52, 160)
note:Set({ Status = "Done", Footer = "All tasks complete", Duration = 3 })
note:Close()
```

Shorthand: `Axivex:Notify("Title", "Content", 5)`.

A notification with a duration and no progress bar shows a thin line that shrinks as time runs out.

## Toasts

Small cards that drop in at the top-center of the screen, styled like the window. Each has a gradient accent bar on the left and a thin line along the bottom that drains as the toast's time runs out.

```lua
Axivex:Toast("Saved")
Axivex:Toast({
	Text = "Config saved",
	Content = "Optional second line",  -- adds a smaller line under the text
	Type = "Success",                  -- "Success" | "Warning" | "Error" | "Info" (accent)
	Icon = nil,                        -- optional icon, tinted in the type color
	Duration = 2.5,
	Color = nil,                       -- overrides the type color
})
```

`Type` or `Color` sets the accent bar and timer color. Returns a handle with `:Close()`.

## Popups

A dialog that dims the window and pops in.

```lua
Window:Popup({
	Title = "Teleport to spawn?",
	Content = "You'll lose your current position.",  -- supports rich text
	Width = 340,
	Input = { Placeholder = "Optional text field", Default = "" },  -- or true; omit for no field
	Dismissable = true,  -- clicking outside closes it
	Buttons = {
		{ Text = "Cancel" },
		{
			Text = "Teleport",
			Primary = true,
			Callback = function(inputText)
				-- return false to keep the popup open (e.g. for validation)
			end,
		},
	},
	OnClose = function() end,
})
```

With no `Buttons`, the popup shows a single **Okay** button. Returns a handle with `:Close()`.

---

## Configs and saving

Any element with a `Flag` is saved, except buttons and progress bars. Configs are JSON files at `Axivex/<ConfigFolder>/configs/<name>.json`. Colors and keybinds are encoded so they load back correctly.

| Method | Description |
| --- | --- |
| `Window:SaveConfig(name)` | Returns `ok, err`. |
| `Window:LoadConfig(name)` | Sets every saved flag and fires callbacks. Returns `ok, err`. |
| `Window:DeleteConfig(name)` | Deletes the file. |
| `Window:ListConfigs()` | Sorted list of config names. |
| `Window:SetAutoload(name or nil)` | Chooses the config `LoadAutoload` uses. |
| `Window:GetAutoload()` | The autoload config's name, or nil. |
| `Window:LoadAutoload()` | Loads the autoload config. With `AutoSave` on and no autoload set, it loads the autosave config. |

Call `Window:LoadAutoload()` at the end of your script, after every flagged element is created. `Window:SettingsTab()` provides all of this as UI.

When the executor file API is missing (e.g. in Studio), configs are kept in memory for the session only.

---

## Themes

Built-in themes: `Lavender` (default), `Ocean`, `Rose`, `Emerald`, `Amber`, `Mono`, `Light`.

```lua
Axivex:SetTheme("Ocean")
Axivex:SetAccent(Color3.fromRGB(255, 120, 80))

-- custom theme: start from the defaults and change what you need
Axivex.Themes.Midnight = Axivex.MakeTheme({
	Accent = Color3.fromRGB(120, 200, 255),
	AccentDark = Color3.fromRGB(60, 90, 255),
	Background = Color3.fromRGB(8, 10, 18),
})
Axivex:SetTheme("Midnight")
```

Custom themes added before `Window:SettingsTab()` appear in its theme dropdown.

Theme keys:

| Key | Used for |
| --- | --- |
| `Accent`, `AccentDark` | Accent color, and the two ends of every gradient |
| `OnAccent` | Text and icons on accent surfaces (primary buttons, toggle knob) |
| `Background` | Window and notification background |
| `Sidebar` | Sidebar and popup background |
| `Element`, `ElementHover` | Element cards |
| `Field` | Inputs, bar tracks, stat tiles, console output |
| `Stroke` | Borders and separators |
| `Text`, `SubText`, `Muted` | Text, from strongest to faintest |
| `Success`, `Warning`, `Error`, `Info` | Status colors |
| `Shadow` | Window drop shadow |

---

## Icons

Every `Icon` property (windows, tabs, pages, sections, elements, tags, notifications and toasts) takes an image. Axivex has no icon set you pick by name, so a string like `"folder"` shows nothing.

```lua
Window:Tab({ Name = "Files", Icon = 93364949241311 })
Window:Tab({ Name = "Servers", Icon = "rbxassetid://93364949241311" })
Tab:Button({ Title = "Alert", Icon = getcustomasset("my-icons/alert.png") })
```

| Value | Meaning |
| --- | --- |
| number | A Roblox asset id. |
| `"rbxassetid://..."` | The same id as a string. |
| `"rbxasset://..."` | A local file, which is what `getcustomasset` returns. Used as given, in secure mode too. |
| `"rbxthumb://..."` | A Roblox thumbnail. Blocked in secure mode. |
| `nil`, `0` or `""` | No icon. |

Icons are tinted to match the theme (muted text, the accent, or a tag's color), so white or single-color icons work best.

### Finding icons

Any image uploaded to Roblox works: copy its asset id. For icons that match each other, upload a set from one icon family, such as [Lucide](https://lucide.dev). Upload them at 256×256 or larger, because a small image looks soft when it's scaled up.

To keep your own images off the asset list, save them to disk and pass the `getcustomasset` result. In secure mode this is the only way your own icons show. `Axivex:CustomAsset` does the caching for you:

```lua
-- downloads the PNG the first time, then reads it from disk on later runs
local alert = Axivex:CustomAsset("my-icons/alert.png", "https://example.com/icons/alert.png")
Tab:Button({ Title = "Alert", Icon = alert })
```

It returns `nil` when the executor has no `getcustomasset`, or when the file is missing and there's no URL to download it from.

---

## Secure mode

Menus get fingerprinted by the Roblox asset ids they reference, and by probing whether a known id is loaded with `ContentProvider:GetAssetFetchStatus`. Secure mode makes sure nothing loadable can be traced back to Axivex.

Turn it on by setting a global **before** you load Axivex:

```lua
getgenv().AXIVEX_SECURE = true
local Axivex = loadstring(game:HttpGet(URL))()
print(Axivex.Secure)  --> true
```

**There's no built-in asset to hide.** Axivex builds its whole interface in code: chevrons, close buttons, toggles, the logo badge and the window shadow are drawn from frames. The font is Gotham, which ships with the Roblox client (`rbxasset://fonts/...`), so it's never loaded by asset id. Axivex references no asset ids of its own, in either mode.

**Your icons:** any raw asset id or thumbnail is blocked and renders blank. Local `getcustomasset` files still load, so cache your icons with [`Axivex:CustomAsset`](#icons) or `getcustomasset` yourself.

The net effect: in secure mode the only images Axivex ever shows are local `getcustomasset` files, whose content ids are per-machine and can't be guessed or probed for.

**It also goes quiet.** Secure mode makes no `warn` or `print` calls. Callback, popup and config errors that would normally log are swallowed.

---

## Rich text helpers

```lua
local Rich = Axivex.Rich
Rich.Color("text", Color3.new(1, 0, 0))  -- or a theme key: Rich.Color("text", "Success")
Rich.Bold("text")
Rich.Italic("text")
Rich.Escape("<not markup>")  -- use for untrusted text in rich-text labels and console lines
Rich.Strip("<b>x</b>")       -- "x"
```
