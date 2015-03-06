require "config.current"
require "broker"
require "utils"

verbose = true

local broker = Broker ("ampere.poc.wr01.wradar.br", 9200, PROTOCOLS.HTTP)

broker:requestAndPrint(METHOD.GET, CONTENTS.JSON, "", CONTENTS.QUERY, {})

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
  -- SERVICE               PARAMETERS
  search = { query = {  }   },
}

local path = "%s"
-- Invoke services with POST requests
for service, data in pairs(posts) do
  printInfo("Testing " .. service:upper() .. " with HTTP")
  broker:requestAndPrint(METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
end

rint()
