-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Allocation = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Allocation.allowedParams = {
  ["bytes"] = true,
  ["local"] = true,
  ["master_timeout"] = true,
  ["h"] = true,
  ["help"] = true,
  ["v"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Allocation:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Allocation:getUri()
  local uri = "/_cat/allocation"

  if self.nodeId ~= nil then
    uri = uri .. "/" .. self.nodeId
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Allocation class
-------------------------------------------------------------------------------
function Allocation:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Allocation
