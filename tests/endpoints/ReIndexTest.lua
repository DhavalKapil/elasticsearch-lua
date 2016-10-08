-- Importing modules
local ReIndex = require "elasticsearch.endpoints.ReIndex"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.ReIndexTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(ReIndex.new)
  local o = ReIndex:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = ReIndex:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/_reindex"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    source = {
      index = "twitter"
    },
    dest = {
      index = "new_twitter"
    }
  }

  endpoint:setParams{
    body = {
      source = {
        index = "twitter"
      },
      dest = {
        index = "new_twitter"
      }
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
