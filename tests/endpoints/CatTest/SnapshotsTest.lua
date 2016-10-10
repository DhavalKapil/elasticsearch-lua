-- Importing modules
local Snapshots = require "elasticsearch.endpoints.Cat.Snapshots"
local parser = require "elasticsearch.parser"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.CatTest.SnapshotsTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Snapshots.new)
  local o = Snapshots:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Snapshots:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/snapshots/"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_not_nil(err)
end

-- Testing repositories request
function requestIndexTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_cat/snapshots/my_repository/"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    repository = "my_repository"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
