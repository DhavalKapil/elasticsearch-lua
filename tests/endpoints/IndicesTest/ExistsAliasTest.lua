-- Importing modules
local ExistsAlias = require "elasticsearch.endpoints.Indices.ExistsAlias"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.ExistsAliasTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(ExistsAlias.new)
  local o = ExistsAlias:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = ExistsAlias:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/_alias"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/users/_alias"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "users"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing name request
function requestNameTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/_alias/user_12"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    name = "user_12"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index and name request
function requestIndexNameTest()
  mockTransport.method = "HEAD"
  mockTransport.uri = "/users/_alias/user_12"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "users",
    name = "user_12"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
