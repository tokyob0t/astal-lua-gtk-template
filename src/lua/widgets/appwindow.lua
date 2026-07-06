local Widget = require('astal.gtk4.widget')
local astal = require('astal')
local astalify = require('astal.gtk4.astalify')
local bind = require('astal.binding')

local Adw = astal.require('Adw', '1')
local Gtk = astal.require('Gtk', '4.0')
local Gio = astal.require('Gio', '2.0')
local GLib = astal.require('GLib', '2.0')

local TitleBar = require('lua.widgets.titlebar')

local settings = Gio.Settings {
    schema_id = package.domain,
}

---@type AstalLua.Binding<number> # Bind a GSettings key to a reactive value
local count = bind(settings, 'simple-int')

local function set_count(value)
    settings:set_int('simple-int', math.max(GLib.MININT32, math.min(GLib.MAXINT32, value)))
end

local ApplicationWindow = astalify(Adw.ApplicationWindow, {
    set_children = function(self, children)
        for _, ch in ipairs(children) do
            if Gtk.Widget:is_type_of(ch) then
                self.content = ch
            elseif Gio.Action:is_type_of(ch) then
                self:add_action(ch)
            end
        end
    end,
    get_children = function(self)
        return { self.content }
    end,
})

local ToolbarView = astalify(Adw.ToolbarView, {
    get_children = function(self)
        return { self.content }
    end,
})

---@param args { application: Gtk.Application }
return function(args)
    local Box = Widget.Box
    local Button = Widget.Button
    local Label = Widget.Label

    return ApplicationWindow {
        application = args.application,
        visible = false,
        ToolbarView {

            TitleBar {
                type = 'top',
                title = 'Counter',
                subtitle = count:as(function(v)
                    return v == 67 and '👉 67 👈' or tostring(v)
                end),
            },

            Box {
                spacing = 10,
                hexpand = true,
                vertical = true,
                valign = 'CENTER',

                Label {
                    label = count,
                    halign = 'CENTER',
                    class_name = 'title-1',
                },

                Box {
                    halign = 'CENTER',
                    spacing = 10,

                    Button {
                        icon_name = 'value-decrease-symbolic',
                        halign = 'CENTER',
                        class_name = 'circular',
                        on_clicked = function()
                            set_count(count:get() - 1)
                        end,
                    },

                    Button {
                        icon_name = 'value-increase-symbolic',
                        halign = 'CENTER',
                        class_name = 'circular',
                        on_clicked = function()
                            set_count(count:get() + 1)
                        end,
                    },
                },
            },
        },
    }
end
