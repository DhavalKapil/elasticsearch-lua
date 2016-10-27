-- Importing modules
local DeleteByQuery = require "elasticsearch.endpoints.DeleteByQuery"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.DeleteByQueryTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(DeleteByQuery.new)
  local o = DeleteByQuery:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = DeleteByQuery:new{
    transport = mockTransport
  }
end

-- Testing without type
function requestTest()
  mockTransport.method = "DELETE"
  mockTransport.uri = "/twitter/_query"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing with type
function requestTypeTest()
  mockTransport.method = "DELETE"
  mockTransport.uri = "/twitter/tweet/_query"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
