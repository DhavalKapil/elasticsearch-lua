-- Importing modules
local GetMapping = require "elasticsearch.endpoints.Indices.GetMapping"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.GetMappingTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(GetMapping.new)
  local o = GetMapping:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = GetMapping:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_mapping"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/users/_mapping"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "users"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing name request
function requestTypeTest()
  mockTransport.method = "GET"
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
  mockTransport.method = "GET"
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
