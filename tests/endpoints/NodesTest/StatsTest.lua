-- Importing modules
local Stats = require "elasticsearch.endpoints.Nodes.Stats"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.NodesTest.StatsTest"

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
  mockTransport.uri = "/_nodes/stats"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing node metric request
function requestNodeMetricTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_nodes/node1/stats/metric1/index_metric1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    node_id = "node1",
    metric = "metric1",
    index_metric = "index_metric1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
