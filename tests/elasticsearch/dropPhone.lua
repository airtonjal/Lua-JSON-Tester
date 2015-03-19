-- Dropped call by phone model

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
      terms = { field = "Call.Phone.phoneModel.raw" }
    }
  }
}

function dropByPhone()
  local data = broker:request(METHOD.POST, path, pchrindex)
  local result = {}
  for k, v in ipairs(data.aggregations.setup_type.buckets) do
    table.insert(result, { phone = v.key, count = v.doc_count })
  end
  return result
end

for i, drop in pairs(dropByPhone()) do print(i .. "\tPhone model: \"" .. drop.phone .. "\"\tcount: " .. drop.count) end
