-- Dropped call by phone model

require "tests.elasticsearch.config"

local pchrindex = {
  size = 0,
  aggs = {
    setup_type = {
      terms = { field = "Call.Phone.phoneModel.raw" }
    }
  }
}

function callsByPhone()
  local data = broker:request(METHOD.POST, path, pchrindex)
  local result = {}
  for k, v in ipairs(data.aggregations.setup_type.buckets) do
    table.insert(result, { phone = v.key, count = v.doc_count })
  end
  return result
end

for i, phone in pairs(callsByPhone()) do print(i .. "\tPhone model: \"" .. phone.phone .. "\"\tCalls: " .. phone.count) end
