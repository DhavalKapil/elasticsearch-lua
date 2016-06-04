-- Importing modules
local Optimize = require "elasticsearch.endpoints.Indices.Optimize"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.OptimizeTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Optimize.new)
  local o = Optimize:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Optimize:new{
    transport = mockTransport
  }
end

-- Testing Index request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/_optimize"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end
