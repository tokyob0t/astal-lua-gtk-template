---@diagnostic disable:lowercase-global

package = 'template'
version = '0.1.0-1'

source = { url = 'file://src/' }

description = {
    summary = 'A simple counter application',
    homepage = 'https://github.com/tokyob0t/astal-lua-gtk-template',
    license = 'LGPL-2.1',
}

dependencies = { 'lua >= 5.1', 'astal', 'luagobject', 'bundle.lua' }

build = {
    type = 'command',
    build_command = [[
        meson setup --prefix "$PWD/dist" build --wipe
        meson install -C build
    ]],
    install_command = [[
        chmod +x $PWD/dist/bin/*
    ]],
}
