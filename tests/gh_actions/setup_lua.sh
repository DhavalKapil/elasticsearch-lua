#! /bin/bash

# A script for setting up environment for github-actions testing.
# Sets up Lua and Luarocks.
# LUA must be "lua5.1", "lua5.2", "5.3" or "luajit".
# luajit2.0 - master v2.0
# luajit2.1 - master v2.1

set -eufo pipefail

LUAJIT_BASE="LuaJIT-2.0.5"

source $GITHUB_WORKSPACE/tests/gh_actions/platform.sh

LUA_HOME_DIR=$GITHUB_WORKSPACE/install/lua

LR_HOME_DIR=$GITHUB_WORKSPACE/install/luarocks

mkdir $HOME/.lua

LUAJIT="no"

if [ "$PLATFORM" == "macosx" ]; then
  if [ "$LUA" == "luajit2.0" ]; then
    LUAJIT="yes";
  fi
  if [ "$LUA" == "luajit2.1" ]; then
    LUAJIT="yes";
  fi;
elif [ "$(expr substr $LUA 1 6)" == "luajit" ]; then
  LUAJIT="yes";
fi

mkdir -p "$LUA_HOME_DIR"

if [ "$LUAJIT" == "yes" ]; then

  git clone https://github.com/luajit/luajit.git -b v2.0 $LUAJIT_BASE;

  cd $LUAJIT_BASE

  if [ "$LUA" == "luajit2.1" ]; then
    git checkout v2.1;
    # force the INSTALL_TNAME to be luajit
    perl -i -pe 's/INSTALL_TNAME=.+/INSTALL_TNAME= luajit/' Makefile
  fi

  make && make install PREFIX="$LUA_HOME_DIR"

  if [ "$LUA" == "luajit2.1" ]; then
    ln -s $LUA_HOME_DIR/bin/luajit-2.1.0-beta1 $HOME/.lua/luajit
    ln -s $LUA_HOME_DIR/bin/luajit-2.1.0-beta1 $HOME/.lua/lua;
  else
    ln -s $LUA_HOME_DIR/bin/luajit $HOME/.lua/luajit
    ln -s $LUA_HOME_DIR/bin/luajit $HOME/.lua/lua;
  fi;

else

  if [ "$LUA" == "lua5.1" ]; then
    curl http://www.lua.org/ftp/lua-5.1.5.tar.gz | tar xz
    cd lua-5.1.5;
  elif [ "$LUA" == "lua5.2" ]; then
    curl http://www.lua.org/ftp/lua-5.2.4.tar.gz | tar xz
    cd lua-5.2.4;
  elif [ "$LUA" == "lua5.3" ]; then
    curl http://www.lua.org/ftp/lua-5.3.3.tar.gz | tar xz
    cd lua-5.3.3;
  fi

  # Build Lua without backwards compatibility for testing
  perl -i -pe 's/-DLUA_COMPAT_(ALL|5_2)//' src/Makefile
  make $PLATFORM
  make INSTALL_TOP="$LUA_HOME_DIR" install;

  ln -s $LUA_HOME_DIR/bin/lua $HOME/.lua/lua
  ln -s $LUA_HOME_DIR/bin/luac $HOME/.lua/luac;

fi

cd $GITHUB_WORKSPACE

lua -v

LUAROCKS_BASE=luarocks-$LUAROCKS

curl --location http://luarocks.org/releases/$LUAROCKS_BASE.tar.gz | tar xz

cd $LUAROCKS_BASE

if [ "$LUA" == "luajit2.0" ]; then
  ./configure --lua-suffix=jit --with-lua-include="$LUA_HOME_DIR/include/luajit-2.0" --prefix="$LR_HOME_DIR";
elif [ "$LUA" == "luajit2.1" ]; then
  ./configure --lua-suffix=jit --with-lua-include="$LUA_HOME_DIR/include/luajit-2.1" --prefix="$LR_HOME_DIR";
else
  ./configure --with-lua="$LUA_HOME_DIR" --prefix="$LR_HOME_DIR"
fi

make build && make install

ln -s $LR_HOME_DIR/bin/luarocks $HOME/.lua/luarocks

cd $GITHUB_WORKSPACE

luarocks --version

rm -rf $LUAROCKS_BASE

if [ "$LUAJIT" == "yes" ]; then
  rm -rf $LUAJIT_BASE;
elif [ "$LUA" == "lua5.1" ]; then
  rm -rf lua-5.1.5;
elif [ "$LUA" == "lua5.2" ]; then
  rm -rf lua-5.2.4;
elif [ "$LUA" == "lua5.3" ]; then
  rm -rf lua-5.3.3;
fi
