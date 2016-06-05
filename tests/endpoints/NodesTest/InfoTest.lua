-- Importing modules
local Info = require "elasticsearch.endpoints.Nodes.Info"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.NodesTest.InfoTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Info.new)
  local o = Info:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Info:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_nodes"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_nodes/node1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    node_id = "node1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index, metric request
function requestIndexMetricTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_nodes/node1/metric1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    node_id = "node1",
    metric = "metric1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
