-- Importing modules
local FieldStats = require "elasticsearch.endpoints.FieldStats"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.FieldStatsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(FieldStats.new)
  local o = FieldStats:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = FieldStats:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_field_stats"
  mockTransport.params = {
    fields = "rating"
  }
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    fields = "rating"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
