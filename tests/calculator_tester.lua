require "senderFunction"
require "utils"

local serverAddress = "localhost"

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
-- SERVICE      PARAMETER           REQUEST DATA
  Add       = {  N1 = 4867, N2 = 867  },
  Subtract  = {  N1 = 984,  N2 = 5948 },
  Multiply  = {  N1 = 42,   N2 = 750  },
  Divide    = {  N1 = 43,   N2 = 564  },
  Fibonacci = {  n  = 25              }
}

local gets = {
  "GetName"
}

local path = "Service/Impl/Calculator.svc/%s"
-- Invoke services with POST requests
for service, data in pairs(posts) do
  printInfo("Testing " .. service:upper() .. " service with HTTP")
  request(serverAddress, 4430,  PROTOCOLS.HTTP,  METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
  printInfo("Testing " .. service:upper() .. " service with HTTPS")
  request(serverAddress, 44301, PROTOCOLS.HTTPS, METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
end

-- Invoke services with GET requests
for _, service in ipairs(gets) do
  printInfo("Testing " .. service:upper() .. " service with HTTP")
  request(serverAddress, 4430,  PROTOCOLS.HTTP,  METHOD.GET, CONTENTS.JSON, path:format(service))--, nil, nil, true)
  printInfo("Testing " .. service:upper() .. " service with HTTPS")
  request(serverAddress, 44301, PROTOCOLS.HTTPS, METHOD.GET, CONTENTS.JSON, path:format(service))--, nil, nil, true)
end

print()
