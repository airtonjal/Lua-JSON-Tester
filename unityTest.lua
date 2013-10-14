local testsTotal  = 0
local testsOK     = 0
local testsFailed = 0
local time        = os.time()

local function formatSourceLine(debugInfo)
  if not debugInfo then return ""
  else
    return debugInfo.source .. ": line " .. debugInfo.currentline
--[[
    source  @authentication.lua
    what    Lua
    func    function: 0x60005a280
    nups    0
    short_src       authentication.lua
    name    checkDefaultProfile
    currentline     26
    namewhat        upvalue
    linedefined     15
    lastlinedefined 29
]]--
  end
end

local function log(...)
  if (verbose) then 
    io.write("\t", formatSourceLine(debug.getinfo(4)), "\t")
    for _, v in ipairs({...}) do
      io.write(tostring(v), "\t")
    end 
    print() 
  end
end

local internalAssertEquals = function(p1, p2, level)
--  for k, v in pairs (debug.getinfo(3)) do print(k, v) end
  log("AssertEquals", p1, p2) 
  if p1 == p2 then return true end
  error("Assertion failed", level)
end

local internalAssertNotEquals = function(p1, p2, level)
  log("AssertNotEquals", p1, p2)
  if p1 ~= p2 then return true end
  error("Assertion failed", level)
end

local internalAssertNotNil = function(p1, level)
  log("AssertNotNil", p1)
  if p1 ~= nil then return true end
  error("Assertion failed", level)
end

local internalAssertType = function(p1, typeStr, level)
  log("AssertType", p1, typeStr)
  if type(p1) == typeStr then return true end
  error("Assertion failed", level)
end

checkError = function(err, ErrorDesc)
  internalAssertType(err, "table", 2)
  internalAssertType(ErrorDesc, "table", 2)
  internalAssertType(ErrorDesc.ErrorCode, "number", 2)
  internalAssertType(ErrorDesc.ErrorName, "string", 2)

  internalAssertEquals(err.ErrorCode, ErrorDesc.ErrorCode, 2)
  internalAssertEquals(err.ErrorName, ErrorDesc.ErrorName, 2) 
end

assertEquals = function(p1, p2)
  internalAssertEquals(p1, p2, 3)
end

assertNotEquals = function(p1, p2)
  internalAssertNotEquals(p1, p2, 3)
end

assertNotNil = function(p1)
  internalAssertNotNil(p1, 3)
end

assertType = function(p1, typeStr)
  internalAssertType(p1, typeStr, 3)
end

test = function(func, name, ...)  
  testsTotal = testsTotal + 1
  local status, res = pcall(func, ...)
  if verbose then print() end
  if status then
    testsOK = testsOK + 1
    print("Test " .. testsTotal .. " SUCCESS\t\t\"" .. name .. "\"")
  else
    testsFailed = testsFailed + 1
    print("Test " .. testsTotal .. " FAILED\t\t\"" .. name .. "\"\n", res)
  end
  if verbose then print() end

  return status, res
end

testsSummary = function()
--  print("\nTotal time: " .. os.date("!%X", (os.time() - time)))
  print("Total time: " .. os.date("!%X", (os.time() - time)), testsTotal .. " tests run", testsOK .. " tests were SUCCESSFULL", testsFailed .. " tests FAILED" )
end


