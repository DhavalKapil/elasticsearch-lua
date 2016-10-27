-- Importing modules
local ClearCache = require "elasticsearch.endpoints.Indices.ClearCache"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.ClearCacheTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(ClearCache.new)
  local o = ClearCache:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = ClearCache:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/_cache/clear"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/twitter/_cache/clear"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
