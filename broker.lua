local oo = require "loop.base"
local json = require "json"
local log = require "log"

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

Broker = oo.class{}

function Broker:__init(server, port, protocol)
  local self = oo.rawnew(self, {})

  log.info("Creating broker object")

  if (type(server)   ~= "string") then 
    error("\'server\' parameter must be a string, but instead a "   .. type(server)   .. " was provided")
  end
  if (port == nil) then 
    log.warn("\'port\' parameter must be a number, but instead a "  .. type(port)     .. " was provided. Using default http port " .. tostring(DEFAULT_PORTS.http))
  end
  if (type(protocol) ~= "string") then
    log.warn("\'protocol\' parameter must be a string, but instead a " .. type(protocol) .. " was provided. Using default " .. PROTOCOLS.HTTP .. " protocol")
  end
 
  self.server   = server
  self.port     = port or DEFAULT_PORTS.http
  self.protocol = protocol or PROTOCOLS.HTTP

  log.debug("\'protocol\' is\' " .. tostring(protocol) .. "\t\'port\' is\' " .. tostring(port) .. "\t\'server\' is\' " .. tostring(server))
  
  return self
end

local function formatURL(url, port, protocol, path)
  local urlTemplate = "%s://%s:%d/%s"
  return urlTemplate:format(protocol, url, port, path)
end


function Broker:request(method, path, data, inputFormat, outputFormat)
  -- Default function values
  method       = method       or METHOD.POST
  inputFormat  = inputFormat  or CONTENTS.JSON
  outputFormat = outputFormat or CONTENTS.JSON

  log.debug("Encoding user provided data")
  local body = self:encodeData(data, inputFormat)
  
  local curl = "curl -k -i -X %s -H \'Accept:application/%s\' -H \'Content-Type:application/%s\' "
  curl = curl:format(method, outputFormat, inputFormat)
 
  url = formatURL(self.server, self.port, self.protocol, path)

  if (method == "GET") then
    curl = curl .. " \'" .. url .. "\'"
  else
    curl = curl .. " -d \'" .. body .. "\' \'" .. url .. "\'"
  end

  curl = curl .. " 2>&1"
  
  log.debug("curl request command string is: " .. curl)

  local handle = io.popen(curl)
  local result = handle:read("*a")  
  --local split = splitLines(result)
  handle:close()

  -- Looks for the start of the json. Very ugly, but it works :)
  local output = result:sub(result:find("\n{"), #result)
 
  return json.decode(output), output
end

function Broker:postJSON(path, data)
  return self:request(METHOD.POST, path, data)
end

function Broker:getJSON(path, data)
  return self:request(METHOD.GET, path, data)
end

function Broker:requestJSON(method, path, data)
  self:request(method, path, data)
end

function Broker:requestAndPrint(method, outputFormat, path, inputFormat, data, time)
  local _, responseStr = self:request(method, path, data, inputFormat, outputFormat)
  print("\n", responseStr)
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


