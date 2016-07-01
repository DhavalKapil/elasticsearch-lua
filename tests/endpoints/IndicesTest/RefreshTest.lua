-- Importing modules
local Refresh = require "elasticsearch.endpoints.Indices.Refresh"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.RefreshTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Refresh.new)
  local o = Refresh:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Refresh:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_refresh"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/test/_refresh"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
