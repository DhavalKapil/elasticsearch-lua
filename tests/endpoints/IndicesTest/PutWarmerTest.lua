-- Importing modules
local PutWarmer = require "elasticsearch.endpoints.Indices.PutWarmer"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.PutWarmerTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(PutWarmer.new)
  local o = PutWarmer:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = PutWarmer:new{
    transport = mockTransport
  }
end

-- Testing name request
function requestNameTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/_warmer/user_21"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    name = "user_21"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index name request
function requestIndexNameTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/twitter/_warmer/user_21"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    name = "user_21"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing type name request
function requestTypeNameTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/_warmer/user_21"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    type = "tweet",
    name = "user_21"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index, type and name request
function requestIndexTypeNameTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/twitter/tweet/_warmer/user_21"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    name = "user_21"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error request
function requestErrorTest()
  mockTransport.method = "PUT"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_not_nil(err)
end
