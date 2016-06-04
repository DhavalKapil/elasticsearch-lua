-- Importing modules
local Exists = require "elasticsearch.endpoints.Indices.Exists"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.ExistsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Exists.new)
  local o = Exists:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Exists:new{
    transport = mockTransport
  }
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/test"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
