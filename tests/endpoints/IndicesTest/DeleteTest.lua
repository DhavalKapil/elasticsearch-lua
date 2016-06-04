-- Importing modules
local Delete = require "elasticsearch.endpoints.Indices.Delete"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.DeleteTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Delete.new)
  local o = Delete:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Delete:new{
    transport = mockTransport
  }
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "DELETE"
  mockTransport.uri = "/test"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
