-- Remaps string fields by adding a new 'raw' field not_analyzed
-- Reference: http://www.elastic.co/guide/en/elasticsearch/guide/current/aggregations-and-analysis.html

require "tests.elasticsearch.config"
require "utils.print"

local function delete_index(index)
  log.info("Removing index " .. index)
  return broker:request(METHOD.DELETE, index)
end

local remapping = { mappings = { pchr = { properties = { } } } }
local raw = {
  ['type'] = "string",
  fields = {
    raw = {
      ['type'] = "string",
      index = "not_analyzed"
    }
  }
}

local function split_dot(str)
  local ret = {}
  for part in string.gmatch(str, "([^\\.]+)") do
    table.insert(ret, part)
  end
  return ret
end

local function remap_index(index, index_type, fields) 
  log.info("Current " .. index .. " index mapping:")
  local index_status, responseStr = broker:request(METHOD.GET, index .. "/_mapping")
  if (index_status.error and index_status.status == 404) then
    log.info("Index does not exist, no need to delete it")
  else
    repeat
      log.warn("In order to remap the index it is required to delete it. Continue with this operation (y/n)? ")
      io.flush()
      answer = io.read()

      if (answer == 'n') then 
        log.info("Exitting program")
        return
      end
    until answer == "y"

    delete_index(index)
  end
  

  log.info("Remapping " .. index .. " text fields")
  for _, field in ipairs(fields) do
    log.info("Remapping " .. field .. " to include a raw copy")

    local properties = remapping.mappings[index_type].properties
    local split_fields = split_dot(field)

    for i, part in ipairs(split_fields) do 
      properties[part] = properties[part] or {}
      if (i ~= #split_fields) then
        properties[part].properties = properties[part].properties or {}
        properties = properties[part].properties
      else -- Last element (leaf node), the string field 
        properties[part] = raw
      end
    end
  end

  local data = broker:request(METHOD.PUT, index , remapping)
  if (data.acknowledged == true) then
    log.info("Index " .. index .. " remmaped with success")
  end
end

local my_index = "myindex"
local enum_fields = { "field1", "obj.fieldA", "a.b.c" }
local index_type = "mytype"
remap_index(my_index, index_type, enum_fields)

