-- Acquires the minimum and maximum call startime values

require "tests.elasticsearch.config"

local pchrindex = {
  size = 0,
  aggs = {
    ts = {
      stats = { field = "Call.StartTime" }
    }
  }
}

function timestamps()
  local data = broker:request(METHOD.POST, path, pchrindex)
  return data.aggregations.ts.min, data.aggregations.ts.max
end
local min, max = timestamps()
print(min, max)

