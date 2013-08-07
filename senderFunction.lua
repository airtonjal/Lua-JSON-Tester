local oo = require "loop.base"
local json = require "json"
--require "args"

MODES = {
  POST = "POST",
  GET = "GET",
  PUT = "PUT",
  DELETE = "DELETE"
}


Request = oo.class{
  -- default field values
  mode   = "POST",
}

function Request:__init()
  
end

-- The jsonStr and jsonTable are set on the args.lua file

if type(jsonData) == "table" then
  jsonData = json.encode(jsonData)
end



function request(jsonData, url, mode)
  if url == nil then
    error("\'url\' parameter cannot be nil")
  end
  
  mode = mode or "POST"
  
  if (mode ~= "GET") then
    if type(jsonData) ~= "table" then
      error("\'jsonData\' parameter must be a table")
    end
  end

  local curl = "curl -i -X %s -H \'Accept:application/json\' -H \'Content-Type:application/json\' "

  curl = curl:format(mode)
  curl = curl .. " -d \'" .. json.encode(jsonData) .. "\' \'" .. url .. "\'"

  print("\n", curl, "\n")

  os.execute(curl)
end

