-- Importing modules
local Scroll = require "elasticsearch.endpoints.Scroll"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.ScrollTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Scroll.new)
  local o = Scroll:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Scroll:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_search/scroll"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    scroll = "1m", 
    scroll_id = "c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1" 
  }

  endpoint.endpointParams.clear = false
  endpoint:setParams{
    body = {
      scroll = "1m", 
      scroll_id = "c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1" 
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing scroll id request
function requestScrollIdTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_search/scroll/c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    scroll = "1m"
  }

  endpoint.endpointParams.clear = false
  endpoint:setParams{
    scroll_id = "c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1",
    body = {
      scroll = "1m"
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing clear request
function requestClearTest()
  mockTransport.method = "DELETE"
  mockTransport.uri = "/_search/scroll/c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint.endpointParams.clear = true
  endpoint:setParams{
    scroll_id = "c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
