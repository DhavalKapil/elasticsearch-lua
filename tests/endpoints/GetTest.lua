-- Importing modules
local Get = require "elasticsearch.endpoints.Get"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.GetTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Get.new)
  local o = Get:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Get:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_doc/1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    id = "1"
  }

  endpoint.endpointParams.checkOnlyExistance = false
  endpoint.endpointParams.sourceOnly = false
  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing exists
function existsTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/twitter/_doc/1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    id = "1"
  }

  endpoint.endpointParams.checkOnlyExistance = true
  endpoint.endpointParams.sourceOnly = false
  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing source
function sourceTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_doc/1/_source"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    id = "1"
  }

  endpoint.endpointParams.checkOnlyExistance = false
  endpoint.endpointParams.sourceOnly = true
  local _, err = endpoint:request()
  assert_nil(err)
end
