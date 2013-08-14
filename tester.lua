require "senderFunction"
-- Use here only an even value
local LINE_SIZE = 73
local printHead = function() print("|" .. string.rep("¯", LINE_SIZE - 2) .. "|\n|" .. string.rep(" ", LINE_SIZE - 2) .. "|") end
local printTail = function() print("|" .. string.rep(" ", LINE_SIZE - 2) .. "|\n|" .. string.rep("_", LINE_SIZE - 2) .. "|" ) end
local printBody = function(serviceName)
  local odd = serviceName:len() % 2 
  local size =  (LINE_SIZE - serviceName:len()) / 2
  print("|" .. string.rep(" ", size) .. serviceName .. string.rep(" ", LINE_SIZE - 1 - size - serviceName:len() - odd) .. "|")
end
local printInfo = function(serviceName) print("\n\n") printHead() printBody(serviceName) printTail() end

local serverURL = "https://localhost:44301/Service/Calculator.svc"
serverURL = serverURL .. "/%s"

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local requests = {
  Add       = { N1 = 4867, N2 = 867  },
  Subtract  = { N1 = 984,  N2 = 5948 },
  Multiply  = { N1 = 42,   N2 = 750  },
  Divide    = { N1 = 43,   N2 = 564  },
  Fibonacci = 25
}

for service, data in pairs(requests) do
  printInfo("Testing " .. service:upper() .. " service")
  request(data, string.format(serverURL, service), "POST", "xml")
end
print()

