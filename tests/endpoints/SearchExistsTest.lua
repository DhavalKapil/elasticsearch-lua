-- Importing modules
local SearchExists = require "elasticsearch.endpoints.SearchExists"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.SearchExistsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(SearchExists.new)
  local o = SearchExists:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = SearchExists:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/_search/exists"
  mockTransport.params = {
    q = "user:kimchy"
  }
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    q = "user:kimchy"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
