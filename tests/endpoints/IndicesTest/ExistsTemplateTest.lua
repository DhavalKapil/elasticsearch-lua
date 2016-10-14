-- Importing modules
local ExistsTemplate = require "elasticsearch.endpoints.Indices.ExistsTemplate"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.ExistsTemplateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(ExistsTemplate.new)
  local o = ExistsTemplate:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = ExistsTemplate:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/_template/user_12"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    name = "user_12"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error request
function requestErrorTest()
  mockTransport.method = "HEAD"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_not_nil(err)
end
