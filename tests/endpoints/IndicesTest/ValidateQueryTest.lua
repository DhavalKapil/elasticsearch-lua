-- Importing modules
local ValidateQuery = require "elasticsearch.endpoints.Indices.ValidateQuery"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.ValidateQueryTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(ValidateQuery.new)
  local o = ValidateQuery:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = ValidateQuery:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_validate/query"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_validate/query"
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
  mockTransport.uri = "/tweet/_validate/query"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index and type request
function requestIndexTypeTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/_validate/query"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
