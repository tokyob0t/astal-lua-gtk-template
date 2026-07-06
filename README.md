# astal-lua template for a Gtk Application

A simple Counter application built with **astal-lua + Gtk4 + Libadwaita**.

## Setup

It is recommended to use hererocks to create an isolated Lua environment

```sh
hererocks venv --lua 5.1 --luarocks ^
source venv/bin/activate
````

The project is built using LuaRocks, which internally invokes Meson

```sh
luarocks make
```

Before running the application, ensure the GSettings schemas are properly referenced

```sh
GSETTINGS_SCHEMA_DIR="$(pwd)/dist/share/glib-2.0/schemas" \
    ./dist/bin/astal-lua-gtk-template
```
