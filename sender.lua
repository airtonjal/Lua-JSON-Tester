local json = require "json"
require "args"

-- The jsonStr and jsonTable are set on the args.lua file

if type(jsonData) == "table" then
  jsonData = json.encode(jsonData)
end

--local curl = [[curl -i -H 'Accept: application/json']] 
--local curl = [[curl -i -H 'Content-type: application/json']] 
local curl = "curl -i %s -H \'Accept:application/json\' -H \'Content-Type:application/json\' "

local modeCmd
if (args.mode ~= "URL" and args.mode ~= "COOKIE") then
  modeCmd = "-X " .. args.mode
else
  modeCmd = ""
end

curl = curl:format(modeCmd)
curl = curl .. " -d " .. json.encode(jsonData) .. " \'" .. url .. "\'"

--if (args.mode == "URL") then
--  curl = curl .. "?" .. args.query_string .. "=" .. jsonData--:gsub("^%s*(.-)%s*$", "%1") )
--else
--curl = curl:format(json.encode(jsonData))
--end
--curl = curl .. " " .. url

print("\n", curl, "\n")

os.execute(curl)

