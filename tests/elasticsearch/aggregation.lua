require "config.current"
require "senderFunction"
require "utils"

local token = arg[1]
local SERVER = "ampere.poc.wr01.wradar.br"
local PORT = 9200
local PROTOCOL = http

DEBUG = true

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
  -- SERVICE               PARAMETERS
  search = { query = {  }   },
}

requestAndPrint(SERVER, PORT, PROTOCOL, METHOD.GET, CONTENTS.JSON, "", CONTENTS.QUERY, {})

local path = "%s"
-- Invoke services with POST requests
for service, data in pairs(posts) do
  printInfo("Testing " .. service:upper() .. " with HTTP")
  requestAndPrint(SERVER, PORT, PROTOCOL, METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.QUERY, data)
end

rint()
