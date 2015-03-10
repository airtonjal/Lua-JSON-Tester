require "broker"
require "utils.print"
require "log".level = "debug"

httpPort      = 8080  -- Outgoing http port
httpsPort     = 443 -- Outgoing https port

--SERVER        = "10.8.0.214"
local SERVER        = "HWS01DEV"
local PROTOCOL      = PROTOCOLS.HTTP
local PORT          = httpPort

local broker = Broker (SERVER, PORT, PROTOCOL)

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local imsis = {
  "706030011334680"
}

local path = "cdr-rest/huawei/tigo/search/imsi/%s"

function test()
  -- Invoke services with POST requests
  for _, imsi in pairs(imsis) do
  --  printInfo("Testing " .. service:upper() .. " service with HTTP")
  --  request(serverAddress, 4430,  PROTOCOLS.HTTP,  METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.JSON, data)
    printInfo("Testing " .. imsi .. " service with HTTP")
    broker:requestAndPrint(METHOD.GET, CONTENTS.JSON, path:format(imsi), CONTENTS.JSON, nil, true)
  end
end

for i = 1, arg[1] or 1 do
  test()
end

print()
