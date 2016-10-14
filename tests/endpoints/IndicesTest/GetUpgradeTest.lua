-- Importing modules
local GetUpgrade = require "elasticsearch.endpoints.Indices.GetUpgrade"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.GetUpgradeTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(GetUpgrade.new)
  local o = GetUpgrade:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = GetUpgrade:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_upgrade"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{}

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing name request
function requestNameTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_upgrade"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
