require "broker"
require "utils.print"
require "unityTest"
require "log".level = "debug"

httpPort      = 8080  -- Outgoing http port
httpsPort     = 443 -- Outgoing https port

--SERVER        = "10.8.0.214"
SERVER        = "HWS01DEV"
PROTOCOL      = PROTOCOLS.HTTP
PORT          = httpPort

local broker = Broker (SERVER, PORT, PROTOCOL)

-- Just a syntatic sugar
local POST = METHOD.POST

local UserNotEnabledError = { ErrorName = "UserNotEnabledError", ErrorCode = 101 }
local AuthenticationError = { ErrorName = "AuthenticationError", ErrorCode = 102 }
local InvalidTokenError   = { ErrorName = "InvalidTokenError"  , ErrorCode = 103 }

-- Auxiliary variable used between tests
local token

local path = "WFS/Service/Impl/Authentication.svc/%s"


local function checkDefaultProfile(Profile)
  assertNotNil(Profile)
  
  assertNotNil(Profile.Mail)
  assertNotNil(Profile.Login)
  assertNotNil(Profile.Name)
  
  assertType(Profile.Mail , "string")
  assertType(Profile.Login, "string")
  assertType(Profile.Name , "string")

  assertEquals("daniel.hart@wradar.com.br", Profile.Mail)
  assertEquals("quality_1"                , Profile.Login)
  assertEquals("Quality Projid 1"         , Profile.Name)
end

local function checkToken(Token)
  assertNotNil(Token)

  assertNotNil(Token.Token)
  assertNotNil(Token.TimeLeft)

  assertType(Token.Token, "string")
  assertType(Token.TimeLeft, "number")
end

--[[ This test should receive an exception from the server ]]--
function testWrongLogin(data, err)
  local resultData, resultStr = broker:postJSON(path:format("Login"), data)
  local test = checkError(resultData, err)
end

function testFineLogin(data)
  local resultData, resultStr = broker:postJSON(path:format("Login"), data)
  
  assertType(resultData, "table")

  local Profile = resultData.Profile 
  local Token   = resultData.Token

  checkDefaultProfile(Profile)
  checkToken(Token)

  token = Token.Token
end

function testGetUserProfile()
  local resultData, resultStr = broker:postJSON(path:format("GetUserProfile"), token)
  assertType(resultData, "table")
  checkDefaultProfile(resultData)
end

function testRenewToken()
  local resultData, resultStr = broker:postJSON(path:format("RenewToken"), token)
  
  checkToken(resultData)
  
  -- Sending an invalid token to be renewed
  resultData, resultStr = broker:postJSON(path:format("RenewToken"), "cadcadcadvavad")
  checkError(resultData, InvalidTokenError)
end


function testInvalidateToken()
  local resultData, resultStr = broker:postJSON(path:format("InvalidateToken"), token)
  
  assertType(resultData, "boolean")
  assertEquals(resultData, true)
end

function testInvalidToken()
  local resultData, resultStr = broker:postJSON(path:format("GetUserProfile"), token)
  checkError(resultData, InvalidTokenError)
  
  resultData, resultStr = broker:postJSON(path:format("InvalidateToken"), token)
  checkError(resultData, InvalidTokenError)

  resultData, resultStr = broker:postJSON(path:format("RenewToken"), token)
  checkError(resultData, InvalidTokenError)
end

for i = 1, arg[1] or 1 do
  local wrongPass = { User = "quality_1",    Password = "qubit26000" } 
  local wrongUser = { User = "quality_1aaa", Password = "qubit2600"  } 
  local fineLogin = { User = "quality_1",    Password = "qubit2600"  }
  
  serverInfo()
  print()
  test(testWrongLogin     , "Test wrong password", wrongPass, AuthenticationError)
  test(testWrongLogin     , "Test wrong username", wrongUser, AuthenticationError)
  test(testFineLogin      , "Test fine login"    , fineLogin)
  test(testGetUserProfile , "Test user profile"  , fineLogin)
  test(testRenewToken     , "Test renew token")
  test(testInvalidateToken, "Test invalidate token")
  test(testInvalidToken   , "Test invalid token")
  serverInfo()
  print()
  testsSummary()
end

