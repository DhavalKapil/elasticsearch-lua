-- Importing modules
local Search = require "elasticsearch.endpoints.Search"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.SearchTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Search.new)
  local o = Search:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Search:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_search"
  mockTransport.params = {
    q = "user:kimchy"
  }
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    q = "user:kimchy"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing all request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_all/tweet/_search"
  mockTransport.params = {
    q = "user:kimchy"
  }
  mockTransport.body = nil

  endpoint:setParams{
    type = "tweet",
    q = "user:kimchy"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end