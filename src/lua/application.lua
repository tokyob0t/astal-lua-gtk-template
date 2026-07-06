local astal = require('astal')

local Adw = astal.require('Adw', '1')
local GObject = astal.require('GObject', '2.0')
local Gio = astal.require('Gio', '2.0')

local settings = Gio.Settings {
    schema_id = package.domain,
}

---@class ExampleApp.ExampleApplication: Adw.Application
---@field window? Adw.ApplicationWindow | AstalLua.Astalified
---@overload fun(args: Adw.Application.ConstructorParams): ExampleApp.ExampleApplication
local Application = Adw.Application:derive('ExampleApp.ExampleApplication')

function Application:_container_add(child)
    if Gio.Action:is_type_of(child) then
        self:add_action(child)
    end
end

Application._property.window =
    GObject.ParamSpecObject('window', nil, nil, Adw.ApplicationWindow, { 'READWRITE' })

-- Application._attribute = {}

Application._attribute.accelerators = {}

function Application._attribute.accelerators:set(accelerators)
    for accel, action in pairs(accelerators) do
        self:set_accels_for_action(action, accel)
    end
end

return Application {
    application_id = package.domain,
    resource_base_path = package.resource,
    flags = { 'FLAGS_NONE' },
    accelerators = {
        [{ '<Ctrl>R' }] = 'app.reset-counter',
        [{ '<Ctrl>Q' }] = 'app.quit',
    },
    Gio.SimpleAction {
        name = 'reset-counter',
        on_activate = function()
            settings:set_int('simple-int', 0)
        end,
    },
    Gio.SimpleAction {
        name = 'quit',
        on_activate = function()
            Application.get_default():quit()
        end,
    },
}
