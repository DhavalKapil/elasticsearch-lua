-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Snapshots = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Snapshots.allowedParams = {
  ["local"] = true,
  ["ignore_unavailable"] = true,
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
function Snapshots:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Snapshots:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Cat Snapshots"
  end
  
  local uri = "/_cat/snapshots/" .. self.repository .. "/"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Snapshots class
-------------------------------------------------------------------------------
function Snapshots:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Snapshots
