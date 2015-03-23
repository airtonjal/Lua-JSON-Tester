local oo = require "loop.base"
require "broker"

ElasticsearchBroker = oo.class({}, Broker)

local DEFAULT_ES_PORT = 9200
local DEFAULT_ES_SERVER = "127.0.0.1"
local DEFAULT_ES_PROTOCOL = PROTOCOLS.HTTP

local request_path = "%s/_search"
function ElasticsearchBroker:__init(server, port, protocol)
  server   = server   or DEFAULT_ES_SERVER
  port     = port     or DEFAULT_ES_PORT
  protocol = protocol or DEFAULT_ES_PROTOCOL

  local broker = Broker(server, port, protocol)
  
  local self = oo.rawnew(self, {})
  
  self.broker = broker

  return self
end

local count_path = "%s/_count"
function ElasticsearchBroker:count(index)
  return self.broker:request(METHOD.GET, count_path:format(index))
end

function ElasticsearchBroker:dispatch(request)
  if (#request.data.aggs == 0) then
    request.data.aggs = nil
  end
  return self.broker:request(METHOD.POST, request_path:format(request.index), request.data)
end

Request = oo.class{}

function Request:__init(index)
  if (type(index) ~= "string") then
    error("\'index\' should be a string, instead " .. type(index) .. " was provided")
  end

  local self = oo.rawnew(self, {})
  self.index     = index
  self.data      = {}
  self.data.size = 0
  self.data.aggs = {}

  return self
end

-- Average aggregation
function Request:average(field, name)
  self.data.aggs = self.data.aggs or {}
  self.data.aggs[name] = { avg = { field = field } }
end

-- Terms aggregation
function Request:terms(field, name)
  self.data.aggs = self.data.aggs or {}
  self.data.aggs[name] = { terms = { field = field } }
end

function Request:exists(field)
  self.data.filter = { exists = { field = field } }
end

function Request:stats(field, name)
  self.data.aggs[name] = { stats = { field = field } }
end

function Request:filter(field, value)
  self.data.query = { filtered = { filter = { term = { [field] = value } } } }
end





