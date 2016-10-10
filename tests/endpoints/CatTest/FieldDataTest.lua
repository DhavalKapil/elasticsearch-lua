-- Importing modules
local FieldData = require "elasticsearch.endpoints.Cat.FieldData"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CatTest.FieldDataTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(FieldData.new)
  local o = FieldData:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = FieldData:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/fielddata"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing fields request
function requestFieldsTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/fielddata/my_fields"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    fields = "my_fields"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
