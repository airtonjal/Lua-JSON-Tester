local json = require "json"
require "args"

-- The jsonStr and jsonTable are set on the args.lua file

if jsonStr then 
  print("JSON String:\n" .. jsonStr)
end

if jsonTable then
  print(json.encode(jsonTable))
end

--table.foreach(json.decode(jsonStr), print)
--print(toStringArch(json.decode(jsonStr)))


