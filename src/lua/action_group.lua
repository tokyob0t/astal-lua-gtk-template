local astal = require('astal')

local app = require('lua.application')
local astalify = require('astal.gtk4.astalify')

local Adw = astal.require('Adw', '1')
local Gio = astal.require('Gio', '2.0')

local AboutDialog = astalify(Adw.AboutDialog, {
    get_children = function()
        return {}
    end,
})

return Gio.SimpleActionGroup {
    Gio.SimpleAction {
        name = 'about',
        on_activate = function()
            AboutDialog {
                application_name = 'Example Application',
                application_icon = 'application-x-executable',
                copyright = '© 2026 Your Name',
                developer_name = 'Your Name',
                issue_url = 'https://github.com/tokyob0t/astal-lua-gtk-template/issues',
                license_type = 'GPL_3_0',
                version = package.version,
                website = 'https://github.com/tokyob0t/astal-lua-gtk-template',
                setup = function(self)
                    self:add_acknowledgement_section('Built with', {
                        'AstalLua https://github.com/tokyob0t/astal-lua',
                    })

                    self:present(app.active_window)
                end,
            }
        end,
    },
}
