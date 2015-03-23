-- Prints mapping information

require "tests.elasticsearch.config"

broker:requestAndPrint(METHOD.GET, "myindex/_mapping")

