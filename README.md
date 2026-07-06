# astal-lua template for a Gtk Application

A simple Counter application built with **astal-lua + Gtk4 + Libadwaita**.

## Setup

This project no longer uses a custom build script.

### 1. Install dependencies (one time only)

It is recommended to use **hererocks** to create a Lua venv:

```sh
hererocks venv --lua 5.1 --luarocks ^
source venv/bin/activate
````

### 2. Build the project

The project is now built directly using LuaRocks:

```sh
luarocks make
```

### 3. Run the application

```sh
GSETTINGS_SCHEMA_DIR="$(pwd)/dist/share/glib-2.0/schemas" \
    ./dist/bin/astal-lua-gtk-template
```
