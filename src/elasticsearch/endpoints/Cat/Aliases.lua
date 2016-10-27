-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Aliases = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Aliases.allowedParams = {
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
function Aliases:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Aliases:getUri()
  local uri = "/_cat/aliases"

  if self.name ~= nil then
    uri = uri .. "/" .. self.name
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Aliases class
-------------------------------------------------------------------------------
function Aliases:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Aliases
