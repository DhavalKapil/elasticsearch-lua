-- Importing modules
local MSearch = require "elasticsearch.endpoints.MSearch"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.MSearchTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(MSearch.new)
  local o = MSearch:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = MSearch:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/test/_msearch"
  mockTransport.params = {}

  local testBody = {
    {
      query = {
        match_all = {}
      },
      from = 0,
      size = 10
    },
    {
      query = {
        match_all = {}
      }
    }
  }

  mockTransport.body = parser.jsonEncode(testBody[1]) .. "\n"
                      .. parser.jsonEncode(testBody[2]) .. "\n"

  endpoint:setParams{
    index = "test",
    body = testBody
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing 'all' request
function requestAllTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_all/test/_msearch"
  mockTransport.params = {}

  local testBody = {
    {
      query = {
        match_all = {}
      },
      from = 0,
      size = 10
    },
    {
      query = {
        match_all = {}
      }
    }
  }

  mockTransport.body = parser.jsonEncode(testBody[1]) .. "\n"
                      .. parser.jsonEncode(testBody[2]) .. "\n"

  endpoint:setParams{
    type = "test",
    body = testBody
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
