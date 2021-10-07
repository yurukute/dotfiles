local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')

local volume = {}

local GET_VOLUME_CMD = 'amixer -D pulse sget Master'
local INC_VOLUME_CMD = 'amixer -D pulse sset Master 5%+'
local DEC_VOLUME_CMD = 'amixer -D pulse sset Master 5%-'
local TOG_VOLUME_CMD = 'amixer -D pulse sset Master toggle'

local PLAY_SOUND_CMD = 'play /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga'

local ICON_DIR = os.getenv('HOME') .. '/.config/awesome/widgets/volume-widget/icons/'

local function worker(user_args)
    local args = user_args or {}

    local noti_id
    local size = args.size or 18
    local thickness = args.thickness or 2
    local refresh_rate = args.refresh_rate or 1
    local bg_color = args.bg_color or '#ffffff11'
    local main_color = args.main_color or beautiful.fg_color
    local mute_color = args.mute_color or beautiful.fg_urgent
    local mixer_cmd = args.mixer_cmd or 'pavucontrol'
    local current_level = 0

    local volume_icon = wibox.widget {
        id = 'icon',
        image = ICON_DIR .. 'volume-medium.svg',
        resize = true,
        widget = wibox.widget.imagebox,
    }

    volume.widget = wibox.widget {
        volume_icon,
        max_value = 100,
        thickness = thickness,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = size,
        forced_width = size,
        bg = bg_color,
        colors = { main_color },
        paddings = 2,
        widget = wibox.container.arcchart,
        set_volume = function(self, new_value)
            self.value = new_value
        end,
        mute = function(self)
            self.colors = { mute_color }
        end,
        unmute = function(self)
            self.colors = { main_color }
        end
    }

    local function update_level(widget, stdout)
        local mute = string.match(stdout, '%[(o%D%D?)%]')
        local volume_level = string.match(stdout, '(%d?%d?%d)%%')

        local lv = tonumber(volume_level)
        if lv < 40 then
            volume_icon:set_image(ICON_DIR .. 'volume-low.svg')
        elseif lv < 70 then
            volume_icon:set_image(ICON_DIR .. 'volume-medium.svg')
        else
            volume_icon:set_image(ICON_DIR .. 'volume-high.svg')
        end

        if mute == 'off' then
            widget:mute()
            volume_icon:set_image(ICON_DIR .. 'volume-muted.svg')
        elseif mute == 'on' then
            widget:unmute()
        end

        current_level = volume_level
        volume.widget:set_volume(volume_level)
    end

    function volume:inc()
        awful.spawn.easy_async(INC_VOLUME_CMD, function(stdout)
            update_level(volume.widget, stdout)
            awful.spawn(PLAY_SOUND_CMD, false)
            noti_id = naughty.notify({
                title = 'volume',
                text = current_level .. ' %',
                replaces_id = noti_id,
                timeout= 1,
            }).id
        end)
    end

    function volume:dec()
        awful.spawn.easy_async(DEC_VOLUME_CMD, function(stdout)
            update_level(volume.widget, stdout)
            awful.spawn(PLAY_SOUND_CMD, false)
            noti_id = naughty.notify({
                title = 'volume',
                text = current_level .. ' %',
                replaces_id = noti_id,
                timeout= 1,
            }).id
        end)
    end

    function volume:toggle()
        awful.spawn.easy_async(TOG_VOLUME_CMD, function(stdout)
            update_level(volume.widget, stdout)
        end)
    end

    volume.widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() volume:toggle() end),
        awful.button({}, 4, function() volume:inc() end),
        awful.button({}, 5, function() volume:dec() end),
        awful.button({}, 3, function() awful.spawn.easy_async(mixer_cmd) end)
    ))

    awful.spawn.easy_async(GET_VOLUME_CMD, function(stdout)
        update_level(volume.widget, stdout)
    end)

    return volume.widget
end

return setmetatable(volume, { __call = function(_, ...) return worker(...) end })
