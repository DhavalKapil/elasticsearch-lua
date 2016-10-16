-- Importing modules
local DeleteRepository = require "elasticsearch.endpoints.Snapshot.DeleteRepository"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.SnapshotTest.DeleteRepositoryTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(DeleteRepository.new)
  local o = DeleteRepository:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = DeleteRepository:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "DELETE"
  mockTransport.uri = "/_snapshot/my_backup"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    repository = "my_backup"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error request
function requestErrorTest()
  mockTransport.method = "DELETE"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_not_nil(err)
end
