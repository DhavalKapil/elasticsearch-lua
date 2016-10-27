-- Importing modules
local GetRepository = require "elasticsearch.endpoints.Snapshot.GetRepository"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.SnapshotTest.GetRepositoryTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(GetRepository.new)
  local o = GetRepository:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = GetRepository:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_snapshot"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end


-- Testing repository request
function requestRepositoryTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_snapshot/my_backup"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    repository = "my_backup"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
