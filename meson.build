# FIXME: rename
project('astal-lua-gtk-template', version: '0.1.0')
domain = 'xyz.example.luaApplication'
resource = '/xyz/example/luaApplication'
lua_version = '5.1'

name = meson.project_name()
version = meson.project_version()

root = meson.current_source_dir()
prefix = get_option('prefix')
libdir = prefix / get_option('libdir')
datadir = prefix / get_option('datadir')
bindir = prefix / get_option('bindir')
pkgdatadir = datadir / name

lua = find_program('lua' + lua_version)
luarocks = find_program('luarocks')
bundle_lua = find_program('bundle-lua')

LUAROCKS_PATH = run_command(luarocks, 'path', '--lr-path', check: true).stdout().strip()

MODULES_PATH = ';'.join(
  [
    LUAROCKS_PATH,
    meson.project_source_root() / 'src/lua/?.lua',
    meson.project_source_root() / 'src/?.lua',
  ],
)

custom_target(
  input: configure_file(
    input: 'src/init.in.lua',
    output: 'init.in.lua',
    configuration: {
      'lua': lua.full_path(),
      'resource': resource,
      'domain': domain,
      'version': version,
    },
  ),
  command: [
    bundle_lua,
    '@INPUT@',
    '-o', '@OUTPUT@',
    '-i', MODULES_PATH,
    '--ignore', 'LuaGObject;lgi',
    '--verbose',
    '--no-animals',
  ],
  output: name,
  install: true,
  install_dir: bindir,
)

configure_file(
  input: 'data/desktop.in.desktop',
  output: domain + '.desktop',
  configuration: {'exe': bindir / name},
  install: true,
  install_dir: datadir / 'applications',
)

configure_file(
  input: 'data/gschema.in.xml',
  output: domain + '.gschema.xml',
  configuration: {'resource': resource, 'domain': domain},
  install: true,
  install_dir: datadir / 'glib-2.0' / 'schemas',
)

test(
  'validate-gschema',
  find_program('glib-compile-schemas'),
  args: [
    '--strict',
    '--dry-run', meson.current_source_dir(),
  ],
)

import('gnome').post_install(
  # gtk_update_icon_cache: true,
  glib_compile_schemas: true,
  update_desktop_database: true,
)
