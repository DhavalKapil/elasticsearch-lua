-- Importing modules
local HotThreads = require "elasticsearch.endpoints.Nodes.HotThreads"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.NodesTest.HotThreadsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(HotThreads.new)
  local o = HotThreads:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = HotThreads:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cluster/nodes/hotthreads"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cluster/nodes/node1/hotthreads"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    node_id = "node1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
