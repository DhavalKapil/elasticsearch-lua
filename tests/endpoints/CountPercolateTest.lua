-- Importing modules
local CountPercolate = require "elasticsearch.endpoints.CountPercolate"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CountPercolateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(CountPercolate.new)
  local o = CountPercolate:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = CountPercolate:new{
    transport = mockTransport
  }
end

-- Testing without id
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/my-index/my-type/_percolate/count"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "my-index",
    type = "my-type"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing with id
function requestIdTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/my-index/my-type/my-id/_percolate/count"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "my-index",
    type = "my-type",
    id = "my-id"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
