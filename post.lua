local json = require "json"

local function showUsageAndExit(err)
  local msg = err or ""
  msg = msg .. "\n" .. [[
    Correct usage: lua ]] .. arg[0] .. [[ LUA_FILE_PATH]]
  print (msg)
  os.exit(1)
end

if (#arg == 0) then
  showUsageAndExit( "Missing argument" )
end

local status, jsonTable, jsonStr = pcall(dofile, arg[1])

-- If an error wais raised, it will be placed on the jsonTable variable
if not status then
  showUsageAndExit(jsonTable)
end

if jsonStr then 
  print("JSON String:\n" .. jsonStr)
end

if jsonTable then
  print(json.encode(jsonTable))
end

--table.foreach(json.decode(jsonStr), print)
--print(toStringArch(json.decode(jsonStr)))


