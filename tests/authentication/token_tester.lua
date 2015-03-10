require "config.current"
require "broker"
require "utils.print"
require "log".level = "debug"

httpPort      = 8080  -- Outgoing http port
httpsPort     = 443 -- Outgoing https port

--SERVER        = "10.8.0.214"
SERVER        = "HWS01DEV"
PROTOCOL      = PROTOCOLS.HTTP
PORT          = httpPort

local broker = Broker(SERVER, PORT, PROTOCOL)

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
    broker:requestAndPrint(METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.JSON, data, true)
  end
end

for i = 1, 1 do
  test()
end

print()
