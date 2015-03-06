require "config.current"
local oo = require "loop.base"
local json = require "json"

METHOD = {
  POST = "POST",    GET = "GET",     PUT = "PUT",   DELETE = "DELETE"
}

CONTENTS = {
  JSON = "json",    XML  = "xml",    QUERY = "x-www-form-urlencoded"
}

PROTOCOLS = {
  HTTP  = "http",   HTTPS = "https"
}

DEFAULT_PORTS = {
  http  = 80,       https = 443
}

Broker = oo.class{
  server   = nil,
  port     = nil,
  protocol = nil
}

function Broker:__init(server, port, protocol)
  return oo.rawnew(self, {
    server   = server,
    port     = port,
    protocol = protocol
  })
end

local function formatURL(url, port, protocol, path)
  local urlTemplate = "%s://%s:%d/%s"
  return urlTemplate:format(protocol, url, port, path)
end

function Broker:requestJSON(url, port, protocol, method, path, data)
  if (url == nil) then
    error("\'url\' parameter cannot be nil")
  end
    
  -- Default function values
  method       = method       or METHOD.POST
  inputFormat  = CONTENTS.JSON
  outputFormat = CONTENTS.JSON
  protocol     = protocol     or PROTOCOLS.HTTP
  port         = port         or DEFAULT_PORTS[protocol]

  local body = encodeData(data, inputFormat)
  
  local curl = "curl -k -X %s -H \'Accept:application/%s\' -H \'Content-Type:application/%s\' "
  curl = curl:format(method, outputFormat, inputFormat)
 
  url = formatURL(url, port, protocol, path)

  if (method == "GET") then
    curl = curl .. " \'" .. url .. "\'"
  else
    curl = curl .. " -d \'" .. body .. "\' \'" .. url .. "\'"
  end

  curl = curl .. " 2>&1"

  --print("\n", curl, "\n")
  local handle = io.popen(curl)
  local result = handle:read("*a")  
  local split = splitLines(result)
  handle:close()
 
  -- Json contents is in the last line
  local lastLine = split[#split] 
  return json.decode(lastLine), lastLine
end

-- This is just a simpler function to avoid using requestJSON
function Broker:postJSON(path, data)
  -- These request parameters come from config.lua
  return requestJSON(SERVER, PORT, PROTOCOL, METHOD.POST, path, data)
end

function Broker:requestAndPrint(url, port, protocol, method, outputFormat, path, inputFormat, data, time)
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

function Broker:encodeData(data, contents)
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


