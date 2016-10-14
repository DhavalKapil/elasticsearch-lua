-- Importing modules
local PutMapping = require "elasticsearch.endpoints.Indices.PutMapping"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.PutMappingTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(PutMapping.new)
  local o = PutMapping:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = PutMapping:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/_mapping"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_not_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/users/_mapping"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "users"
  }

  local _, err = endpoint:request()
  assert_not_nil(err)
end

-- Testing name request
function requestTypeTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/_mapping/user_12"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    type = "user_12"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index and name request
function requestIndexTypeTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/users/_mapping/user_12"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "users",
    type = "user_12"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
