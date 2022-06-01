export PATH=${PATH}:$HOME/.lua:$HOME/.local/bin:${GITHUB_WORKSPACE}/install/luarocks/bin
bash -x tests/gh_actions//setup_lua.sh
eval `$HOME/.lua/luarocks path`
