-- Importing modules
local GetFieldMapping = require "elasticsearch.endpoints.Indices.GetFieldMapping"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.IndicesTest.GetFieldMappingTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(GetFieldMapping.new)
  local o = GetFieldMapping:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = GetFieldMapping:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_mapping/field/text"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    fields = "text"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_mapping/field/text"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    fields = "text"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing name request
function requestTypeTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_mapping/tweet/field/text"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    type = "tweet",
    fields = "text"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing index and name request
function requestIndexTypeTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_mapping/tweet/field/text"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    fields = "text"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error
function requestErrorTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/twitter/_mapping/tweet/field/text"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
  }

  local _, err = endpoint:request()
  assert_not_nil(err)
end
