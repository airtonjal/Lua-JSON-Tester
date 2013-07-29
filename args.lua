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
    
        --mode=<mode>     Mode to send JSON. This can be any HTTP method (POST, GET, PUT, DELETE).
                          Use "URL" to send as a parameter on the URL query string or "COOKIE" to send as a cookie.
                          If you use URL or COOKIE the name parameter MUST be set
                     
        --name=<name>     If the mode is URL this indicates the URL query string ]]
  print (msg)
  os.exit(1)
end

debug("\n  ..... Starting arguments parsing .....")

if (#arg == 0) then
  showUsageAndExit( "Missing arguments" )
end

status, url, jsonTable, jsonStr = pcall(dofile, arg[1])

-- If an error wais raised, it will be placed on the url variable
if not status then
  showUsageAndExit(url)
end

debug("\n  JSON data file:", "\n\t" .. arg[1] )
debug("  URL:\n\t" .. url)

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

if #flags > 0 then 
  debug("  Flags:")
  for _, flag in ipairs(flags) do debug("\t" .. flag) end
  debug("")
end

for var, val in pairs(args) do
  debug("  " .. var .. ":\n\t" .. val )
end

if not args.mode then
  debug("  [INFO] No mode found, using default one " .. DEFAULT_MODE .. "\n")
  args.mode = DEFAULT_MODE
elseif args.mode == "URL" then
  if args.name then
    args.query_string = args.name
    debug("  query_string" .. ":\n\t" .. args.query_string )
  else
    showUsageAndExit("  [ERROR]\tSpecified mode is URL but no name parameter was found on the arguments list\n")
  end
end

debug("\n  ..... Finishing arguments parsing .....\n")

