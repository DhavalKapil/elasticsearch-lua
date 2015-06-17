-- Importing modules
local stickyRoundRobinSelector = require "selector.StickyRoundRobinSelector"
local connection = require "connection.Connection"
local getmetatable = getmetatable

-- Declaring test module
module('tests.selector.StickyRoundRobinSelectorTest', lunit.testcase)

-- Declaring local variables
local sRRS
local connections

-- Testing the constructor
function constructorTest()
  assert_function(stickyRoundRobinSelector.new)
  local o = stickyRoundRobinSelector:new()
  assert_not_nil(o)
  local mt = getmetatable(o)
  assert_table(mt)
  assert_function(mt.selectNext)
  assert_equal(mt, mt.__index)
end

-- The setup function
function setup()
  connections = {}
  for i = 1, 5 do
    connections[i] = connection:new()
    -- For checking later on
    connections[i].id = i
  end
  sRRS = stickyRoundRobinSelector:new()
end

-- Testing select function
function selectNextTest()
  local con
  for i = 1, 3 do
    con = sRRS:selectNext(connections)
    if con.id ~= 1 then
      assert_false(true, "Next connection returned instead of the earlier one")
    end
  end
  -- Making the connection dead
  con.port = 9199
  con = sRRS:selectNext(connections)
  if con.id == 1 then
    assert_false(true, "Connection still returned after it died")
  end
  assert_true(true)
end
