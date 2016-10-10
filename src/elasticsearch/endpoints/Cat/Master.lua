-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Master = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Master.allowedParams = {
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
function Master:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Master:getUri()
  local uri = "/_cat/master"  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Master class
-------------------------------------------------------------------------------
function Master:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Master
