-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears 		= require("gears")
local awful 		= require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox 		= require("wibox")
local cpu_widget	= require("widgets.cpu-widget.cpu-widget")
local volume_widget	= require('widgets.volume-widget.volume')
local brightness_widget = require("widgets.brightness-widget.brightness")
local calendar_widget	= require("widgets.calendar-widget.calendar")
local network_widget	= require("widgets.network-widget.network")
-- Theme handling library
local beautiful		= require("beautiful")
-- Notification library
local naughty		= require("naughty")
local hotkeys_popup	= require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
		    title  = "Oops, there were errors during startup!",
		    text   = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
	 -- Make sure we don't go into an endless error loop
	 if in_error then return end
	 in_error = true
	 
	 naughty.notify({ preset = naughty.config.presets.critical,
			  title  = "Oops, an error happened!",
			  text   = tostring(err) })
	 in_error = false
   end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")
naughty.config.defaults.margin = 10

-- This is used later as the default terminal and editor to run.
terminal	= "kitty"
editor		= os.getenv("EDITOR") or "emacs"
editor_cmd	= terminal .. " -e " .. editor
browser 	= "microsoft-edge-dev"
file_mng	= "thunar"
launcher	= "~/.config/rofi/launcher.sh"
picture_dir	= "~/Pictures/"
-- Default modkey.
modkey		= "Mod4"
altkey		= "Mod1"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
   awful.layout.suit.tile.left,
   awful.layout.suit.tile,   
   awful.layout.suit.fair,   
   awful.layout.suit.tile.bottom,   
   awful.layout.suit.tile.top,   
   awful.layout.suit.fair.horizontal,   
   --awful.layout.suit.spiral,
   --awful.layout.suit.spiral.dwindle,
   --awful.layout.suit.max,
   --awful.layout.suit.max.fullscreen,
   --awful.layout.suit.magnifier,
   --awful.layout.suit.corner.nw,
   -- awful.layout.suit.corner.ne,
   -- awful.layout.suit.corner.sw,
   -- awful.layout.suit.corner.se,
   awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
mylogoutmenu = awful.menu(
   {items = {
       { "Log out",	function() awesome.quit() end, beautiful.logout_icon},
       { "Reboot",	function() awful.spawn.with_shell("systemctl reboot")end , beautiful.reboot_icon },
       { "Sleep",	function() awful.spawn.with_shell("systemctl suspend") end, beautiful.sleep_icon },
       { "Power off",	function() awful.spawn.with_shell("systemctl poweroff") end, beautiful.poweroff_icon }}})

mylogoutmenu.wibox.shape = function (cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mylogoutmenu })

