-- Importing modules
local Mget = require "elasticsearch.endpoints.Mget"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.MgetTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Mget.new)
  local o = Mget:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Mget:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/test/type/_mget"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    ids = {"1", "2"}
  }

  endpoint:setParams{
    index = "test",
    type = "type",
    body = {
      ids = {"1", "2"}
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
