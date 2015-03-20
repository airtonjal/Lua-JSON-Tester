require "tests.elasticsearch.config"

function exists(field)
  local pchrsearch = {
    size = 0,
    filter = {
      exists = {
        field = field 
      }
    }
  }
  return broker:request(METHOD.POST, path, pchrsearch)
end