-- Close menu when mouse leave it
mylogoutmenu.wibox:connect_signal("mouse::leave", function() mylogoutmenu:hide() end)

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock('%a %b %d, %I:%M %p')
local cw = calendar_widget({
      placement = "top_right",
      theme 	= 'nord'
})
mytextclock:connect_signal("button::press", 
			   function(_, _, _, button)
			      if button == 1 then cw.toggle() end
end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
   awful.button({ }, 1, function(t) t:view_only() end),
   awful.button({ modkey }, 1, function(t)
	 if client.focus then
	    client.focus:move_to_tag(t)
	 end
   end),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, function(t)
	 if client.focus then
	    client.focus:toggle_tag(t)
	 end
   end),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
   awful.button({ }, 1, function (c)
	 if c == client.focus then
	    c.minimized = true
	 else
	    c:emit_signal(
	       "request::activate",
	       "tasklist",
	       {raise = true}
	    )
	 end
   end),
   awful.button({ }, 3, function()
	 awful.menu.client_list({ theme = { width = 250 } })
   end),
   awful.button({ }, 4, function ()
	 awful.client.focus.byidx(1)
   end),
   awful.button({ }, 5, function ()
	 awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s, pic_dir)
    -- Wallpaper
    if pic_dir ~= nil then
        awful.spawn(string.format([=[bash -c '
        [[ -f /tmp/bg_pid ]] && kill `cat /tmp/bg_pid`
        echo $$ > /tmp/bg_pid
        while true; do
            for img in `eval find "%s" | shuf`; do
                feh --no-fehbg --bg-fill $img
                echo $img > /tmp/cur_bg
                sleep 60
            done
        done']=], pic_dir), false)
    elseif beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
      -- Wallpaper
      set_wallpaper(s,picture_dir.."Wallpapers/")
      -- Each screen has its own tag table.
      awful.tag({ "W", "E", "S", "O", "M", "E", "W", "M" }, s, awful.layout.layouts[1])

      -- Create a promptbox for each screen
      s.mypromptbox = awful.widget.prompt()
      -- Create an imagebox widget which will contain an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(
	 gears.table.join(
	    awful.button({ }, 1, function () awful.layout.inc( 1) end),
	    awful.button({ }, 3, function () awful.layout.inc(-1) end),
	    awful.button({ }, 4, function () awful.layout.inc( 1) end),
	    awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist {
	 screen  = s,
	 filter  = awful.widget.taglist.filter.all,
	 buttons = taglist_buttons
      }

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist {
	 screen  = s,
	 filter  = awful.widget.tasklist.filter.currenttags,
	 buttons = tasklist_buttons
      }
      
      -- Create the wibox
      s.mywibox = awful.wibar({ position = "top", screen = s })

      -- Add widgets to the wibox
      s.mywibox:setup {
	 layout = wibox.layout.align.horizontal,
	 { -- Left widgets
	    layout = wibox.layout.fixed.horizontal,
	    mylauncher,
	    s.mytaglist,
	    s.mypromptbox,
	 },
	 nil,
	 --s.mytasklist,
	 { -- Right widgets
	    layout = wibox.layout.fixed.horizontal,
	    spacing = 7,
	    wibox.widget.systray(),
	    --network_widget(),
	    cpu_widget{
	       enable_kill_button = true,
	    },
	    volume_widget{
	       size = 20,
	       tooltip = true,
	    },
	    brightness_widget{
	       step = 10,
	       size = 20,
	       tooltip = true,
	    },
	    mytextclock,
	    --s.mylayoutbox,
	 },
      }   
      s.mybottomwibox = awful.wibar({ position = "bottom", screen = s })
      s.mybottomwibox:setup{
	 layout = wibox.layout.align.horizontal,
	 {
	    layout = wibox.layout.fixed.horizontal,
	 },
	 s.mytasklist,
	 s.mylayoutbox
      }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(
   gears.table.join(
      root.buttons(),     
      awful.button({ }, 4, awful.tag.viewnext),
      awful.button({ }, 5, awful.tag.viewprev),
      awful.button({ }, 3, function () awful.spawn.with_shell(launcher) end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
   awful.key({ modkey,					}, "s",      hotkeys_popup.show_help,
      {description ="show help", group = "awesome"}),
   awful.key({ modkey,					}, "Left",   awful.tag.viewprev,
      {description = "view previous", group = "tag"}),
   awful.key({ modkey,					}, "Right",  awful.tag.viewnext,
      {description = "view next", group = "tag"}),
   awful.key({ modkey,					}, "Escape", awful.tag.history.restore,
      {description = "go back", group = "tag"}),

   awful.key({ "Control", modkey }, "Right",
      function ()
	 awful.client.focus.byidx( 1)
      end,
      {description = "focus next by index", group = "client"}
   ),
   awful.key({ "Control", modkey }, "Left",
      function ()
	 awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
   ),
   awful.key({ modkey,					}, "w",		function () awful.spawn.with_shell(launcher)	end,
      {description = "show applications launcher", group = "awesome"}),

   -- Layout manipulation
   awful.key({ modkey, "Shift"			}, "Left",		function () awful.client.swap.byidx(  1)		end,
      {description = "swap with next client by index", group = "client"}),
   awful.key({ modkey, "Shift"			}, "Right",	function () awful.client.swap.byidx( -1)		end,
      {description = "swap with previous client by index", group = "client"}),
   awful.key({ modkey, "Control"		}, "Left",		function () awful.screen.focus_relative( 1)		end,
      {description = "focus the next screen", group = "screen"}),
   awful.key({ modkey, "Control"		}, "Right",	function () awful.screen.focus_relative(-1)		end,
      {description = "focus the previous screen", group = "screen"}),
   awful.key({ modkey,					}, "u", awful.client.urgent.jumpto,
      {description = "jump to urgent client", group = "client"}),
   awful.key({ modkey,					}, "Tab",
      function ()
	 awful.client.focus.history.previous()
	 if client.focus then
	    client.focus:raise()
	 end
      end,
      {description = "go back", group = "client"}),
   --User programs
   awful.key({ modkey					}, "q",	function () awful.spawn(browser)				end,
      {description = "open default browser", group = "launcher"}),
      awful.key({ "Control", "Shift"	}, "n", function () awful.spawn(browser.." -inprivate") end,
      {description = "open default browser (incognito)", group = "launcher"}),
   awful.key({ modkey					}, "e",	function () awful.spawn(file_mng)			end,
      {description = "open file manager", group = "launcher"}),	
   -- Standard program
   awful.key({ modkey,					}, "Return",	function () awful.spawn(terminal)				end,
      {description = "open a terminal", group = "launcher"}),
   awful.key({ modkey, "Control"		}, "r", awesome.restart,
      {description = "reload awesome", group = "awesome"}),
   awful.key({ modkey, "Shift"			}, "q", awesome.quit,
      {description = "quit awesome", group = "awesome"}),

   awful.key({ modkey,					}, "l",     function () awful.tag.incmwfact( 0.05)          end,
      {description = "increase master width factor", group = "layout"}),
   awful.key({ modkey,					}, "h",     function () awful.tag.incmwfact(-0.05)          end,
      {description = "decrease master width factor", group = "layout"}),
   awful.key({ modkey, "Shift"			}, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
      {description = "increase the number of master clients", group = "layout"}),
   awful.key({ modkey, "Shift"			}, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
      {description = "decrease the number of master clients", group = "layout"}),
   awful.key({ modkey, "Control"		}, "h",     function () awful.tag.incncol( 1, nil, true)    end,
      {description = "increase the number of columns", group = "layout"}),
   awful.key({ modkey, "Control"		}, "l",     function () awful.tag.incncol(-1, nil, true)    end,
      {description = "decrease the number of columns", group = "layout"}),
   awful.key({ modkey,					}, "space", function () awful.layout.inc( 1)                end,
      {description = "select next", group = "layout"}),
   awful.key({ modkey, "Shift"			}, "space", function () awful.layout.inc(-1)                end,
      {description = "select previous", group = "layout"}),

   awful.key({ modkey, "Control"		}, "n",
      function ()
	 local c = awful.client.restore()
	 -- Focus restored client
	 if c then
	    c:emit_signal(
	       "request::activate", "key.unminimize", {raise = true}
	    )
	 end
      end,
      {description = "restore minimized", group = "client"}),

   -- Prompt
   awful.key({ modkey },       "r",     function () awful.screen.focused().mypromptbox:run() end,
      {description = "run prompt", group = "launcher"}),
   --[[
   awful.key({ modkey }, "x",
      function ()
	 awful.prompt.run {
	    prompt       = "Run Lua code: ",
	    textbox      = awful.screen.focused().mypromptbox.widget,
	    exe_callback = awful.util.eval,
	    history_path = awful.util.get_cache_dir() .. "/history_eval"
	 }
      end,
      {description = "lua execute prompt", group = "awesome"}),
   --]]
   -- Show/hide wibox
   awful.key({ modkey }, "b", function ()
	 for s in screen do
	    s.mywibox.visible = not s.mywibox.visible
	    if s.mybottomwibox then
	       s.mybottomwibox.visible = not s.mybottomwibox.visible
	    end
	 end
   end,
      {description = "toggle wibox", group = "awesome"}),
   -- Volume
   awful.key({ }, "XF86AudioRaiseVolume",	function() volume_widget:inc()				end,
      {description = "Volume up", group = "hotkeys"}),
   awful.key({ }, "XF86AudioLowerVolume",	function() volume_widget:dec()				end,
      {description = "Volume down", group = "hotkeys"}),
   awful.key({ }, "XF86AudioMute",			function() volume_widget:toggle()			end,
      {description = "Mute", group = "hotkeys"}),
   --Screen brightness
   awful.key({ }, "XF86MonBrightnessUp",	function () brightness_widget:inc()			end,
      {description = "Increase brightness", group = "hotkeys"}),
   awful.key({ }, "XF86MonBrightnessDown",	function () brightness_widget:dec()			end,
      {description = "Decrease brightness", group = "hotkeys"}),
   --Screenshot
   awful.key({ modkey, "Shift" }, "s",		function () awful.spawn("flameshot gui")	end,
      {description = "take region screenshot", group = "hotkeys"}),
   awful.key({ }, "Print",					function ()
		 awful.spawn.with_shell("flameshot full -c -p "..picture_dir.."Screenshots")	end,
      {description = "take full screenshot", group = "hotkeys"})
)

clientkeys = gears.table.join(
   awful.key({ modkey,           }, "f",
      function (c)
	 c.fullscreen = not c.fullscreen
	 c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),
   awful.key({ modkey, "Shift"   }, "c",		function (c) c:kill()					end,
      {description = "close", group = "client"}),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
      {description = "toggle floating", group = "client"}),
   awful.key({ modkey, "Control" }, "Return",	function (c)
		 c:swap(awful.client.getmaster())												end,
      {description = "move to master", group = "client"}),
   awful.key({ modkey,           }, "o",		function (c) c:move_to_screen()			end,
      {description = "move to screen", group = "client"}),
   awful.key({ modkey,           }, "t",		function (c) c.ontop = not c.ontop		end,
      {description = "toggle keep on top", group = "client"}),
   awful.key({ modkey,           }, "a",		function (c) c.sticky = not c.sticky	end,
      {description = "toggle sticky", group = "client"}),
   awful.key({ modkey,           }, "n",
      function (c)
	 -- The client currently has the input focus, so it cannot be
	 -- minimized, since minimized clients can't have the focus.
	 c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
   awful.key({ modkey,           }, "m",
      function (c)
	 c.maximized = not c.maximized
	 c:raise()
      end ,
      {description = "(un)maximize", group = "client"}),
   awful.key({ modkey, "Control" }, "m",
      function (c)
	 c.maximized_vertical = not c.maximized_vertical
	 c:raise()
      end ,
      {description = "(un)maximize vertically", group = "client"}),
   awful.key({ modkey, "Shift"   }, "m",
      function (c)
	 c.maximized_horizontal = not c.maximized_horizontal
	 c:raise()
      end ,
      {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
for i = 1, 9 do
   globalkeys = gears.table.join(
      globalkeys,
      -- View tag only.
      awful.key({ modkey }, "#" .. i + 9,
	 function ()
	    local screen = awful.screen.focused()
	    local tag = screen.tags[i]
	    if tag then
	       tag:view_only()
	    end
	 end,
	 {description = "view tag #"..i, group = "tag"}),
      -- Toggle tag display.
      awful.key({ modkey, "Control" }, "#" .. i + 9,
	 function ()
	    local screen = awful.screen.focused()
	    local tag = screen.tags[i]
	    if tag then
	       awful.tag.viewtoggle(tag)
	    end
	 end,
	 {description = "toggle tag #" .. i, group = "tag"}),
      -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
	 function ()
	    if client.focus then
	       local tag = client.focus.screen.tags[i]
	       if tag then
		  client.focus:move_to_tag(tag)
	       end
	    end
	 end,
	 {description = "move focused client to tag #"..i, group = "tag"}),
      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	 function ()
	    if client.focus then
	       local tag = client.focus.screen.tags[i]
	       if tag then
		  client.focus:toggle_tag(tag)
	       end
	    end
	 end,
	 {description = "toggle focused client on tag #" .. i, group = "tag"})
   )
end

clientbuttons = gears.table.join(
   awful.button({ }, 1, function (c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
   end),
   awful.button({ modkey }, 1, function (c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
	 awful.mouse.client.move(c)
   end),
   awful.button({ modkey }, 3, function (c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
	 awful.mouse.client.resize(c)
   end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
		    border_color = beautiful.border_normal,
		    focus = awful.client.focus.filter,
		    raise = true,
		    keys = clientkeys,
		    buttons = clientbuttons,
		    screen = awful.screen.preferred,
		    placement = awful.placement.no_offscreen
     }
   },

   -- Floating clients.
   { rule_any = {
	instance = {
	   terminal,
	   "DTA",  -- Firefox addon DownThemAll.
	   "copyq",  -- Includes session name in class.
	   "pinentry",
	   "pavucontrol",
	   "gtk-recordMyDesktop",
	   "feh",
	   "TeamViewer"
        },
        class = {
	   "Arandr",
	   "Blueman-manager",
	   "Gpick",
	   "Kruler",
	   "MessageWin",  -- kalarm.
	   "Sxiv",
	   "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
	   "Wpa_gui",
	   "veromix",
	   "xtightvncviewer",
	   "Nvidia-settings",
	   "processing-app-Base"
	},
        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
	   "Event Tester",  -- xev.
	   "Picture in picture",
        },
        role = {
	   "AlarmWindow",  -- Thunderbird's calendar.
	   "ConfigManager",  -- Thunderbird's about:config.
	   "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
   }, properties = { floating = true, ontop = true }},

   -- Add titlebars to normal clients and dialogs
   { rule_any = {type = { "normal", "dialog" }},
     except = { instance = "TeamViewer" },
     properties = { titlebars_enabled = true }
   },
  
   -- Set programs to always map on specified tag.
   { rule = { class = "discord" },
     properties = { screen = 1, tag = awful.screen.focused().tags[2],
		    floating = true }
   },
   { rule = { class = "PokeMMO" },
     properties = { screen = 1, tag = awful.screen.focused().tags[8] }
   },
}
-- }}}

-- {{{ Signals
-- Spawn client at center while using floating layout
client.connect_signal("property::floating", function(c)
			 awful.placement.centered(c)			 
end)

-- Jump to urgent tag automatically
client.connect_signal("property::urgent", function(c)
			 c.minimized = false
			 c:jump_to()
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
      -- Set the windows at the slave,
      -- i.e. put it at the end of others instead of setting it master.
      -- if not awesome.startup then awful.client.setslave(c) end
      if awesome.startup
	 and not c.size_hints.user_position
	 and not c.size_hints.program_position then
	 -- Prevent clients from being unreachable after screen count changes.
	 awful.placement.no_offscreen(c)
      end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
      -- buttons for the titlebar
      local buttons = gears.table.join(
	 awful.button({ }, 1, function()
	       c:emit_signal("request::activate", "titlebar", {raise = true})
	       awful.mouse.client.move(c)
	 end),
	 awful.button({ }, 3, function()
	       c:emit_signal("request::activate", "titlebar", {raise = true})
	       awful.mouse.client.resize(c)
	 end)
      )

      awful.titlebar(c, {size = 20}) : setup {
	 {-- Left
	    {
	       awful.titlebar.widget.closebutton	(c),
	       awful.titlebar.widget.minimizebutton	(c),
	       awful.titlebar.widget.maximizedbutton	(c),	
	       spacing = 5,
	       layout  = wibox.layout.flex.horizontal
	    },
	    margins = 4,
	    widget = wibox.container.margin
	 },
	 { -- Middle		  
	    { -- Title
	       align  = "center",
	       widget = awful.titlebar.widget.titlewidget(c)
	    },
	    buttons = buttons,
	    layout  = wibox.layout.flex.horizontal
	 },
	 {-- Left
	    {
	       awful.titlebar.widget.stickybutton	(c),
	       awful.titlebar.widget.floatingbutton	(c),
	       spacing = 5,
	       layout  = wibox.layout.flex.horizontal
	    },		 
	    margins = 4,
	    widget = wibox.container.margin
	 },
	 layout = wibox.layout.align.horizontal
      }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
      c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
