-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Recovery = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Recovery.allowedParams = {
  ["bytes"] = true,
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
function Recovery:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Recovery:getUri()
  local uri = "/_cat/recovery"

  if self.index ~= nil then
    uri = uri .. "/" .. self.index
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Recovery class
-------------------------------------------------------------------------------
function Recovery:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Recovery
