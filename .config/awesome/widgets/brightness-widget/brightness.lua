local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')

local ICON_DIR = os.getenv('HOME') .. '/.config/awesome/widgets/brightness-widget/'
local get_brightness_cmd
local set_brightness_cmd
local inc_brightness_cmd
local dec_brightness_cmd

local brightness_widget = {}

local function show_warning(message)
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = 'Brightness Widget',
        text = message,
    }
end

local function worker(user_args)
    local args = user_args or {}

    local path_to_icon = args.path_to_icon or ICON_DIR .. 'brightness.svg'
    local font = args.font or 'Play 9'
    local timeout = args.timeout or 100

    local noti_id
    local step = args.step or 5
    local base = args.base or 20
    local size = args.size or 18
    local thickness = args.thickness or 2
    local bg_color = args.bg_color or '#ffffff11'
    local main_color = args.main_color or beautiful.fg_normal
    local program = args.program or 'light'
    local current_level = 0
    if program == 'light' then
        get_brightness_cmd = 'light -G'
        set_brightness_cmd = 'light -S ' -- <level>
        inc_brightness_cmd = 'light -A ' .. step
        dec_brightness_cmd = 'light -U ' .. step
    elseif program == 'xbacklight' then
        get_brightness_cmd = 'xbacklight -get'
        set_brightness_cmd = 'xbacklight -set ' -- <level>
        inc_brightness_cmd = 'xbacklight -inc ' .. step
        dec_brightness_cmd = 'xbacklight -dec ' .. step
    else
        show_warning(program .. ' command is not supported by the widget')
        return
    end

    brightness_widget.widget = wibox.widget {
        {
            image = path_to_icon,
            resize = true,
            widget = wibox.widget.imagebox,
        },
        max_value = 100,
        thickness = thickness,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = size,
        forced_width = size,
        bg = bg_color,
        colors = { main_color },
        paddings = 2,
        widget = wibox.container.arcchart,
        set_value = function(self, level) self:set_value(level) end,
    }

    local update_widget = function(widget, stdout, _, _, _)
        local brightness_level = tonumber(string.format('%.0f', stdout))
        current_level = brightness_level
        widget:set_value(brightness_level)
    end

    function brightness_widget:set(value)
        current_level = value
        awful.spawn.easy_async(set_brightness_cmd .. value, function()
            awful.spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
                noti_id = naughty.notify({
                    title = 'brightness',
                    text = string.format('%.0f %%', current_level),
                    replaces_id = noti_id,
                    timeout= 1,
                }).id
            end)
        end)
    end

    local old_level = 0
    function brightness_widget:toggle()
        if old_level < 0.1 then
            -- avoid toggling between '0' and 'almost 0'
            old_level = 1
        end
        if current_level < 0.1 then
            -- restore previous level
            current_level = old_level
        else
            -- save current brightness for later
            old_level = current_level
            current_level = 0
        end
        brightness_widget:set(current_level)
    end

    function brightness_widget:inc()
        awful.spawn.easy_async(inc_brightness_cmd, function()
            awful.spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
                noti_id = naughty.notify({
                    title = 'brightness',
                    text = string.format('%.0f %%', current_level),
                    replaces_id = noti_id,
                    timeout= 1,
                }).id
            end)
        end)
    end

    function brightness_widget:dec()
        awful.spawn.easy_async(dec_brightness_cmd, function()
            awful.spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
                noti_id = naughty.notify({
                    title = 'brightness',
                    text = string.format('%.0f %%', current_level),
                    replaces_id = noti_id,
                    timeout= 1,
                }).id
            end)
        end)
    end

    brightness_widget.widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() brightness_widget:set(base) end),
        awful.button({}, 3, function() brightness_widget:toggle() end),
        awful.button({}, 4, function() brightness_widget:inc() end),
        awful.button({}, 5, function() brightness_widget:dec() end)
    ))

    awful.spawn.easy_async(get_brightness_cmd, function(out)
        update_widget(brightness_widget.widget, out)
    end)

    return brightness_widget.widget
end

return setmetatable(brightness_widget, { __call = function(_, ...) return worker(...) end })
