require "tests.elasticsearch.config"

printInfo("Testing root request with HTTP")
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
  broker:requestAndPrint(METHOD.POST, path:format(service), data)
end

print()
