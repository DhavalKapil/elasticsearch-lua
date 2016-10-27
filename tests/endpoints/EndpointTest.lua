-- Importing modules
local Endpoint = require "elasticsearch.endpoints.Endpoint"
local parser = require "elasticsearch.parser"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.endpoints.EndpointTest"

-- Declaring local variables
local e

-- Testing the constructor
function constructorTest()
  assert_function(Endpoint.new)
  local o = Endpoint:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_function(mt.setBody)
  assert_function(mt.setParams)
  assert_function(mt.request)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  e = Endpoint:new()
  e.allowedParams = {
    ["allowed_param"] = true
  }
end

-- Testing setBody with non bulk body
function setNonBulkBodyTest()
  local testBody = {
    a = "b",
    c = "d"
  }
  local expectedOutput = parser.jsonEncode(testBody)

  e.bulkBody = false
  e:setBody(testBody)
  assert_equal(expectedOutput, e.body)
end

-- Testing setBody with bulk body
function setBulkBodyTest()
  local testBody = {
    {
      a = "b",
      c = "d"
    },
    {
      e = "f",
      g = "h"
    }
  }
  local expectedOutput = parser.jsonEncode(testBody[1]) .. "\n"
                      .. parser.jsonEncode(testBody[2]) .. "\n"
  
  e.bulkBody = true
  e:setBody(testBody)
  assert_equal(expectedOutput, e.body)
end

-- Testing setParams with standard params
function setStandardParamsTest()
  local testParams = {
    index = "my_index",
    type = "my_type",
    id = "my_id",
    body = {
      a = "b"
    }
  }
  local actualBody = parser.jsonEncode(testParams.body)

  local err = e:setParams(testParams)
  assert_nil(err)
  assert_equal("my_index", e.index)
  assert_equal("my_type", e.type)
  assert_equal("my_id", e.id)
  assert_equal(actualBody, e.body)
end

-- Testing allowed params
function setAllowedParamsTest()
  local testParams = {
    index = "my_index",
    allowed_param = "this_is_allowed"
  }

  local err = e:setParams(testParams)
  assert_nil(err)
  assert_equal("my_index", e.index)
  assert_equal("this_is_allowed", e.params.allowed_param)
end

-- Testing not allowed params
function setNotAllowedParamsTest()
  local testParams = {
    index = "my_index",
    not_allowed_param = "this_is_not_allowed"
  }

  local err = e:setParams(testParams)
  assert_string(err)
end
