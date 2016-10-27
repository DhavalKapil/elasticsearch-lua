-- Importing modules
local NodesEndpoint = require "elasticsearch.endpoints.Nodes.NodesEndpoint"
local MockTransport = require "lib.MockTransport"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.NodesTest.NodesEndpointTest"

-- Declaring local variables
local endpoint
-- Testing the constructor
function constructorTest()
  assert_function(NodesEndpoint.new)
  local o = NodesEndpoint:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  endpoint = NodesEndpoint:new{}
end

-- setParamsTest
function setParamsTest()
  endpoint.allowedParams = {
    ["allowed_param"] = true
  }

  local err = endpoint:setParams{
    allowed_param = "this_is_allowed"
  }
  assert_nil(err)
  assert_equal("this_is_allowed", endpoint.params.allowed_param)

  err = endpoint:setParams{
    not_allowed_param = "this_is_not_allowed"
  }
  assert_equal("not_allowed_param is not an allowed parameter", err)
end
