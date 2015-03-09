echo "Installing Lua packages"
yum -y install curl lua lua-devel gcc

echo "Retrieving LuaRocks"
wget http://luarocks.org/releases/luarocks-2.2.0.tar.gz
tar zxpf luarocks-2.2.0.tar.gz
cd luarocks-2.2.0

echo "Installing LuaRocks"
./configure; sudo make bootstrap

echo "Installing Lua dependencies"
luarocks install luasec
luarocks install json4lua
luarocks install loop

cd ..

echo "Removing LuaRocks temp dir"
rm -rf luarocks-2.2.0*
