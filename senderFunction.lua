local oo = require "loop.base"
local json = require "json"
--require "args"

METHOD = {
  POST = "POST",
  GET = "GET",
  PUT = "PUT",
  DELETE = "DELETE"
}

CONTENTS = {
  JSON = "json",
  XML  = "xml",
  QUERY = "x-www-form-urlencoded"
}

PROTOCOLS = {
  HTTP  = "http",
  HTTPS = "https"
}

DEFAULT_PORTS = {
  http  = 80, 
  https = 443
}

local function formatURL(url, port, protocol, path)
  local urlTemplate = "%s://%s:%d/%s"
  return urlTemplate:format(protocol, url, port, path)
end

function request(url, port, protocol, method, outputFormat, path, inputFormat, data, time)
  if (url == nil) then
    error("\'url\' parameter cannot be nil")
  end
    
  -- Default function values
  method       = method       or METHOD.POST
  inputFormat  = inputFormat  or CONTENTS.JSON
  outputFormat = outputFormat or CONTENTS.JSON
  protocol     = protocol     or PROTOCOLS.HTTP
  port         = port         or DEFAULT_PORTS[protocol]

  local body = encodeData(data, inputFormat)
  
  local curl = "curl -k -i -X %s -H \'Accept:application/%s\' -H \'Content-Type:application/%s\' "
  curl = curl:format(method, outputFormat, inputFormat)
 
  url = formatURL(url, port, protocol, path)

  if (method == "GET") then
    curl = curl .. " \'" .. url .. "\'"
  else
    curl = curl .. " -d \'" .. body .. "\' \'" .. url .. "\'"
  end

  if (time) then curl = "time " .. curl end

  print("\n", curl, "\n")

  os.execute(curl)
end

function encodeData(data, contents)
  if (contents == nil) then
  elseif (contents == CONTENTS.XML) then
    error("XML input format not yet supported")
  elseif (contents == CONTENTS.JSON) then
    -- TODO: Temporary solution, assuming that server will receive only one parameter
    --for k, v in pairs(data) do
    --  return json.encode(v)
    --end
    return json.encode(data)
  elseif (contents == CONTENTS.QUERY) then
    local queryString = ""
    for k, v in pairs(data) do
      queryString = queryString .. k .. "=" .. v .. "&"
    end
    -- Removes trailing '&' char
    return queryString:sub(1, queryString:len() - 1)
  else
    error("Parameter \"contents\" not recognized")
  end
end


