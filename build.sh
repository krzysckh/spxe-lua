#!/bin/sh

set -xe

[ -z $LUA_VERSION ] && LUA_VERSION="5.1"

usage() {
  echo "usage: $0 build | install | uninstall"
}

build() {
  wget https://raw.githubusercontent.com/LogicEu/spxe/main/spxe.h -O spxe.h
  cc  `pkg-config --cflags --libs glew glfw3` -x c -DSPXE_APPLICATION -fPIC \
    -shared spxe.h -o libspxe.so
}

install() {
  cp -v libspxe.so /usr/local/lib/libspxe.so
  cp -v spxe.lua /usr/local/share/lua/$LUA_VERSION/spxe.lua
}

uninstall() {
  rm -f /usr/local/lib/libspxe.so
  rm -f /usr/local/share/lua/$LUA_VERSION/spxe.lua
}

if [ -z "$1" ]; then
  build
else
  "$1" || usage
fi
