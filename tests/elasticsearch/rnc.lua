-- Counts number of documents by rnc

require "tests.elasticsearch.config"

local pchrindex = {
  size = 0,
  aggs = {
    genders = {
      terms = { field = "Call.RncID" }
    }
  }
}

function groupByRnc()
  local data = broker:request(METHOD.POST, path, pchrindex)
  local result = {}
  for k, v in ipairs(data.aggregations.genders.buckets) do
    table.insert(result, { rnc = v.key, count = v.doc_count })
  end
  return result
end

for k, v in pairs(groupByRnc()) do print("rnc: " .. v.rnc, "count: " .. v.count) end
