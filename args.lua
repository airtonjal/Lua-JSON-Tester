require "config"

local function debug(...)
  if (DEBUG) then print(...) end
end

local function showUsageAndExit(err)
  local msg = err or ""
  msg = msg .. "\n" .. [[
  Correct usage: lua LUA_FILE [OPTIONS]
    
    [LUA_FILE] Any Lua file that returns a JSON either as a string or as a Lua table.
  
    [OPTIONS]:
    
        --mode=<mode>     Mode to send JSON. Either "POST", "GET" for the equivalent HTTP methods
                          Use "URL" to send as a parameter on the url or "COOKIE" to send as a cookie]]
  print (msg)
  os.exit(1)
end

if (#arg == 0) then
  showUsageAndExit( "Missing arguments" )
end

status, jsonTable, jsonStr = pcall(dofile, arg[1])

-- If an error wais raised, it will be placed on the jsonTable variable
if not status then
  showUsageAndExit(jsonTable)
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

if not args.mode then
  debug("  No mode found, using default one " .. DEFAULT_MODE)
end

