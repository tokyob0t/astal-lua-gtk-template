local astal = require('astal')

local Widget = require('astal.gtk4.widget')
local astalify = require('astal.gtk4.astalify')

local Adw = astal.require('Adw', '1')
local Gio = astal.require('Gio', '2.0')

local WindowTitle = astalify(Adw.WindowTitle)

local HeaderBar = astalify(Adw.HeaderBar, {
    set_children = function(self, children)
        for _, ch in ipairs(children) do
            if ch.type == 'start' then
                self:pack_start(ch)
            elseif ch.type == 'center' then
                self.title_widget = ch
            elseif ch.type == 'end' then
                self:pack_end(ch)
            end
        end
    end,
    get_children = function()
        return {}
    end,
})

local action_group = require('lua.action_group')

---@param args { title: string | AstalLua.Binding<string>, subtitle: string | AstalLua.Binding<string>, type: string }
return function(args)
    local MenuButton = Widget.MenuButton

    local Menu, MenuItem = Gio.Menu, Gio.MenuItem

    return HeaderBar {
        type = args.type,
        show_end_title_buttons = true,
        WindowTitle {
            type = 'center',
            title = args.title,
            subtitle = args.subtitle,
        },
        MenuButton {
            type = 'end',
            icon_name = 'open-menu-symbolic',
            direction = 'DOWN',
            action_group = { 'win', action_group },
            Menu {
                MenuItem {
                    label = 'Reset Counter',
                    action = 'app.reset-counter',
                },
                MenuItem {
                    label = 'Keyboard Shortcuts',
                    action = 'win.shortcuts',
                },
                MenuItem {
                    label = 'About',
                    action = 'win.about',
                },
                Menu {
                    MenuItem {
                        label = 'Quit',
                        action = 'app.quit',
                    },
                },
            },
        },
    }
end
