-- Importing modules
local Get = require "elasticsearch.endpoints.Indices.Get"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.GetTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Get.new)
  local o = Get:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Get:new{
    transport = mockTransport
  }
end

-- Testing Index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/i"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "i"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing Index request
function requestIndexFeatureTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/i/f"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "i",
    feature = "f"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
