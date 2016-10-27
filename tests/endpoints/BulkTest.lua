-- Importing modules
local Bulk = require "elasticsearch.endpoints.Bulk"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.BulkTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Bulk.new)
  local o = Bulk:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Bulk:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/my_index/_bulk"
  mockTransport.params = {}

  local bulkBody = {
    {
      index = {
        _index = "test",
        _type = "type1",
        _id = "1"
      }
    },
    {
      field1 = "value1"
    }
  }

  mockTransport.body = ""
  for _id, item in pairs(bulkBody) do
    mockTransport.body = mockTransport.body .. parser.jsonEncode(item) .. "\n"
  end

  endpoint:setParams{
    index = "my_index",
    body = bulkBody
  }
  local _, err = endpoint:request()
  assert_nil(err)
end
