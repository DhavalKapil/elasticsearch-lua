-- Importing modules
local Allocation = require "elasticsearch.endpoints.Cat.Allocation"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CatTest.AllocationTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Allocation.new)
  local o = Allocation:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Allocation:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/allocation"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing node_id request
function requestNodeIdTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/allocation/my_node_id"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    node_id = "my_node_id"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
