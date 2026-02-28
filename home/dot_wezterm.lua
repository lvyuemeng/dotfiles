local wezterm = require("wezterm")

local config = wezterm.config_builder()

------------------------------------------------------------
-- PERFORMANCE
------------------------------------------------------------
config.max_fps = 144
config.animation_fps = 144
config.front_end = "WebGpu"

------------------------------------------------------------
-- FONT
------------------------------------------------------------
config.font = wezterm.font_with_fallback({
	"Maple Mono NF",
	"JetBrains Mono NL",
	"Symbols Nerd Font",
})
config.font_size = 12

------------------------------------------------------------
-- COLORS
------------------------------------------------------------
config.color_scheme = "Catppuccin Macchiato"

------------------------------------------------------------
-- WINDOW
------------------------------------------------------------
config.window_decorations = "TITLE | RESIZE"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = true

------------------------------------------------------------
-- OS + SHELL PRIORITY DETECTION
------------------------------------------------------------

local function command_exists(cmd)
	local success, _, _ = wezterm.run_child_process({ cmd, "--version" })
	return success
end
local is_windows = wezterm.target_triple:find("windows") ~= nil

local default_prog = nil

if is_windows then
	config.wsl_domains = wezterm.default_wsl_domains()
	-- Windows priority: pwsh > powershell > cmd
	if command_exists("pwsh.exe") then
		default_prog = { "pwsh.exe" }
	elseif command_exists("powershell.exe") then
		default_prog = { "powershell.exe" }
	else
		default_prog = { "cmd.exe" }
	end
else
	config.wsl_domains = {}
	-- Unix priority: zsh > bash > sh
	if command_exists("zsh") then
		default_prog = { "zsh" }
	elseif command_exists("bash") then
		default_prog = { "bash" }
	else
		default_prog = { "sh" }
	end
end

config.default_prog = default_prog

------------------------------------------------------------
-- LEADER (tmux-style)
------------------------------------------------------------
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }

------------------------------------------------------------
-- KEYBINDINGS
------------------------------------------------------------
config.keys = {

	-- New tab in same domain (IMPORTANT)
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},

	-- Close pane
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	-- Tab navigation
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},

	-- Split panes
	{
		mods = "LEADER",
		key = "\\",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- Pane navigation
	{ mods = "LEADER", key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
	{ mods = "LEADER", key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
	{ mods = "LEADER", key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
	{ mods = "LEADER", key = "l", action = wezterm.action.ActivatePaneDirection("Right") },

	-- Resize
	{ mods = "LEADER", key = "LeftArrow", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ mods = "LEADER", key = "RightArrow", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ mods = "LEADER", key = "UpArrow", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ mods = "LEADER", key = "DownArrow", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- Explicit PowerShell tab
	{
		mods = "LEADER",
		key = "1",
		action = wezterm.action.SpawnCommandInNewTab({
			args = default_prog,
		}),
	},
}

if is_windows and #config.wsl_domains > 0 then
	table.insert(config.keys, {
		mods = "LEADER",
		key = "2",
		action = wezterm.action.SpawnTab({
			DomainName = config.wsl_domains[1].name,
		}),
	})
end

------------------------------------------------------------
-- TAB TITLE FORMAT
------------------------------------------------------------
wezterm.on("format-tab-title", function(tab)
	local pane = tab.active_pane
	local process = pane.foreground_process_name or ""
	process = process:match("([^/\\]+)$") or process
	process = process:lower()

	local title = process

	if process:find("pwsh") then
		title = "PowerShell"
	elseif process:find("bash") or process:find("zsh") then
		title = "WSL"
	elseif process:find("ssh") then
		title = "SSH"
	end

	return {
		{ Text = " " .. title .. " " },
	}
end)

------------------------------------------------------------
-- LEADER INDICATOR
------------------------------------------------------------
wezterm.on("update-status", function(window, _)
	if window:leader_is_active() then
		window:set_left_status(" 🌊 LEADER ")
	else
		window:set_left_status("")
	end
end)

return config
