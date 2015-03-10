require "config.current"

-- Use here only an even value
local LINE_SIZE = 79
local printHead = function() print("|" .. string.rep("¯", LINE_SIZE - 2) .. "|\n|" .. string.rep(" ", LINE_SIZE - 2) .. "|") end
local printTail = function() print("|" .. string.rep(" ", LINE_SIZE - 2) .. "|\n|" .. string.rep("_", LINE_SIZE - 2) .. "|" ) end
local printBody = function(serviceName)
  local odd = serviceName:len() % 2 
  local size =  (LINE_SIZE - serviceName:len()) / 2
  print("|" .. string.rep(" ", size) .. serviceName .. string.rep(" ", LINE_SIZE - 1 - size - serviceName:len() - odd) .. "|")
end

printInfo = function(serviceName) print("\n") printHead() printBody(serviceName) printTail() end

splitLines = function(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper(str:gsub("(.-)\r?\n", helper))
  return t
end

serverInfo = function()
  print(string.format("Server %s\tProtocol %s\tPort %s", SERVER, PROTOCOL, PORT))
end

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  --if (ident and ident > 2) then return end
  if type(tt) == "table" then
    for key, value in pairs (tt) do
      io.write(string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        io.write(string.format("[%s] => " .. tostring(value) .. "\n", tostring (key)));
        --io.write(string.rep (" ", indent )) -- indent it
        --io.write("(\n");
        table_print (value, indent + 2, done)
        io.write(string.rep (" ", indent)) -- indent it
        --io.write(")\n");
      else
        io.write(string.format("[%s] => %s\n", tostring (key), tostring(value)))
    end
  end
  else
    io.write(tt .. "\n")
  end
end


function toStringArch(tt, indent, done)
  done = done or {}
  indent = indent or 0
  ret = ""
  --if (ident and ident > 2) then return end
  if type(tt) == "table" then
    for key, value in pairs (tt) do
      ret = ret .. string.rep (" ", indent) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        ret = ret .. toStringArch(value, indent + 2, done)
      else
        ret = ret .. string.format("[%s] => %s\n", tostring(key), tostring(value))
      end
    end
--  else
--    ret = ret .. tt .. "\n"
  end
  return ret
end

