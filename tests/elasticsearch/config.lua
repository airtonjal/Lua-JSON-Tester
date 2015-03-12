require "broker"
require "utils.print"
log = require "log"
log.level = "info"

path = "pchrindex/_search?pretty"
broker = Broker ("ampere.poc.wr01.wradar.br", 9200, PROTOCOLS.HTTP)
