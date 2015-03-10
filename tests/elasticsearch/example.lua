--require "config.current"
require "broker"
require "utils.print"
require "log".level = "debug"

local broker = Broker ("ampere.poc.wr01.wradar.br", 9200, PROTOCOLS.HTTP)

printInfo("Testing root request with HTTP")
--broker:requestAndPrint(METHOD.GET, "", "pchrindex")
broker:requestAndPrint(METHOD.GET)

-- Request table. Each key is a method name and each value is the object to convert to json data on the POST request
local posts = {
  -- SERVICE               PARAMETERS
  pchrindex = { 
    query = { 
      bool = { 
        must = { 
          { match_all = { } } 
        }
      }
    },
    from = 0,
    size = 10
  },
}

local tacs = {
  pchrindex = {
    size = 1,
    filter = {
      exists = {
        field = "Call.Phone.tac"
      }
    }
  }
}

local path = "%s/_search"
-- Invoke services with POST requests
for service, data in pairs(tacs) do
  printInfo("Testing " .. service:upper() .. " with HTTP")
  broker:requestAndPrint(METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.JSON, data)
end

print()
