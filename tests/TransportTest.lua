-- Importing modules
local StaticConnectionPool = require "elasticsearch.connectionpool.StaticConnectionPool"
local RoundRobinSelector = require "elasticsearch.selector.RoundRobinSelector"
local Connection = require "elasticsearch.connection.Connection"
local Logger = require "elasticsearch.Logger"
local Transport = require "elasticsearch.Transport"
local getmetatable = getmetatable
local print = print

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.TransportTest"

-- Declaring local variables
local t

-- Testing the constructor
function constructorTest()
  assert_function(Transport.new)
  local o = Transport:new()
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
  local protocol = os.getenv("ES_TEST_PROTOCOL")
  if protocol == nil then protocol = "http" end
  local port = os.getenv("ES_TEST_PORT")
  if port == nil then port = 9200 end
  local username = os.getenv("ES_USERNAME")
  local password = os.getenv("ES_PASSWORD")
  for i = 1, 5 do
    connections[i] = Connection:new{
      protocol = protocol,
      host = "localhost",
      port = port,
      username = username,
      password = password,
      pingTimeout = 1,
      logger = logger,
      requestEngine = "LuaSocket"
    }
    connections[i].id = i
  end
  connectionPool = StaticConnectionPool:new{
    connections = connections,
    selector = RoundRobinSelector:new(),
    pingTimeout = 60,
    maxPingTimeout = 3600,
    logger = logger
  }
  t = Transport:new{
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
