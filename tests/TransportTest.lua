-- Importing modules
local staticConnectionPool = require "elasticsearch.connectionpool.StaticConnectionPool"
local roundRobinSelector = require "elasticsearch.selector.RoundRobinSelector"
local connection = require "elasticsearch.connection.Connection"
local Logger = require "elasticsearch.Logger"
local transport = require "elasticsearch.Transport"
local getmetatable = getmetatable
local print = print

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.TransportTest"

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
  local logger = Logger:new()
  logger:setLogLevel("off")
  for i = 1, 5 do
    connections[i] = connection:new{
      protocol = "http",
      host = "localhost",
      port = 9200,
      pingTimeout = 1,
      logger = logger
    }
    connections[i].id = i
  end
  connectionPool = staticConnectionPool:new{
    connections = connections,
    selector = roundRobinSelector:new(),
    pingTimeout = 60,
    maxPingTimeout = 3600,
    logger = logger
  }
  t = transport:new{
    connectionPool = connectionPool,
    maxRetryCount = 5
  }
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
  assert_nil(t:request('HEAD', ''))
end
