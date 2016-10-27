-- Importing modules
local SearchShards = require "elasticsearch.endpoints.SearchShards"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.SearchShardsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(SearchShards.new)
  local o = SearchShards:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = SearchShards:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_search_shards"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
