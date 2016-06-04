-- Importing modules
local Create = require "elasticsearch.endpoints.Indices.Create"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.CreateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Create.new)
  local o = Create:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Create:new{
    transport = mockTransport
  }
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "PUT"
  mockTransport.uri = "/test"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "test"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing mapping request
function requestMappingTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/test"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    mappings = {
      type1 = {
        properties = {
          field1 = { type = "string", index = "not_analyzed" }
        }
      }
    }
  }

  endpoint:setParams{
    index = "test",
    body = {
      mappings = {
        type1 = {
          properties = {
            field1 = { type = "string", index = "not_analyzed" }
          }
        }
      }
    }
  }
  
  local _, err = endpoint:request()
  assert_nil(err)
end

