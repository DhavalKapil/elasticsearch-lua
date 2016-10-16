-- Importing modules
local Get = require "elasticsearch.endpoints.Tasks.Get"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.TasksTest.GetTest"

-- Declaring local variables
local endpoint
local mockTransport = MockTransport:new()

-- Testing the constructor
function constructorTest()
  assert_function(Get.new)
  local o = Get:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = Get:new{
    transport = mockTransport
  }
end

-- Testing request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_tasks"
  mockTransport.params = {}
  mockTransport.body = nil

  local _, err = endpoint:request()
  assert_nil(err)
end

-- Testing task_id request
function requestTest()
  mockTransport.method = "GET"
  mockTransport.uri = "/_tasks/taskId1"
  mockTransport.params = {}
  mockTransport.body = nil

  endpoint:setParams{
    task_id = "taskId1"
  }

  local _, err = endpoint:request()
  assert_nil(err)
end
