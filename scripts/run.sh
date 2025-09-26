#!/usr/bin/env bash

sh scripts/build.sh

export GSETTINGS_SCHEMA_DIR="$(pwd)/dist/share/glib-2.0/schemas"

astal-lua run dist/bin/* --gtk4 --nvidia --vulkan
