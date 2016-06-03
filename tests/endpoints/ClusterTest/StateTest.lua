-- Importing modules
local State = require "elasticsearch.endpoints.Cluster.State"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.ClusterTest.StateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(State.new)
  local o = State:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = State:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cluster/state"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing request
function requestMetricsTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cluster/state"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing metric request
function requestMetricTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cluster/state/m"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    metric = "m"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing metric, index request
function requestMetricIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cluster/state/m/i"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    metric = "m",
    index = "i"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
