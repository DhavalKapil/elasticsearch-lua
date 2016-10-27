-- Importing modules
local Close = require "elasticsearch.endpoints.Indices.Close"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.CloseTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Close.new)
  local o = Close:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Close:new{
    transport = mockTransport
  }
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/my_index/_close"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "my_index"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
