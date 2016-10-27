-- Importing modules
local GetWarmer = require "elasticsearch.endpoints.Indices.GetWarmer"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.GetWarmerTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(GetWarmer.new)
  local o = GetWarmer:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = GetWarmer:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_warmer"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing name request
function requestNameTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_warmer/user_21"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    name = "user_21"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_warmer"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing type request
function requestTypeTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_warmer"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index, type and name request
function requestIndexTypeNameTest()
  mockTransport.method = "GET"
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
  mockTransport.method = "GET"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_not_nil(err)
end
