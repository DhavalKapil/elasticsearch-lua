-- Importing modules
local Update = require "elasticsearch.endpoints.Update"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.Update"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Update.new)
  local o = Update:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Update:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/test/type1/1/_update"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    script = {
      inline = "ctx._source.counter += count",
      params = {
        count = 4
      }
    }
  }

  endpoint:setParams{
    index = "test",
    type = "type1",
    id = "1",
    body = {
      script = {
        inline = "ctx._source.counter += count",
        params = {
          count = 4
        }
      }
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
