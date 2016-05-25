-- Importing modules
local Explain = require "elasticsearch.endpoints.Explain"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.ExplainTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Explain.new)
  local o = Explain:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Explain:new{
    transport = mockTransport
  }
end

-- Testing request
function request1Test()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/1/_explain"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    query = {
      term = {
        message = "search"
      }
    }
  }

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    id = "1",
    body = {
      query = {
        term = {
          message = "search"
        }
      }
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing request
function request2test()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/1/_explain"
  mockTransport.params = {
    q = "message:search"
  }
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    id = "1",
    q = "message:search"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
