-- Importing modules
local StaticConnectionPool = require "elasticsearch.connectionpool.StaticConnectionPool"
local RoundRobinSelector = require "elasticsearch.selector.RoundRobinSelector"
local Connection = require "elasticsearch.connection.Connection"
local Logger = require "elasticsearch.Logger"
local getmetatable = getmetatable
local os = os

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.connectionpool.StaticConnectionPoolTest"

-- Declaring local variables
local connectionpool
local connections = {}

-- Testing constructor
function constructorTest()
  assert_function(StaticConnectionPool.new)
  local o = StaticConnectionPool:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_function(mt.nextConnection)
  assert_function(mt.connectionReady)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
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
  connectionpool = StaticConnectionPool:new{
    connections = connections,
    selector = RoundRobinSelector:new(),
    pingTimeout = 60,
    maxPingTimeout = 3600,
    logger = logger
  }
end

-- Testing function that determines whether connection is ready or not
function connectionReadyTest()
  local con = Connection:new()
  con.lastPing = os.time() - 10
  connectionpool.pingTimeout = 1
  connectionpool.maxPingTimeout = 1000
  con.failedPings = 1
  assert_true(connectionpool:connectionReady(con))
  con.failedPings = 3
  assert_true(connectionpool:connectionReady(con))
  con.failedPings = 5
  assert_false(connectionpool:connectionReady(con))
  connectionpool.maxPingTimeout = 9
  assert_true(connectionpool:connectionReady(con))
end

-- Testing next connection function
function nextConnectionTest()
  local con
  -- Setting all alive
  for i = 1, 5 do
    connections[i].alive = true
    connections[i].lastPing = os.time()
  end
  for i = 1, 10 do
    con = connectionpool:nextConnection()
    assert_table(con)
  end
  for i = 1, 4 do
    connections[i].alive = false
  end
  for i = 1, 10 do
    con = connectionpool:nextConnection()
    assert_true(con.alive)
    assert_equal(5, con.id)
  end
  -- Making connection ready to be revived
  connections[1].lastPing = 0
  con = connectionpool:nextConnection()
  assert_true(con.alive)
  assert_equal(1, con.id)
  -- All connections dead and not to be revived
  connections[1].alive = false
  connections[5].alive = false
  con = connectionpool:nextConnection()
  assert_table(con)
  con.alive = false
  -- All conections dead
  for i = 1, 5 do
    connections[i].port = 9199
  end
  con = connectionpool:nextConnection()
  assert_nil(con)
end
