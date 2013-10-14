require "config.current"
require "senderFunction"
require "utils"

local token = arg[1]

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
  -- SERVICE               PARAMETERS
  GetUserProfile = token,
  RenewToken  = token,
  --InvalidateToken = token,
}

local path = "WFS/Service/Impl/Authentication.svc/%s"

function test()
  -- Invoke services with POST requests
  for service, data in pairs(posts) do
    printInfo("Testing " .. service:upper() .. " service with HTTPS")
    requestAndPrint(SERVER, PORT, PROTOCOL, METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.JSON, data, true)
  end
end

for i = 1, 1 do
  test()
end

print()
