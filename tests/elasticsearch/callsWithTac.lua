-- Count the number of calls with tac field
require "tests.elasticsearch.config"

local pchrsearch = {
  size = 0,
  filter = {
    exists = {
      field = "Call.Phone.tac"
    }
  }
}

function callsWithTac()
  local data = broker:request(METHOD.POST, path, pchrsearch)
  return data.hits.total
end

print("Calls with tac: " .. callsWithTac())
