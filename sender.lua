local json = require "json"
require "args"

-- The jsonStr and jsonTable are set on the args.lua file

if type(jsonData) == "table" then
  jsonData = json.encode(jsonData)
end

--local curl = [[curl -i -H 'Accept: application/json']] 
local curl = [[curl -i -H 'Content-type: application/json']] 

if (args.mode ~= "URL" and args.mode ~= "COOKIE") then
  curl = curl .. " -X " .. args.mode
end


if (args.mode == "URL") then
  curl = curl .. "?" .. args.query_string .. "=" .. jsonData--:gsub("^%s*(.-)%s*$", "%1") )
else
  curl = curl .. " -d \'" .. jsonData .. "\'"
end
curl = curl .. " " .. url

print("\n", curl, "\n")

os.execute(curl)

