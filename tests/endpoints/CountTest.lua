-- Importing modules
local Count = require "elasticsearch.endpoints.Count"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CountTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Count.new)
  local o = Count:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Count:new{
    transport = mockTransport
  }
end

-- Testing request
function request1Test()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/_count"
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

-- Testing request
function request2Test()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/_count"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    query = {
      term = {
        user = "kimchy"
      }
    }
  }

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    body = {
      query = {
        term = {
          user = "kimchy"
        }
      }
    }
  }
  local _, err = endpoint:request()
  assert_nil(err)
end
