-- Dropped call by setup type

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
      terms = { field = "Call.CallSetupType.raw" }
    }
  }
}

function dropByCallType()
  local data = broker:request(METHOD.POST, path, pchrindex)
  local result = {}
  for k, v in ipairs(data.aggregations.setup_type.buckets) do
    table.insert(result, { setup_type = v.key, count = v.doc_count })
  end
  return result
end

for i, drop in pairs(dropByCallType()) do print(i .. "\tCall setup type: \"" .. drop.setup_type .. "\"\tcount: " .. drop.count) end
