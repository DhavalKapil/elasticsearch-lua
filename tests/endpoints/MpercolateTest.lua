-- Importing modules
local Mpercolate = require "elasticsearch.endpoints.Mpercolate"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.MpercolateTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Mpercolate.new)
  local o = Mpercolate:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Mpercolate:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/twitter/tweet/_mpercolate"
  mockTransport.params = {}

  local MpercolateBody = {
    {
      percolate = {
        index = "twitter",
        type = "tweet"
      }
    },
    {
      doc = {
        message = "some text"
      }
    }
  }

  mockTransport.body = ""
  for _id, item in pairs(MpercolateBody) do
    mockTransport.body = mockTransport.body .. parser.jsonEncode(item) .. "\n"
  end

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    body = MpercolateBody
  }
  local _, err = endpoint:request()
  assert_nil(err)
end
