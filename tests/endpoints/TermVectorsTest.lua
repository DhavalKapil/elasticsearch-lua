-- Importing modules
local TermVectors = require "elasticsearch.endpoints.TermVectors"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.TermVectorsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(TermVectors.new)
  local o = TermVectors:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = TermVectors:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "POST"
  mockTransport.uri = "/twitter/tweet/1/_termvectors"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    index = "twitter",
    type = "tweet",
    id = "1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
