require "tests.elasticsearch.config"

function stats(field)
  local pchrindex = {
    size = 0,
    aggs = {
      ts = {
        stats = { field = field }
      }
    }
  }
  return broker:request(METHOD.POST, path, pchrindex)
end

