-- Importing modules
local PutSettings = require "elasticsearch.endpoints.Indices.PutSettings"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.PutSettingsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(PutSettings.new)
  local o = PutSettings:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = PutSettings:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/_settings"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/users/_settings"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "users"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
