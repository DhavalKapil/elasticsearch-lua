-- Importing modules
local RoundRobinSelector = require "elasticsearch.selector.RoundRobinSelector"
local Connection = require "elasticsearch.connection.Connection"
local Logger = require "elasticsearch.Logger"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.selector.RoundRobinSelectorTest"

-- Declaring local variables
local rRS
local connections

-- Testing the constructor
function constructorTest()
  assert_function(RoundRobinSelector.new)
  local o = RoundRobinSelector:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_function(mt.selectNext)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  connections = {}
  local logger = Logger:new()
  logger:setLogLevel("off")
  for i = 1, 5 do
    connections[i] = Connection:new{
      protocol = "http",
      host = "localhost",
      port = 9200,
      username = nil,
      password = nil,
      pingTimeout = 1,
      logger = logger
    }
    -- For checking later on
    connections[i].id = i
  end
  rRS = RoundRobinSelector:new()
end

-- Testing select function
function selectNextTest()
  for i = 1, 10 do
    local con = rRS:selectNext(connections)
    local j = i
    if j > 5 then
      j = j - 5
    end
    if con.id ~= j then
      assert_false(true, "RoundRobinSelector test fail")
    end
  end
  assert_true(true)
end
