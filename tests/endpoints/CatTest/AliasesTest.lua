-- Importing modules
local Aliases = require "elasticsearch.endpoints.Cat.Aliases"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CatTest.AliasesTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Aliases.new)
  local o = Aliases:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Aliases:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/aliases"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing name request
function requestNameTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/aliases/my_name"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    name = "my_name"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
