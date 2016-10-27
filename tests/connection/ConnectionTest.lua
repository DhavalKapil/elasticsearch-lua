-- Importing modules
local Connection = require "elasticsearch.connection.Connection"
local Logger = require "elasticsearch.Logger"
local getmetatable = getmetatable
local os = os

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.connection.ConnectionTest"

-- Declaring local variables
local con

-- Testing the constructor
function constructorTest()
  assert_function(Connection.new)
  local o = Connection:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_function(mt.request)
  assert_function(mt.ping)
  assert_function(mt.sniff)
  assert_function(mt.buildQuery)
  assert_function(mt.buildURI)
  assert_function(mt.markAlive)
  assert_function(mt.markDead)
  assert_function(mt.toString)
  assert_equal(mt, mt.__index)
end

-- The setup function to be called before every test
function setup()
  local logger = Logger:new()
  logger:setLogLevel("off")
  con = Connection:new{
    protocol = "http",
    host = "localhost",
    port = 9200,
    pingTimeout = 1,
    logger = logger,
    requestEngine = "LuaSocket"
  }
end

-- Testing the query builder
function queryBuilderTest()
  local q = {a="a_s", b="b_s"}
  local query = con:buildQuery(q)
  assert_true("a=a_s&b=b_s" == query or "b=b_s&a=a_s" == query)
  q = {a="a_s"}
  assert_equal("a=a_s", con:buildQuery(q))
end

-- Testing the URI builder
function buildURITest()
  local url = con:buildURI("/path", {a="a_s", b="b_s"})
  assert_true("http://localhost:9200/path?a=a_s&b=b_s" == url or 
    "http://localhost:9200/path?b=b_s&a=a_s" == url)
  url = con:buildURI("/path", {a="a_s"})
  assert_not_equal("http://localhost:9200/path?a=a_s&b=b_s", url)
end

-- Testing the request function
function requestTest()
  -- Valid request
  local response = con:request("GET", "/")
  assert_equal(1, response.code)
  assert_equal(200, response.statusCode)
  assert_table(response.headers)
  assert_equal("HTTP/1.1 200 OK", response.statusLine)
  -- Invalid request: 404
  response = con:request("GET", "/dkr0wifkvsdlwoejkfsd")
  assert_equal(1, response.code)
  assert_equal(404, response.statusCode)
  assert_table(response.headers)
  assert_equal("HTTP/1.1 404 Not Found", response.statusLine)
  -- Invalid request: Wrong port
  con.port = 9199
  response = con:request("GET", "/")
  assert_nil(response.code)
  -- Invalid request: Incorrect host
  con.host = "1.2.3.4"
  response = con:request("GET", "/", nil, nil, 1)
  assert_nil(response.code)
end

-- Testing the ping function
function pingTest()
  -- Valid
  assert_true(con:ping())
  assert_true(con.alive)
  -- Invalid port
  con.port = 9199
  assert_false(con:ping())
  assert_false(con.alive)
  -- Invalid host
  con.host = "1.2.3.4"
  assert_false(con:ping())
  assert_false(con.alive)
end

-- Testing sniff function
function sniffTest()
  -- Valid request
  local response = con:sniff()
  assert_equal(1, response.code)
  assert_equal(200, response.statusCode)
  assert_table(response.headers)
  assert_equal("HTTP/1.1 200 OK", response.statusLine)
  -- Invalid request: Wrong port
  con.port = 9199
  response = con:sniff()
  assert_nil(response.code)
  -- Invalid request: Incorrect host
  con.host = "1.2.3.4"
  response = con:sniff()
  assert_nil(response.code)
end

-- Testing function that marks a connection alive
function markAliveTest()
  local currentTime = os.time()
  con.alive = false
  con.lastPing = 0
  con.failedPings = 3
  con:markAlive()
  assert_true(con.alive)
  assert_true(currentTime <= con.lastPing)
  assert_equal(0, con.failedPings)
end

-- Testing function that marks a connection dead
function markDeadTest()
  local currentTime = os.time()
  con.alive = true
  con.lastPing = 0
  con.failedPings = 3
  con:markDead()
  assert_false(con.alive)
  assert_true(currentTime <= con.lastPing)
  assert_equal(4, con.failedPings)
end
