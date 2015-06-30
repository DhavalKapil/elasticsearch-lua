-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Search = Endpoint:new()

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Search:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Search:getUri()
  if self.index ~= nil and self.type ~= nil then
    return "/" .. self.index .. "/" .. self.type .. "/_search"
  elseif self.index ~= nil and self.type == nil then
    return "/" .. self.index .. "/_search"
  elseif self.index == nil and self.type ~= nil then
    return "/_all/" .. self.type .. "/_search"
  end
  -- Both are nil
  return "/_search"
end

-------------------------------------------------------------------------------
-- Returns an instance of Search class
-------------------------------------------------------------------------------
function Search:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Search
