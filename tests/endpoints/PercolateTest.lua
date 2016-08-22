-- Importing modules
local Percolate = require "elasticsearch.endpoints.Percolate"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.PercolateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Percolate.new)
  local o = Percolate:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Percolate:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/_percolate"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing request with id
function requestIdTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/tweet/1/_percolate"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    id = "1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
