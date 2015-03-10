require "broker"
require "utils.print"

verbose = true

local broker = Broker ("ampere.poc.wr01.wradar.br", 9200, PROTOCOLS.HTTP)

--broker:requestAndPrint(METHOD.GET, "", {})

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
  broker:requestAndPrint(METHOD.POST, path:format(service), data)
end


