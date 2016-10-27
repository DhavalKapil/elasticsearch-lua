-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Indices = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Indices.allowedParams = {
  ["bytes"] = true,
  ["local"] = true,
  ["master_timeout"] = true,
  ["h"] = true,
  ["help"] = true,
  ["pri"] = true,
  ["v"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Indices:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Indices:getUri()
  local uri = "/_cat/indices"

  if self.index ~= nil then
    uri = uri .. "/" .. self.index
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Indices class
-------------------------------------------------------------------------------
function Indices:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Indices
