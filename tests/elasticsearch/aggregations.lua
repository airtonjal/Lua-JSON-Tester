require "tests.elasticsearch.config"

--broker:requestAndPrint(METHOD.GET, "", {})

local pchrindex = {
  size = 0,
  aggs = {
    avg_duration = {
      avg = {
        field = "Call.CallDuration"
      }
    }
  }
}

function averageCallDuration()
  log.debug("Average call duration request")
  local data = broker:request(METHOD.POST, path:format(service), pchrindex)
  return data.aggregations.avg_duration.value
end

print(averageCallDuration())
