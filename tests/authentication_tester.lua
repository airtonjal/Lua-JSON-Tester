require "config"
require "senderFunction"
require "utils"

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
  -- SERVICE               PARAMETERS
  --Login = {  User = "quality_1", Password = "V1rtu@L..."  },
  Login = { User = "quality_1", Password = "qubit2600"  },
  --Login = { User = "erick.moura", Password="t0rr35m0"},
  --Login = {  User = "quality_1", Password = "qubit2600"  },
}

local path = "WFS/Service/Impl/Authentication.svc/%s"

function test()
  -- Invoke services with POST requests
  for service, data in pairs(posts) do
  --  printInfo("Testing " .. service:upper() .. " service with HTTP")
  --  request(serverAddress, 4430,  PROTOCOLS.HTTP,  METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.JSON, data)
    printInfo("Testing " .. service:upper() .. " service with HTTPS")
    requestAndPrint(SERVER, PORT, PROTOCOL, METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.JSON, data, true)
  end
end

for i = 1, arg[1] or 1 do
  test()
end

print()
