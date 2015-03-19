-- Dropped call by tac

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
    tacs = {
      terms = { field = "Call.TAC" }
    }
  }
}

function dropByTac()
  local data = broker:request(METHOD.POST, path, pchrindex)
  local result = {}
  for k, v in ipairs(data.aggregations.tacs.buckets) do
    table.insert(result, { tac = v.key, count = v.doc_count })
  end
  return result
end

for k, v in pairs(dropByTac()) do print(k .. "\tTAC: " .. v.tac, "\tcount: " .. v.count) end
