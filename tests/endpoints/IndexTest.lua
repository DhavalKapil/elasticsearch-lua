-- Importing modules
local Index = require "elasticsearch.endpoints.Index"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndexTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Index.new)
  local o = Index:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Index:new{
    transport = mockTransport
  }
end

-- Testing put request
function requestPUTTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/twitter/_doc/1"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    user = "kimchy",
    post_date = "2009-11-15T14:12:12",
    message = "trying out Elasticsearch"
  }

  endpoint:setParams{
    index = "twitter",
    id = "1",
    body = {
      user = "kimchy",
      post_date = "2009-11-15T14:12:12",
      message = "trying out Elasticsearch"
    }
  }

  endpoint.endpointParams.createIfAbsent = false
  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing post request
function requestPOSTTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/twitter/_doc"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    user = "kimchy",
    post_date = "2009-11-15T14:12:12",
    message = "trying out Elasticsearch"
  }

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    body = {
      user = "kimchy",
      post_date = "2009-11-15T14:12:12",
      message = "trying out Elasticsearch"
    }
  }

  endpoint.endpointParams.createIfAbsent = false
  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing create request
function requestCreateTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/twitter/_doc/1/_create"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    user = "kimchy",
    post_date = "2009-11-15T14:12:12",
    message = "trying out Elasticsearch"
  }

  endpoint:setParams{
    index = "twitter",
    id = "1",
    body = {
      user = "kimchy",
      post_date = "2009-11-15T14:12:12",
      message = "trying out Elasticsearch"
    }
  }

  endpoint.endpointParams.createIfAbsent = true
  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing create request
function requestCreateTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/twitter/_doc"
  mockTransport.params = {
    op_type = "create"
  }
  mockTransport.body = parser.jsonEncode{
    user = "kimchy",
    post_date = "2009-11-15T14:12:12",
    message = "trying out Elasticsearch"
  }

  endpoint:setParams{
    index = "twitter",
    body = {
      user = "kimchy",
      post_date = "2009-11-15T14:12:12",
      message = "trying out Elasticsearch"
    }
  }

  endpoint.endpointParams.createIfAbsent = true
  local _, err = endpoint:request()
  assert_nil(err)
end
