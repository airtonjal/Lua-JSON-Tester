require "config"
require "senderFunction"
require "utils"

local token = arg[1]

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
  -- SERVICE               PARAMETERS
  ApplyEdits = { token = token },
}


local path = "WFS/Service/Impl/Notes.svc/%s"
-- Invoke services with POST requests
for service, data in pairs(posts) do
  --printInfo("Testing " .. service:upper() .. " service with HTTP")
  --request(serverAddress, 4430,  PROTOCOLS.HTTP,  METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
  printInfo("Testing " .. service:upper() .. " service with HTTPS")
  requestAndPrint(serverAddress, httpsPort, PROTOCOLS.HTTPS, METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
end

print()
