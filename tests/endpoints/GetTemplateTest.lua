-- Importing modules
local GetTemplate = require "elasticsearch.endpoints.GetTemplate"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.GetTemplateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(GetTemplate.new)
  local o = GetTemplate:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = GetTemplate:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_search/template/template_1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    id = "template_1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_search/template/template_1"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_not_nil(err)
end
