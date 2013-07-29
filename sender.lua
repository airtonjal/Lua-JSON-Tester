local json = require "json"
require "args"

-- The jsonStr and jsonTable are set on the args.lua file

if jsonStr then 
  print("JSON String:\n" .. jsonStr)
end

if jsonTable then
  print(json.encode(jsonTable))
end

if (args.mode == "URL") then
  local query_string = args.name
  print(query_string)
end

local curl = [[curl -i -H "Accept: application/json"]] 

if (args.mode ~= "URL" and args.mode ~= "COOKIE") then
  curl = curl .. " -X " .. args.mode
end

curl = curl .. " " .. url

