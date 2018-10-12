-- Importing modules
local RandomSelector = require "elasticsearch.selector.RandomSelector"
local Connection = require "elasticsearch.connection.Connection"
local Logger = require "elasticsearch.Logger"
local getmetatable = getmetatable

-- Setting up environment
local _ENV = lunit.TEST_CASE "tests.selector.RandomSelectorTest"

-- Declaring local variables
local rS
local connections

-- Testing the constructor
function constructorTest()
  assert_function(RandomSelector.new)
  local o = RandomSelector:new()
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
  rS = RandomSelector:new()
end

-- Testing select function
function selectNextTest()
  local count = {}
  -- Initial count of each of the 5 connections
  for i = 1, 5 do
    count[i] = 0
  end
  -- Selecting random connections 1000 times
  for i = 1, 1000 do
    local con = rS:selectNext(connections)
    count[con.id] = count[con.id] + 1
  end
  for i = 1, 5 do
    if count[i] < 150 then
      assert_false(true, "Random number generator used is not quite random")
    end
  end
  assert_true(true)
end
