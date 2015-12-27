-- Ignore this line
package.path = package.path .. ";../src/?.lua"

-- Import Selector
local Selector = require "elasticsearch.selector.Selector"

-- Create a custom instace
local MySelector = Selector:new()

-- Implement selectNext(connections) function for MySelector
function MySelector:selectNext(connections)
  -- Return a connection depending on your custom algorithm
  return connection[1]
end

-- Implement the constructor function
function MySelector:new(o)
  o = o or {}
  -- Custom initialization code related to your algorithm
  -- End custom code
  setmetatable(o, self)
  self.__index = self
  return o
end

local elasticsearch = require "elasticsearch"

local client = elasticsearch.client{
  params = {
    selector = MySelector
  }
}