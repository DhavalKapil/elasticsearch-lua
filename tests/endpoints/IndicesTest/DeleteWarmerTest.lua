-- Importing modules
local DeleteWarmer = require "elasticsearch.endpoints.Indices.DeleteWarmer"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.DeleteWarmerTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(DeleteWarmer.new)
  local o = DeleteWarmer:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = DeleteWarmer:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "DELETE"
  mockTransport.uri = "/users/_warmer/user_12"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "users",
    name = "user_12"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error request
function requestErrorTest()
  mockTransport.method = "DELETE"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test"
  }

  local _, err = endpoint:request()
  assert_not_nil(err)

  endpoint:setParams{
    name = "name"
  }

  local _, err = endpoint:request()
  assert_not_nil(err)
end
