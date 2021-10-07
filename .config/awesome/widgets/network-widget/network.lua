local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')

local ICON_DIR = os.getenv('HOME') .. '/.config/awesome/widgets/network-widget/icons/'
local WATCH_CMD = 'nmcli device status'

local network = {}

local function worker(user_args)
    local args = user_args or {}

    local bg_color = args.bg_color or '#ffffff11'
    local main_color = args.main_color or beautiful.fg_color
    local timeout = args.timeout or 2

    local network_icon = wibox.widget {
        image = ICON_DIR .. 'network-ethernet.svg',
        resize = true,
        valign = 'bottom',
        widget = wibox.widget.imagebox,
    }

    local network_name = wibox.widget {
        markup = '',
        align = 'left',
        valign = 'center',
        widget = wibox.widget.textbox,
    }

    network.widget = wibox.widget {
        spacing = 10,
        layout = wibox.layout.fixed.horizontal,
    }

    network.widget.children = { network_icon }

    awful.widget.watch(WATCH_CMD, timeout, function(widget, stdout)
        local ether = string.match(stdout, '(ethernet%s+connected)')
        if ether ~= nil then
            network_icon.image = ICON_DIR .. 'network-ethernet.svg'
            network.widget.children = { network_icon }
            return
        end

        local wifi = string.match(stdout, 'wifi%s+connected%s+(.*)%s*')
        if wifi ~= nil then
            network_icon.image = ICON_DIR .. 'network-wifi.svg'
            network_name.markup = wifi:match('[^\r\n]+'):gsub('%s+$', '')
            network.widget.children = { network_icon, network_name }
            return
        end

        network.widget.children = nil
    end)

    return network.widget
end

return setmetatable(network, { __call = function(_, ...) return worker(...) end })
