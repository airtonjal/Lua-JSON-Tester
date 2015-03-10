-- Acquires the minimum and maximum call timestamps

require "broker"
require "utils.print"
require "log".level = "info"

local path = "pchrindex/_search?pretty"
local broker = Broker ("ampere.poc.wr01.wradar.br", 9200, PROTOCOLS.HTTP)

local pchrsearch = {
  size = 0,
  aggs = {
    min_time = {
      min = {
        field = "Call.StartTime"
      }
    }
  }
}

local data = broker:request(METHOD.POST, path, pchrsearch)
print("\nMinimum call start time " .. data.aggregations.min_time.value)

local pchrsearch = {
  size = 0,
  aggs = {
    max_time = {
      max = {
        field = "Call.StartTime"
      }
    }
  }
}

local data = broker:request(METHOD.POST, path, pchrsearch)
print("Maximum call start time " .. data.aggregations.max_time.value)
