#!@lua@

package.domain, package.resource, package.version = '@domain@', '@resource@', '@version@'

package.preload.lgi = function()
    return require('LuaGObject')
end

local AppWindow = require('lua.widgets.appwindow')

local app = require('lua.application')

function app:on_activate()
    if self.window then
        return self.window:present()
    end

    self.window = AppWindow {
        application = self,
    }

    self.window:present()
end

os.exit(app:run { arg[0], ... })
