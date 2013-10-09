----------------------------------------------------------
----------------------------------------------------------
--[[ DO NOT CHANGE THE FOLLOWING UPPERCASE TABLES!!!! ]]--
----------------------------------------------------------
----------------------------------------------------------

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

-------------------------------------------------------------------------
-------------------------------------------------------------------------
--[[ Change the values bellow according to your server configuration ]]--
-------------------------------------------------------------------------
-------------------------------------------------------------------------

verbose       = true  -- Just local output

httpPort      = 4530  -- Outgoing http port
httpsPort     = 45301 -- Outgoing https port
--httpsPort     = 443

SERVER        = "10.0.40.182"
--SERVER        = "10.0.40.11"
PROTOCOL      = PROTOCOLS.HTTPS
PORT          = httpsPort
