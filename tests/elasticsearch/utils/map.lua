-- Prints mapping information

require "tests.elasticsearch.config"

local index = "pchrindex"
broker:requestAndPrint(METHOD.GET, index .. "/_mapping")

