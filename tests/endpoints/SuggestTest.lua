-- Importing modules
local Suggest = require "elasticsearch.endpoints.Suggest"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.SuggestTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Suggest.new)
  local o = Suggest:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Suggest:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_suggest"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    ["my-suggestion"] = {
      text = "the amsterdma meetpu",
      term = {
        field = "body"
      }
    }
  }

  endpoint:setParams{
    body = {
      ["my-suggestion"] = {
        text = "the amsterdma meetpu",
        term = {
          field = "body"
        }
      }
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
