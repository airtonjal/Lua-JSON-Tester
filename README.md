Lua-JSON-Tester
===============

A tool developed in Lua to test web applications based on REST that rely on the JSON standard

Configuration
=============
  - Add the Lua JSON Tester to your LUA_PATH

Dependencies:
  - [JSON4Lua](http://json.luaforge.net/)
  - [Loop](http://loop.luaforge.net/)
  - [Curl](http://curl.haxx.se/)
  
I recommend using [LuaRocks](http://luarocks.org) to install Lua packages. The [scripts/install.sh](https://github.com/airtonjal/Lua-JSON-Tester/blob/master/script/install.sh) file is a sample of how to install these dependencies

Usage
=====

To make a request do the following:

```lua
require "broker"
local broker = Broker ("wradar.br", 8080, PROTOCOLS.HTTP)
broker:requestAndPrint(METHOD.GET, "", "")
```

This will make a GET http request in port 8080, printing the result to the console.

If you want to acquire the result programmatically, use the requestJSON method:


```lua
require "broker"
local broker = Broker ("wradar.br", 8080, PROTOCOLS.HTTP)
broker:requestJSON(
  METHOD.GET, 
  "user/byAge",
  [[{"username":"airton","password":"mydummypassword"}]])
```

Tips:
  - If you are having problems using the tool, try setting the DEBUG flag to true on the config.lua file
