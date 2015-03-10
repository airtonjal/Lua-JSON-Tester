require "broker"
require "utils.print"

verbose = true

local broker = Broker ("ampere.poc.wr01.wradar.br", 9200, PROTOCOLS.HTTP)

broker:requestAndPrint(METHOD.GET, CONTENTS.JSON, "", CONTENTS.JSON, {})

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



local aggregations = {
  pchrindex = {
    query = {
      filtered = {
        filter = {
          bool = {
            must = {
              {
                range = {
                  ["Call.StarTime"] = {
                    gte = 1406911815539,
                    lte = 1406911815541
                  }
                }
              }
            }
          }
        }
      }
    },
    aggs = {
      avg_duration = {
        avg = {
          field = "Call.CallDuration"
        }
      }
    }
  }
}

local path = "%s/_search?pretty"
for service, data in pairs(aggregations) do
  printInfo("Average call duration request")
  broker:requestAndPrint(METHOD.POST, CONTENTS.JSON, path:format(service), CONTENTS.JSON, data)
end


