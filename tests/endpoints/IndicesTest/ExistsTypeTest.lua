-- Importing modules
local ExistsType = require "elasticsearch.endpoints.Indices.ExistsType"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.ExistsTypeTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(ExistsType.new)
  local o = ExistsType:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = ExistsType:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/twitter/tweet"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error request
function requestErrorTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/twitter/tweet"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
  }

  local _, err = endpoint:request()
  assert_not_nil(err)

  endpoint:setParams{
    type = "tweet",
  }

  local _, err = endpoint:request()
  assert_not_nil(err)
end
