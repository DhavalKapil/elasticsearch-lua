-- Importing modules
local Flush = require "elasticsearch.endpoints.Indices.Flush"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.FlushTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Flush.new)
  local o = Flush:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Flush:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_flush"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/test/_flush"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing Index synced request
function requestIndexSyncTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/test/_flush/synced"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test",
    sync = true
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
