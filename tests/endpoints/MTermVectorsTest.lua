-- Importing modules
local MTermVectors = require "elasticsearch.endpoints.MTermVectors"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.MTermVectorsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(MTermVectors.new)
  local o = MTermVectors:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = MTermVectors:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/test/type/_mtermvectors"
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
