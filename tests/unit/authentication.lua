require "config"
require "senderFunction"
require "utils"
require "unityTest"

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
  local resultData, resultStr = requestJSON(serverAddress, httpsPort, PROTOCOLS.HTTPS, METHOD.POST, path:format("Login"), data, true)
  local test = checkError(resultData, err.ErrorCode, err.ErrorName)
end

function testFineLogin(data)
  local resultData, resultStr = requestJSON(serverAddress, httpsPort, PROTOCOLS.HTTPS, METHOD.POST, path:format("Login"), data, true)
  
  assertType(resultData, "table")

  local Profile = resultData.Profile 
  local Token   = resultData.Token

  checkDefaultProfile(Profile)
  checkToken(Token)

  token = Token.Token
end

function testGetUserProfile()
  local resultData, resultStr = requestJSON(serverAddress, httpsPort, PROTOCOLS.HTTPS, METHOD.POST, path:format("GetUserProfile"), token, true)
  assertType(resultData, "table")
  checkDefaultProfile(resultData)
end

function testInvalidateToken()
  local resultData, resultStr = requestJSON(serverAddress, httpsPort, PROTOCOLS.HTTPS, METHOD.POST, path:format("InvalidateToken"), token, true)
  
  assertType(resultData, "boolean")
  assertEquals(resultData, true)
end

function testInvalidToken()
  local resultData, resultStr = requestJSON(serverAddress, httpsPort, PROTOCOLS.HTTPS, METHOD.POST, path:format("GetUserProfile"), token, true)
  checkError(resultData, InvalidTokenError.ErrorCode, InvalidTokenError.ErrorName)
end

for i = 1, arg[1] or 1 do
  local wrongPass = { User = "quality_1",    Password = "qubit26000" } 
  local wrongUser = { User = "quality_1aaa", Password = "qubit2600" } 
  local fineLogin = { User = "quality_1",    Password = "qubit2600" }
  
  print()
  test(testWrongLogin     , "Test wrong password"  , wrongPass, AuthenticationError)
  test(testWrongLogin     , "Test wrong username"  , wrongUser, AuthenticationError)
  test(testFineLogin      , "Test fine login"      , fineLogin)
  test(testGetUserProfile , "Test user profile"    , fineLogin)
  test(testInvalidateToken, "Test invalidate token")
  test(testInvalidToken   , "Test invalid token")
  print()
  testsSummary()
end

