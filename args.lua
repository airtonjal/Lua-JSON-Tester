require "config"

local function debug(...)
  if (DEBUG) then print(...) end
end

local function showUsageAndExit(err)
  local msg = err or ""
  msg = msg .. "\n" .. [[
  Correct usage: lua ]] .. arg[0] .. [[ LUA_FILE_PATH]]
  print (msg)
  os.exit(1)
end

if (#arg == 0) then
  showUsageAndExit( "Missing arguments" )
end

debug("\n  JSON data file:", "\n\n\t" .. arg[1] .. "\n")

flags = {}  -- Command line flags
args = {}   -- key/value arguments

for i = 2, #arg, 1 do
  local flag = arg[i]:match("^%-%-(.*)")
  if (flag) then
    local var, val = flag:match("([a-z_%-]*)=(.*)")
    if (val) then -- it's a value
      args[var] = val
    else --it's a flag
      table.insert(flags, flag)
    end
  end
end

debug("  Flags:") 
for _, flag in ipairs(flags) do
  debug("\t" .. flag)
end
debug("")

for var, val in pairs(args) do
  debug("  " .. var .. ":\n\n\t" .. val .. "\n")
end

status, jsonTable, jsonStr = pcall(dofile, arg[1])

-- If an error wais raised, it will be placed on the jsonTable variable
if not status then
  showUsageAndExit(jsonTable)
end

