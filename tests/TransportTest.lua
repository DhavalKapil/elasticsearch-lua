-- Importing modules
local staticConnectionPool = require "connectionpool.StaticConnectionPool"
local roundRobinSelector = require "selector.RoundRobinSelector"
local connection = require "connection.Connection"
local transport = require "Transport"
local getmetatable = getmetatable
local print = print

-- Declaring test module
module('tests.TransportTest', lunit.testcase)

-- Declaring local variables
local t

-- Testing the constructor
function constructorTest()
  assert_function(transport.new)
  local o = transport:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_function(mt.getConnection)
  assert_function(mt.request)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  local connections = {}
  for i = 1, 5 do
    connections[i] = connection:new()
    connections[i].id = i
  end
  connectionPool = staticConnectionPool:new{
    connections = connections,
    selector = roundRobinSelector:new()
  }
  t = transport:new{connectionPool = connectionPool}
end

-- Returns true if the reponse is valid 200
function isResponseValid(response)
  return response.code ~= nil and response.statusCode == 200
end

-- Testing the request function
function requestTest()
  for i = 1, 10 do
    assert_true(isResponseValid(t:request('HEAD', '')))
  end
  -- making 4 connections down
  for i = 1, 4 do
    t.connectionPool.connections[i].port = 9199
  end
  for i = 1, 10 do
    assert_true(isResponseValid(t:request('HEAD', '')))
  end
  t.connectionPool.connections[5].port = 9199
  assert_error(function()
    t:request('HEAD', '')
  end)
end
