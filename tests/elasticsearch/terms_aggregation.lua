require "tests.elasticsearch.config"

function terms(field)
  local pchrindex = {
    size = 0,
    aggs = {
      setup_type = {
        terms = { field = field }
      }
    }
  }
  return broker:request(METHOD.POST, path, pchrindex)
end
