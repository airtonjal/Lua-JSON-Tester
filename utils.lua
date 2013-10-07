-- Use here only an even value
local LINE_SIZE = 79
local printHead = function() print("|" .. string.rep("¯", LINE_SIZE - 2) .. "|\n|" .. string.rep(" ", LINE_SIZE - 2) .. "|") end
local printTail = function() print("|" .. string.rep(" ", LINE_SIZE - 2) .. "|\n|" .. string.rep("_", LINE_SIZE - 2) .. "|" ) end
local printBody = function(serviceName)
  local odd = serviceName:len() % 2 
  local size =  (LINE_SIZE - serviceName:len()) / 2
  print("|" .. string.rep(" ", size) .. serviceName .. string.rep(" ", LINE_SIZE - 1 - size - serviceName:len() - odd) .. "|")
end

printInfo = function(serviceName) print("\n\n") printHead() printBody(serviceName) printTail() end

splitLines = function(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper(str:gsub("(.-)\r?\n", helper))
  return t
end

