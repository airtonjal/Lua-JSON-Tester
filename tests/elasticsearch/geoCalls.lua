require "tests.elasticsearch.config"

local pchrsearch = {
  size = 0,
  filter = {
    exists = {
      field = "Events.Geolocation"
    }
  }
}

function geoCalls()
  local data = broker:request(METHOD.POST, path, pchrsearch)
  return data.hits.total
end

print(geoCalls())
