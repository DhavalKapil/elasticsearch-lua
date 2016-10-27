-- Importing modules
local RenderSearchTemplate = require "elasticsearch.endpoints.RenderSearchTemplate"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.RenderSearchTemplateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(RenderSearchTemplate.new)
  local o = RenderSearchTemplate:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = RenderSearchTemplate:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_render/template/my_id"
  mockTransport.params = {}
  mockTransport.body = parser.jsonEncode{
    params = {
      status = { "pending", "published" }
    }
  }

  endpoint:setParams{
    id = "my_id",
    body = {
      params = {
        status = { "pending", "published" }
      }
    }
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
