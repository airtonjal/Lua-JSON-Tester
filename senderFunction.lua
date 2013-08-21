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

function request(url, port, protocol, method, outputFormat, path, inputFormat, data)
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


  print("\n", curl, "\n")

  os.execute(curl)
end

function encodeData(data, contents)
  if (contents == nil) then
  elseif (contents == CONTENTS.XML) then
    error("XML input format not yet supported")
  elseif (contents == CONTENTS.JSON) then
    return json.encode(data)
  else
    error("Parameter \"contents\" not recognized")
  end
end


