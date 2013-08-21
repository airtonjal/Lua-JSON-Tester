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

--local serverURL = "https://localhost:44301/Service/Calculator.svc/%s"

local serverURL = "localhost"

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
-- SERVICE      PARAMETER           REQUEST DATA
  Add       = {   pair =      { N1 = 4867, N2 = 867  } },
  Subtract  = {   pair =      { N1 = 984,  N2 = 5948 } },
  Multiply  = {   pair =      { N1 = 42,   N2 = 750  } },
  Divide    = {   pair =      { N1 = 43,   N2 = 564  } },
  Fibonacci = {   n    =                 25            }
}

local gets = {
  "GetName"
}

local path = "Service/Calculator.svc/%s"
-- Invoke services with POST requests
for service, data in pairs(posts) do
  printInfo("Testing " .. service:upper() .. " service with HTTP")
  request(serverURL, 4430,  PROTOCOLS.HTTP,  METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
  printInfo("Testing " .. service:upper() .. " service with HTTPS")
  request(serverURL, 44301, PROTOCOLS.HTTPS, METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
end

-- Invoke services with GET requests
--[[for _, service in ipairs(gets) do
  printInfo("Testing " .. service:upper() .. " service with HTTP")
  request(serverURL, 4430,  PROTOCOLS.HTTP,  METHOD.GET, CONTENTS.JSON, path:format(service))--, nil, nil, true)
  printInfo("Testing " .. service:upper() .. " service with HTTPS")
  request(serverURL, 44301, PROTOCOLS.HTTPS, METHOD.GET, CONTENTS.JSON, path:format(service))--, nil, nil, true)
end]]--

print()
