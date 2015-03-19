-- Dropped call by release cause 

require "tests.elasticsearch.config"

local pchrindex = {
  size = 0,
  query = {
    filtered = {
      filter = {
        term = { ['Call.RrcDrop'] = true }
      }
    }
  },
  aggs = {
    setup_type = {
      terms = { field = "Call.RrcRelErrorCause.raw" }
    }
  }
}

function dropByRelease()
  local data = broker:request(METHOD.POST, path, pchrindex)
  local result = {}
  for k, v in ipairs(data.aggregations.setup_type.buckets) do
    table.insert(result, { cause = v.key, count = v.doc_count })
  end
  return result
end

for i, drop in pairs(dropByRelease()) do print(i .. "\tRelease cause: \"" .. drop.cause .. "\"\tcount: " .. drop.count) end
