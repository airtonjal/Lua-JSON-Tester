require "senderFunction"

status, url, jsonData = pcall(dofile, "post.lua")

-- If an error wais raised, it will be placed on the url variable
if not status then
  error("Could not load post.lua")
end

request(jsonData, url, "POST")

