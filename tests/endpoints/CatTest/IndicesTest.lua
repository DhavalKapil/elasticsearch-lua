-- Importing modules
local Indices = require "elasticsearch.endpoints.Cat.Indices"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CatTest.IndicesTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Indices.new)
  local o = Indices:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Indices:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/indices"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/indices/my_index"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "my_index"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
