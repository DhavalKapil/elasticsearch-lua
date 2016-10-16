-- Importing modules
local Status = require "elasticsearch.endpoints.Snapshot.Status"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.SnapshotTest.StatusTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Status.new)
  local o = Status:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Status:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_snapshot/my_backup/_status"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    repository = "my_backup",
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing snapshot request
function requestSnapshotTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_snapshot/my_backup/snapshot_1/_status"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    repository = "my_backup",
    snapshot = "snapshot_1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing error request
function requestErrorTest()
  mockTransport.method = "PUT"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_not_nil(err)

  endpoint:setParams{
    snapshot = "snapshot_1"
  }

  local _, err = endpoint:request()
  assert_not_nil(err)
end
