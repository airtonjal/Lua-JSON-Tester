require "tests.elasticsearch.config"

function average(field)
  local pchrindex = {
    size = 0,
    aggs = {
      avg_duration = {
        avg = {
          field = field
        }
      }
    }
  }
  log.debug("Average call duration request")
  local data = broker:request(METHOD.POST, path:format(service), pchrindex)
  return data.aggregations.avg_duration.value
end

