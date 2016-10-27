-- Importing modules
local Stats = require "elasticsearch.endpoints.Indices.Stats"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.StatsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Stats.new)
  local o = Stats:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Stats:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_stats"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/test/_stats"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing metric request
function requestMetricTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_stats/merge"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    metric = "merge"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index metric request
function requestIndexMetricTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/test/_stats/merge"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test",
    metric = "merge"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
