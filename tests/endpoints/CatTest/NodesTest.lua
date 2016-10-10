-- Importing modules
local Nodes = require "elasticsearch.endpoints.Cat.Nodes"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CatTest.NodesTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Nodes.new)
  local o = Nodes:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Nodes:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/nodes"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end
